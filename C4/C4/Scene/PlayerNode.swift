import Foundation
import SpriteKit

public class PlayerNode : SKNode {
    let width: CGFloat
    let height: CGFloat
    let color: UIColor
    var token: SKShapeNode
    
    let droppedAction: (CGPoint, UIColor) -> ()
    
    var ghost : PlayerNode?
    
    public init(width: CGFloat, height: CGFloat, color: UIColor, droppedAction: @escaping (CGPoint, UIColor) -> ()) {
        self.width = width
        self.height = height
        self.color = color
        token = SKShapeNode(ellipseIn: CGRect(x: 0, y: 0, width: width, height: height))
        token.fillColor = color
        self.droppedAction = droppedAction
        super.init()
        self.addChild(token)
    }
    
    override public var isUserInteractionEnabled: Bool {
        get { true }
        set { }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dragged = PlayerNode(width: width, height: height, color: color, droppedAction: droppedAction)
        ghost = dragged
        self.parent?.parent?.addChild(dragged)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if let ghost, let parent = self.parent {
            let touchPoint = touch.location(in: parent)
            ghost.position = CGPoint(x: touchPoint.x - width / 2, y: touchPoint.y - height / 2)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let dropped = ghost else { return }
        dropped.removeFromParent()
        ghost = nil
        if let parent = self.parent, let gameScene = parent.parent as? GameScene {
            let sceneWidth: CGFloat = CGFloat((gameScene.boardNode?.nbColumns ?? 0) * 100)
            let sceneHeight: CGFloat = CGFloat((gameScene.boardNode?.nbRows ?? 0) * 100)
            
            let correctedPosition = CGPoint(x: dropped.position.x + width / 2 + sceneWidth / 2, y: dropped.position.y + height / 2 + 75 + sceneHeight / 2) // This +75 is to have the correct x,y for the board, and thus excluding the playerNode part
            droppedAction(correctedPosition, self.color)
        }
    }
}
