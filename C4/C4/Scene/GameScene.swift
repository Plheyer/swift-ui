import Foundation
import SpriteKit

public class GameScene : SKScene {
    var boardNode : BoardNode
    var player1ImagePath: String = ""
    var player2ImagePath: String = ""
    var playerNode1: PlayerNode?
    var playerNode2: PlayerNode?
    var gameVM: GameVM?
    
    override public init(size: CGSize) {
        boardNode = BoardNode(width: size.width, height: size.height - 150, nbRows: 6, nbColumns: 7) // Default
        super.init(size: size)
        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    convenience init(nbRows: Int, nbColumns: Int, player1ImagePath: String, player2ImagePath: String, gameVM: GameVM? = nil) {
        self.init(size: CGSize(width: nbColumns * 100, height: nbRows * 100 + 150))
        self.player1ImagePath = player1ImagePath
        self.player2ImagePath = player2ImagePath
        self.gameVM = gameVM
        initBoard(nbRows: nbRows, nbColumns: nbColumns)
        initTopbar()
        self.backgroundColor = .clear
    }
    
    func initBoard(nbRows: Int, nbColumns: Int) {
        let boardNode = BoardNode(width: size.width, height: size.height - 150, nbRows: nbRows, nbColumns: nbColumns)
        self.boardNode = boardNode
        self.addChild(boardNode)
        boardNode.position.x = -boardNode.width / 2
        boardNode.position.y = -boardNode.height / 2 - 75
    }
    
    func initTopbar() {
        let toolbarNode = SKNode()
        self.addChild(toolbarNode)
        let p1 = PlayerNode(width: 80, height: 80, imagePath: self.player1ImagePath, owner: .player1)
        playerNode1 = p1
        toolbarNode.addChild(p1)
        p1.position.x = -self.size.width/3
        p1.position.y = self.size.height/2 - 115
        let p2 = PlayerNode(width: 80, height: 80, imagePath: self.player2ImagePath, owner: .player2)
        playerNode2 = p2
        toolbarNode.addChild(p2)
        p2.position.x = self.size.width/3 - 80
        p2.position.y = self.size.height/2 - 115
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
