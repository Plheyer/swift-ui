import Foundation
import SpriteKit

public class CellNode : SKNode {
    let width: CGFloat
    let height: CGFloat
    let shapeNode: SKShapeNode
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        shapeNode = SKShapeNode(ellipseIn: CGRect(x: 0, y: 0, width: width, height: height))
        super.init()
        shapeNode.fillColor = .gray
        self.addChild(shapeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeColor(color: UIColor) {
        shapeNode.fillColor = color
    }
}
