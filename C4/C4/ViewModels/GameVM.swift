import SwiftUI
import Connect4Core
import Connect4Persistance

public class GameVM : ObservableObject {
    @Published public var player1 : PlayerVM
    @Published public var player2 : PlayerVM
    @Published public var rules: any Rules
    @Published public var board: Board
    private var game: Game?
    
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
                self.game = try Game(withBoard: self.board, withRules: self.rules, andPlayer1: p1, andPlayer2: p2)
            } catch {
                throw error
            }
        } else {
            throw GameErrors.InvalidPlayer
        }
        self.gameScene = GameScene(nbRows: rules.nbRows, nbColumns: rules.nbColumns, player1ImagePath: player1.model.imagePath, player2ImagePath: player2.model.imagePath, gameVM: self)
    }
}
