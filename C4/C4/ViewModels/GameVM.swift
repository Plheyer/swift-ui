import SwiftUI
import Connect4Core
import Connect4Persistance

public class GameVM : ObservableObject {
    @Published public var player1 : PlayerVM
    @Published public var player2 : PlayerVM
    @Published public var rules: any Rules
    @Published public var board: Board
    
    // TODO: Possess a GameScene. When init, will also create the game scene at the same time to create the GameScene as a member of GameVM, and also provide the reference (because a class is a reference type) of the GameVM (itself) when init the GameScene. This will allow them to communicate easily.
    // Example: GameVM receives a callback from Game, it must update the GameScene, it must communicate with the GameScene, and have it.
    // Moreover, when the user do the drag and drop, the view updates the game scene, which will send the position chosen by the user to place the token in. So the GameScene must be able to communicate with the GameVM, and thus have a reference to it.
    
    public init(with player1: PlayerVM, andWith player2: PlayerVM, rules: Rules, board: Board) {
        self.player1 = player1
        self.player2 = player2
        self.rules = rules
        self.board = board
    }
}
