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
    var cellMatrix: [[CellNode]] = []
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
        cellMatrix = []
        let w = (self.width - padding) / CGFloat(self.nbColumns)
        let h = (self.height - padding) / CGFloat(self.nbRows)
        for r in 0 ..< nbRows {
            cellMatrix.append([])
            for c in 0..<nbColumns {
                let x = CGFloat(c) * w
                let y = CGFloat(r) * h
                let node = CellNode(width: w - spacing, height: h - spacing)
                node.position = CGPoint(x: x + (spacing + padding) / 2, y: y + (spacing + padding) / 2)
                cellsNode.addChild(node)
                cellMatrix[r].append(node)
            }
        }
        self.addChild(cellsNode)
    }
}
