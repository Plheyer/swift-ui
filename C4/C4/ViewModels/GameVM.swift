import SwiftUI
import Connect4Core
import Connect4Persistance
import SpriteKit

public class GameVM : ObservableObject {
    @Published public var player1 : PlayerVM
    @Published public var player2 : PlayerVM
    @Published public var rules: any Rules
    @Published public var board: Board
    private var game: Game?
    @Published public var isOver: Bool = false
    
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
                self.game = game
            } catch {
                throw error
            }
        } else {
            throw GameErrors.InvalidPlayer
        }
        self.gameScene = GameScene(nbRows: rules.nbRows, nbColumns: rules.nbColumns, player1ImagePath: player1.model.imagePath, player2ImagePath: player2.model.imagePath, gameVM: self)
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
    
    private func moveChosen(board: Board, move: Move, player: Player) {
        print("move chosen: \(move.row) \(move.column)")
        if player.id == .player1 {
            gameScene?.playerNode1?.placeToken(row: move.row, col: move.column)
        } else if player.id == .player2 {
            gameScene?.playerNode2?.placeToken(row: move.row, col: move.column)
        }
    }
    
    private func invalidMove(board: Board, move: Move, player: Player, bool: Bool) {
        print("Invalid move")
    }
    
    private func gameOver(board: Board, result: Result, player: Player?) {
        self.isOver = true
        
        switch (result) {
        case .winner(winner: _, alignment: let alignment):
            if let firstX = alignment.first?.col, let firstY = alignment.first?.row, let firstPosition = self.gameScene?.boardNode.cellMatrix[firstX][firstY].position,
               let lastX = alignment.last?.col, let lastY = alignment.last?.row, let lastPosition = self.gameScene?.boardNode.cellMatrix[lastX][lastY].position
            {
                let origin = CGPoint(x: min(firstPosition.x, lastPosition.x),
                                         y: min(firstPosition.y, lastPosition.y))
                let size = CGSize(width: abs(firstPosition.x - lastPosition.x),
                                  height: abs(firstPosition.y - lastPosition.y))
                let rect = CGRect(origin: origin, size: size)
                let border = SKShapeNode(rect: rect)
                
                border.strokeColor = .red
                border.lineWidth = 3
                border.fillColor = .clear
                self.gameScene?.boardNode.addChild(border)
            }
        default:
            break
        }
    }
}
