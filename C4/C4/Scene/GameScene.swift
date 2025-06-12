import Foundation
import SpriteKit

public class GameScene : SKScene {
    var boardNode : BoardNode?
    var player1ImagePath: String = ""
    var player2ImagePath: String = ""
    
    // TODO: Possess a GameVM
    
    override public init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    convenience init(nbRows: Int, nbColumns: Int, player1ImagePath: String, player2ImagePath: String) {
        self.init(size: CGSize(width: nbColumns * 100, height: nbRows * 100 + 150))
        self.player1ImagePath = player1ImagePath
        self.player2ImagePath = player2ImagePath
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
        let p1 = PlayerNode(width: 80, height: 80, imagePath: self.player1ImagePath, droppedAction: droppedAction)
        toolbarNode.addChild(p1)
        p1.position.x = -self.size.width/3
        p1.position.y = self.size.height/2 - 115
        let p2 = PlayerNode(width: 80, height: 80, imagePath: self.player2ImagePath, droppedAction: droppedAction)
        toolbarNode.addChild(p2)
        p2.position.x = self.size.width/3 - 80
        p2.position.y = self.size.height/2 - 115
    }
    
    func droppedAction(position : CGPoint, imagePath: String?, cropNode: SKCropNode?) {
        boardNode?.placeToken(in: position, imagePath: imagePath, cropNode: cropNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
