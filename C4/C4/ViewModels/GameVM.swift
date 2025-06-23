import SwiftUI
import Connect4Core
import Connect4Persistance
import SpriteKit

@MainActor
public class GameVM : ObservableObject {
    public var player1 : PlayerVM
    public var player2 : PlayerVM
    public var rules: any Rules
    public var board: Board
    private var game: Game?
    public var isOver: Bool = false
    @MainActor @Published public var isPlayer1Turn: Bool = true
    @MainActor @Published public var isPlayer2Turn: Bool = false
    
    // Possess a GameScene. When init, will also create the game scene at the same time to create the GameScene as a member of GameVM, and also provide the reference (because a class is a reference type) of the GameVM (itself) when init the GameScene. This will allow them to communicate easily.
    // Example: GameVM receives a callback from Game, it must update the GameScene, it must communicate with the GameScene, and have it.
    // Moreover, when the user do the drag and drop, the view updates the game scene, which will send the position chosen by the user to place the token in. So the GameScene must be able to communicate with the GameVM, and thus have a reference to it.
    @Published public var gameScene: GameScene?
    
    
    public init(with player1: PlayerVM, andWith player2: PlayerVM, rules: Rules, board: Board) throws {
        self.player1 = player1
        self.player2 = player2
        
        self.rules = rules
        self.board = board
        if let p1 = player1.original.toC4Model, let p2 = player2.original.toC4Model {
            do {
                let game = try Game(withBoard: self.board, withRules: self.rules, andPlayer1: p1, andPlayer2: p2)
                game.addGameOverListener(gameOver)
                game.addMoveChosenCallbacksListener(moveChosen)
                game.addInvalidMoveCallbacksListener(invalidMove)
                game.addBoardChangedListener(boardChanged)
                game.addPlayerNotifiedListener({ _, player in
                    if player.type != "Human" {
                        sleep(1)
                    }
                })
                game.addGameChangedListener(gameChanged)

                self.game = game
            } catch {
                throw error
            }
        } else {
            throw GameErrors.InvalidPlayer
        }
        self.gameScene = GameScene(nbRows: rules.nbRows, nbColumns: rules.nbColumns, player1ImagePath: player1.model.imagePath, player2ImagePath: player2.model.imagePath, gameVM: self)
        gameScene?.playerNode1?.isHidden = false
        gameScene?.playerNode2?.isHidden = true
    }
    
    public func startGame() async {
        do {
            if let game = self.game {
                try await game.start()
            } else {
                print("Erreur, la partie est nulle.")
            }
        } catch {
            print("Erreur lors du lancement de la partie")
        }
    }
    
    public func playMove(move: Move) async {
        try? await game?.onPlayed(move: move)
    }
    
    private func boardChanged(board: Board, cell: Cell?) {
        let player = cell?.piece?.owner
        if let player, let cell {
            print("Board changed \(cell.row) \(cell.col)")
            if player == .player1 {
                gameScene?.playerNode1?.placeToken(row: cell.row, col: cell.col)
                gameScene?.playerNode1?.isHidden = true
                gameScene?.playerNode2?.isHidden = false
                isPlayer1Turn = false
                isPlayer2Turn = true
            } else if player == .player2 {
                gameScene?.playerNode2?.placeToken(row: cell.row, col: cell.col)
                gameScene?.playerNode1?.isHidden = false
                gameScene?.playerNode2?.isHidden = true
                isPlayer1Turn = true
                isPlayer2Turn = false
            }
        }
    }
    
    private func moveChosen(board: Board, move: Move, player: Player) {
        print("\nMove chosen: \(move.row) \(move.column)")
    }
    
    private func invalidMove(board: Board, move: Move, player: Player, bool: Bool) {
        if bool {
            return
        }
        print("Invalid move")
    }
    
    private func gameOver(board: Board, result: Result, player: Player?) {
        print("Game over.")
        self.isOver = true
        
        switch (result) {
        case .winner(winner: _, alignment: let alignment):
            let alignmentSorted = alignment.sorted { ($0.row, $0.col) < ($1.row, $1.col) }
            if let firstY = alignmentSorted.first?.col, let firstX = alignmentSorted.first?.row, let firstToken = self.gameScene?.boardNode.cellMatrix[firstX][firstY],
               let lastY = alignmentSorted.last?.col, let lastX = alignmentSorted.last?.row, let lastToken = self.gameScene?.boardNode.cellMatrix[lastX][lastY], let boardNode = self.gameScene?.boardNode
            {
                let firstPosition = firstToken.position
                let lastPosition = lastToken.position
                
                // This offset handles the decreasing diagonal win
                let offsetX: CGFloat
                if firstPosition.x > lastPosition.x, firstPosition.y < lastPosition.y {
                    offsetX = firstToken.width
                } else {
                    offsetX = (0 - firstToken.width)
                }
                
                let origin = CGPoint(x: min(firstPosition.x, lastPosition.x),
                                         y: min(firstPosition.y, lastPosition.y))
                let size = CGSize(width: abs(firstPosition.x - lastPosition.x + offsetX),
                                  height: abs(firstPosition.y - lastPosition.y - firstToken.height))
                let rect = CGRect(origin: origin, size: size)
                let border = SKShapeNode(rect: rect)
            
                border.strokeColor = .red
                border.lineWidth = 6
                border.fillColor = .clear
                boardNode.addChild(border)
                
                let winner = SKLabelNode()
                winner.text = "\(player?.name ?? "Unknown player") Win!"
                winner.fontSize = 60
                winner.fontName = "\(winner.fontName ?? "Arial")-Bold"
                winner.fontColor = SKColor.green
                winner.position = CGPoint(x: boardNode.width / 2, y: boardNode.height / 2)
                
                boardNode.addChild(winner)
                gameScene?.playerNode1?.isHidden = true
                gameScene?.playerNode2?.isHidden = true
                isPlayer1Turn = false
                isPlayer2Turn = false
            }
        default:
            break
        }
    }
    
    private func gameChanged(game: Game, result: Result) throws {
        Task {
            _ = try await Persistance.saveGame(withName: "savedGame.co4", andGame: game, withFolderName: "connect4.games")
            
            if result != .notFinished {
                _ = try await Persistance.saveGameResult(withName: "GameResults.co4", andGame: game, andResult: result)
                if let player1 = game.players[.player1], let player2 = game.players[.player2] {
                    let player1Type = "\(player1.type)"
                    let player2Type = "\(player2.type)"
                    let rulesType = "\(game.rules.name)"
                    let results = try await Connect4Persistance.FaceToFace.getResults(in: "GameResults.co4", withPlayer1Name: player1.name, andPlayer1Type: player1Type, andPlayer2Name: player2.name, andPlayer2Type: player2Type, for: rulesType, withNbRows: game.rules.nbRows, andNbColumns: game.rules.nbColumns, andNbPiecesToAlign: game.rules.nbPiecesToAlign)
                    for r in results.sorted(by: { $0.date > $1.date } ) {
                        try formatResult(r)
                    }
                }
            }
        }
    }
    
    private func formatResult(_ result: GameResult) throws {
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

}
