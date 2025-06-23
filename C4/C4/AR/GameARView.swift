import SwiftUI
import ARKit
import RealityKit

class GameARView: ARView {
    var nbRows : Int
    var nbColumns : Int
    required init(frame frameRect: CGRect) {
        self.nbRows = 6
        self.nbColumns = 7
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        self.nbRows = 6
        self.nbColumns = 7
        fatalError("init(coder:) not implemented")
    }

    convenience init(nbRows: Int, nbColumns: Int) {
        self.init(frame: UIScreen.main.bounds)
        self.nbRows = nbRows
        self.nbColumns = nbColumns
        addBoardToAPlane()
    }
    
    func addBoardToAPlane() {
        let game = Entity()
        let board = Entity()
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        scene.addAnchor(anchor)
        let cell = try? Entity.load(named: "Cell")
        if let cell {
            for x in 0 ..< nbColumns {
                for y in 0 ..< nbRows {
                    let cellCopy = cell.clone(recursive: true)
                    cellCopy.position = SIMD3<Float>(
                        Float(x),
                        0,
                        Float(y)
                    )
                    if y == 0, x == 1 {
                        // Add left foot
                        let leftFoot = try? Entity.load(named: "LeftFoot")
                        if let leftFoot {
                            cellCopy.addChild(leftFoot)
                        }
                    }
                    if y == 0, x == nbRows - 1 {
                        // Add right foot
                        let rightFoot = try? Entity.load(named: "RightFoot")
                        if let rightFoot {
                            cellCopy.addChild(rightFoot)
                        }
                    }
                    board.addChild(cellCopy)
                }
            }
            game.addChild(board)
        }
        if let redToken = try? Entity.loadModel(named: "Token") {
            redToken.model?.materials.append(SimpleMaterial(color: .red, isMetallic: true))
            redToken.generateCollisionShapes(recursive: true)
            self.installGestures([.all], for: redToken as Entity & HasCollision).forEach { gestureRecognizer in
                gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
            }
            game.addChild(redToken)
        }
        if let yellowToken = try? Entity.loadModel(named: "Token") {
            yellowToken.generateCollisionShapes(recursive: true)
            self.installGestures([.all], for: yellowToken as Entity & HasCollision)
            game.addChild(yellowToken)
        }
    }
    
    var initialTransform: Transform = Transform()
    @objc private func handleGesture(_ recognizer: UIGestureRecognizer) {
        guard let translationGesture = recognizer as? EntityTranslationGestureRecognizer, let entity = translationGesture.entity else { return }
                
                switch translationGesture.state {
                case .began:
                    self.initialTransform = entity.transform
                case .ended:
                    entity.move(to: initialTransform, relativeTo: entity.parent, duration: 1)
                default:
                    break
                }
    }
}
