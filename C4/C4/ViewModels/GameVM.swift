import SwiftUI
import Connect4Core
import Connect4Persistance

public class GameVM : ObservableObject {
    @Published public var board : Board
    @Published public var rules: RuleVM
    @Published public var players: [Connect4Core.Owner : PlayerVM]
    @Published var isEditing: Bool = false // For the modal view
    
    public init(with player1: PlayerVM, andWith player2: PlayerVM, board: Board) {
        self.board = board
        self.rules = RuleVM(nbRows: 6, nbColumns: 7, tokensToAlign: 4, type: "\(Connect4Rules.self)") // Default rules
        self.players = [.player1:player1, .player2:player2]
    }
    
    public func onEditing() {
        self.isEditing = true
    }
    
    public func onEdited(isCancelled: Bool = true) async -> Bool {
        self.isEditing = false
        if !isCancelled {
            if let rules = self.rules.model, players.count == 2, let player1 = players.values.first?.model, let player2 = players.values.dropFirst().first?.model {
                do {
                    let game = try? Game(withBoard: board, withRules: rules, andPlayer1: player1, andPlayer2: player2)
                    if let game {
                        return try await Persistance.saveGame(withName: "Games", andGame: game)
                    }
                    return false
                } catch {
                    print(error.localizedDescription)
                    return false
                }
            }
        }
        return false
    }
}
