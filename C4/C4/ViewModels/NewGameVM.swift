import SwiftUI
import Connect4Core
import Connect4Persistance
import Connect4Rules

@MainActor
public class NewGameVM : ObservableObject {
    @Published public var player1 : PlayerVM
    @Published public var player2 : PlayerVM
    @Published public var rulesName: String
    @Published public var nbRows: Int
    @Published public var nbColumns: Int
    @Published public var nbTokensToAlign: Int
    @Published public var gameVM: GameVM
    @Published public var isAR: Bool = false
    // Timer mode
    @Published public var isLimitedTime = false

    // User input
    @Published public var minutesString = ""
    @Published public var secondsString = ""
    
    public init(with player1: PlayerVM, andWith player2: PlayerVM, rulesName: String, nbRows: Int, nbColumns: Int, nbTokensToAlign: Int) {
        self.player1 = player1
        self.player2 = player2
        self.rulesName = rulesName
        self.nbRows = nbRows
        self.nbColumns = nbColumns
        self.nbTokensToAlign = nbTokensToAlign
        self.gameVM = try! GameVM(with: player1, andWith: player2, rules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, board: Board(withNbRows: 6, andNbColumns: 7)!, isAR: false, timerVM: TimerVM(time: 0, gameVM: nil)) // Default game
    }
    
    // Returns if it succeed or not
    public func createGame() -> Bool {
        let board = Board(withNbRows: self.nbRows, andNbColumns: self.nbColumns)
        let rules: Rules? = switch self.rulesName {
            case "\(Connect4Rules.self)":
                Connect4Rules(nbRows: self.nbRows, nbColumns: self.nbColumns, nbPiecesToAlign: self.nbTokensToAlign)
            case "\(TicTacToeRules.self)":
                TicTacToeRules(nbRows: self.nbRows, nbColumns: self.nbColumns, nbPiecesToAlign: self.nbTokensToAlign)
            case "\(PopOutRules.self)":
                PopOutRules(nbRows: self.nbRows, nbColumns: self.nbColumns, nbPiecesToAlign: self.nbTokensToAlign)
            default: nil
        }
        if let board, let rules {
            let time: Int
            if self.isLimitedTime {
                let inputMinutes = Int(self.minutesString) ?? 0
                let inputSeconds = Int(self.secondsString) ?? 0
                time = inputMinutes * 60 + inputSeconds
            } else {
                time = 0
            }
            let game = try? GameVM(with: player1, andWith: player2, rules: rules, board: board, isAR: isAR, timerVM: TimerVM(time: time, gameVM: self.gameVM))
            if let game {
                self.gameVM = game
                return true
            }
        }
        return false
    }
}
