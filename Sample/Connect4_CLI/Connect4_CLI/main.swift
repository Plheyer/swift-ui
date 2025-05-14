import Foundation
import Connect4Core
import Connect4Rules
import Connect4Players
import Connect4Persistance

var game: Game? = nil
var rules: Rules?
var nbRows: Int = 0
var nbColumns: Int = 0
var nbPiecesToAlign: Int = 0
var players: [Player] = []

func readInt(withMessage message: String) -> Int {
    var temp: Int?
    while temp == nil {
        print(message)
        let result = readLine()
        temp = Int(result ?? "")
    }
    return temp!
}

func readMove(from player: HumanPlayer) -> Move? {
    guard let game else { return nil }
    if game.rules is Connect4Rules || game.rules is PopOutRules {
        let column = readInt(withMessage: "\(player.name) please enter the column in which you want to play") - 1
        return Move(of: player.id, toRow: 0, toColumn: column)
    }
    if game.rules is TicTacToeRules {
        let row = readInt(withMessage: "\(player.name) please enter the row in which you want to play") - 1
        let column = readInt(withMessage: "\(player.name) please enter the column in which you want to play") - 1
        return Move(of: player.id, toRow: row, toColumn: column)
    }
    return nil
}

func readChoice(withMessage message: String, among choices: [String]) -> String {
    var temp: String?
    while temp == nil {
        print(message)
        for choice in choices.enumerated() {
            print("\t\(choice.offset). \(choice.element)")
        }
        let result = readLine()
        if let i = Int(result ?? ""), (0..<choices.count).contains(i) {
            temp = choices[i]
        }
    }
    return temp!
}

@MainActor
func startMenu() async throws {
    print("Would you like to:")
    print("1. Start a new game")
    print("2. Load the last saved game")
    print("3. Display game results")
    print("4. Replay last game")

    
    let choice = readLine()
    switch choice {
    case "2":
        //load the last saved game
        game = try! await Persistance.loadGame(withName: "savedGame.co4", withFolderName: "connect4.games")
        for player in game!.players.values {
            if player is HumanPlayer {
                (player as! HumanPlayer).changeInput { readMove(from: $0)}
            }
        }
    case "3":
            //display game results
        try await loadGameResults()
    case "4":
        try await replayLastGame()
    default:
        //menu game configuration
        gameConfigurationMenu()
    }
}

@MainActor
func replayLastGame() async throws {
    game = try await Game(fromSavedGame: "savedGame.co4", inFolder: "connect4.games")
}

func formatResult(_ result: GameResult) throws {
    let pl1 = result.players[0]
    let pl2 = result.players[1]
    if result.winner == .noOne {
        print("\(result.date.formatted()) \(result.rules.type) - even game between \(pl1.name) (\(pl1.type)) and \(pl2.name) (\(pl2.type))")
    } else {
        let (winner, looser) = switch result.winner {
        case .player1: (pl1, pl2)
        case .player2: (pl2, pl1)
        default: throw PersistanceError.invalidResults
        }
        print("\(result.date.formatted()) \(result.rules.type) - \(winner.name) (\(winner.type)) won against \(looser.name) (\(looser.type))")
    }
}

func loadGameResults() async throws {
    if let results = try await Persistance.loadGameResults(withName: "savedGames.json", withFolderName: "connect4.games") {
        for result in results.sorted(by: { $0.date > $1.date } ) {
            try formatResult(result)
        }
    }
}

func gameConfigurationMenu() {
    //number of rows
    nbRows = readInt(withMessage: "Choose the number of rows:")
    //number of columns
    nbColumns = readInt(withMessage: "Choose the number of columns:")
    //number of pieces to align
    nbPiecesToAlign = readInt(withMessage: "Choose the number of pieces to align:")
    //rules
    repeat {
        rules = chooseRulesMenu()
    } while(rules == nil)
    
    //player1
    var player1: Player? = nil
    repeat {
        player1 = choosePlayerTypeAndName(.player1)
    } while(player1 == nil)
    players.append(player1!)
    
    //player2
    var player2: Player? = nil
    repeat {
        player2 = choosePlayerTypeAndName(.player2)
    } while(player2 == nil)
    players.append(player2!)
    
    game = try! Game(withRules: rules!, andPlayer1: players[0], andPlayer2: players[1])
}

func chooseRulesMenu() -> Rules? {
    var someRules: Rules?
    let rulesName = readChoice(withMessage: "Choose the rules to play with:", among: ["Connect4Rules", "TicTacToeRules", "PopOutRules"])
    switch rulesName {
    case "Connect4Rules":
        someRules = Connect4Rules(nbRows: nbRows, nbColumns: nbColumns, nbPiecesToAlign: nbPiecesToAlign)
    case "TicTacToeRules":
        someRules = TicTacToeRules(nbRows: nbRows, nbColumns: nbColumns, nbPiecesToAlign: nbPiecesToAlign)
    case "PopOutRules":
        someRules = PopOutRules(nbRows: nbRows, nbColumns: nbColumns, nbPiecesToAlign: nbPiecesToAlign)
    default:
        someRules = Connect4Rules(nbRows: nbRows, nbColumns: nbColumns, nbPiecesToAlign: nbPiecesToAlign)
    }
    return someRules
}

func choosePlayerTypeAndName(_ player: Owner) -> Player? {
    let playerType = readChoice(withMessage: "Choose the type of the player \(player):", among: ["Human", "Random", "Finnish Him", "Simple NegaMax"])
    switch playerType {
    case "Random":
        return RandomPlayer(withName: "Random", andId: player)
    case "Finnish Him":
        return FinnishHimPlayer(withName: "Finnish Him", andId: player)
    case "Simple NegaMax":
        return SimpleNegaMaxPlayer(withName: "SimpleNegaMax", andId: player)
    default:
        var playerName: String? = nil
        repeat {
            print("choose the player name:")
            playerName = readLine()
        } while(playerName == nil)
        return HumanPlayer(withName: playerName!, andId: player, andInputMethod: { readMove(from: $0)})
    }
}

@MainActor
func addListeners(_ game: Game) {
    game.addGameStartedListener {
        print($0)
        print("**************************************")
        print("     ==>> 🎉 GAME STARTS! 🎉 <<==     ")
        print("**************************************")
    }
    game.addPlayerNotifiedListener({ _, player in
        print("**************************************")
        print("Player \(player.id == .player1 ? "🔴 1" : "🟡 2") - \(player.name), it's your turn!")
        print("**************************************")
        Task {
            try! await Task.sleep(nanoseconds: 1000000)
        }
    })

    game.addMoveChosenCallbacksListener { _, move, player in
        print("**************************************")
        print("Player \(player.id == .player1 ? "🔴 1" : "🟡 2") - \(player.name), has chosen column: \(move.column+1)")
        print("**************************************")
    }

    game.addInvalidMoveCallbacksListener { _, move, player, result in
        if result {
           return
        }
        print("**************************************")
        print("⚠️⚠️⚠️⚠️ Invalid Move detected: \(move) by \(player.name) (\(player.id))")
        print("**************************************")
    }

    game.addBoardChangedListener {
        print($0)
    }

    game.addGameOverListener { board, result, _ in
        switch(result){
        case .notFinished:
            print("⏳ Game is not over yet!")
        case .winner(winner: let o, alignment: let r):
            print(board.asString(withHighlighting: r))
            print("**************************************")
            print("Game Over!!!")
            print("🥇🏆 and the winner is... \(o == .player1 ? "🔴" : "🟡") \(o)!")
        case .even:
            print("Game finished with no winner! Congratulations to both of you!")
        }
        print("**************************************")
    }
    
    game.addGameChangedListener { (game, result) in
        if game.players.contains(where: { $0.value is ReplayPlayer }) {
            sleep(1)
            return
        }
        _ = try await Persistance.saveGame(withName: "savedGame.co4", andGame: game, withFolderName: "connect4.games")
        
        if result != .notFinished {
            _ = try await Persistance.saveGameResult(withName: "savedGames.json", andGame: game, andResult: result, withFolderName: "connect4.games")
            
            if let player1 = game.players[.player1], let player2 = game.players[.player2] {
                let player1Type = "\(Mirror(reflecting: player1).subjectType)"
                let player2Type = "\(Mirror(reflecting: player2).subjectType)"
                let rulesType = "\(Mirror(reflecting: game.rules).subjectType)"
                let results = try await FaceToFace.getResults(in: "savedGames.json", withPlayer1Name: player1.name, andPlayer1Type: player1Type, andPlayer2Name: player2.name, andPlayer2Type: player2Type, for: rulesType, withNbRows: game.rules.nbRows, andNbColumns: game.rules.nbColumns, andNbPiecesToAlign: game.rules.nbPiecesToAlign, withFolder: "connect4.games")
                for r in results.sorted(by: { $0.date > $1.date } ) {
                    try formatResult(r)
                }
            }
        }
    }
}

try await startMenu()

if let game {
    addListeners(game)
    try await game.start()
}
