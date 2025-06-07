import Foundation
import SpriteKit

public class BoardNode : SKNode {
    let width: CGFloat
    let height: CGFloat
    let nbRows: Int
    let nbColumns: Int
    let cellsNode = SKNode()
    let padding: CGFloat = 30.0
    let spacing: CGFloat = 16.0
    public init(width: CGFloat, height: CGFloat, nbRows: Int, nbColumns: Int) {
        self.width = width
        self.height = height
        self.nbRows = nbRows
        self.nbColumns = nbColumns
        super.init()
        let rect = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height))
        rect.fillColor = .blue
        self.addChild(rect)
        self.initCells()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCells() {
        let w = (self.width - padding) / CGFloat(self.nbColumns)
        let h = (self.height - padding) / CGFloat(self.nbRows)
        for r in 0 ..< nbRows {
            for c in 0..<nbColumns {
                let x = CGFloat(c) * w
                let y = CGFloat(r) * h
                let node = CellNode(width: w - spacing, height: h - spacing)
                node.position = CGPoint(x: x + (spacing + padding) / 2, y: y + (spacing + padding) / 2)
                cellsNode.addChild(node)
            }
        }
        self.addChild(cellsNode)
    }
    
    // Can take an imagePath (not recommended, takes lot's of time to load) or a cropNode (at least 1 of both)
    func placeToken(in location: CGPoint, imagePath: String?, cropNode: SKCropNode?) {
        let xIndex = ceil(location.x/100) - 1
        let yIndex = ceil(location.y/100) - 1
        let node = cellsNode.children.first { ceil(($0.position.x - (spacing + padding) / 2) / 100) == xIndex && ceil(($0.position.y - (spacing + padding) / 2) / 100) == yIndex  }
        if let node, node is CellNode {
            let cellNode = node as? CellNode
            if let cropNode {
                cellNode?.cropNode = cropNode
            } else if let imagePath {
                cellNode?.imagePath = imagePath
            } else {
                
            }
        }
    }
}
