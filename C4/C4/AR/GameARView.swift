import SwiftUI
import ARKit
import RealityKit
import Connect4Core

class GameARView: ARView {
    public var gameVM: GameVM?
    var nbRows : Int
    var nbColumns : Int
    private var board: Entity?
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

    convenience init(nbRows: Int, nbColumns: Int, gameVM: GameVM) {
        self.init(frame: UIScreen.main.bounds)
        self.nbRows = nbRows
        self.nbColumns = nbColumns
        self.gameVM = gameVM
        addBoardToAPlane()
    }
    
    func addBoardToAPlane() {
        let game = Entity()
        let board = Entity()
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.1, 0.1)))
        scene.addAnchor(anchor)
        let cell = try? Entity.load(named: "Cell")
        if let cell {
            for x in 0 ..< nbColumns {
                for y in 0 ..< nbRows {
                    let cellCopy = cell.clone(recursive: true)
                    cellCopy.position = SIMD3<Float>(
                        0,
                        Float(y*2),
                        Float(x*2)
                    )
                    if y == 0, x == 1 {
                        // Add left foot
                        let leftFoot = try? Entity.load(named: "LeftFoot")
                        if let leftFoot {
                            cellCopy.addChild(leftFoot)
                            leftFoot.position = SIMD3<Float>(leftFoot.position.x, leftFoot.position.y, leftFoot.position.z)
                            leftFoot.orientation = simd_quatf(angle: 0.3, axis: .init(1, 0, 0))
                        }
                    }
                    if y == 0, x == nbRows - 1 {
                        // Add right foot
                        let rightFoot = try? Entity.load(named: "RightFoot")
                        if let rightFoot {
                            cellCopy.addChild(rightFoot)
                            rightFoot.position = SIMD3<Float>(rightFoot.position.x, rightFoot.position.y, rightFoot.position.z)
                            rightFoot.orientation = simd_quatf(angle: 0.3, axis: .init(1, 0, 0))
                        }
                    }
                    board.addChild(cellCopy)
                }
            }
            game.addChild(board)
        }
        if let redToken = try? Entity.loadModel(named: "Token") {
            redToken.model?.materials.removeAll()
            redToken.model?.materials.append(SimpleMaterial(color: .red, isMetallic: true))
            redToken.generateCollisionShapes(recursive: true)
            redToken.name = "red"
            game.addChild(redToken)
            self.installGestures([.all], for: redToken as Entity & HasCollision).forEach { gestureRecognizer in
                gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
            }
            redToken.position = SIMD3(-1, 1, -1)
        }
        if let yellowToken = try? Entity.loadModel(named: "Token") {
            yellowToken.generateCollisionShapes(recursive: true)
            yellowToken.name = "yellow"
            game.addChild(yellowToken)
            self.installGestures([.all], for: yellowToken as Entity & HasCollision).forEach { gestureRecognizer in
                gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
            }
            yellowToken.position = SIMD3(1, 1, -1)
        }
        game.scale = SIMD3(0.1, 0.1, 0.1)
        self.board = board
        anchor.addChild(game)
    }
    
    var initialTransform: Transform = Transform()
    @objc private func handleGesture(_ recognizer: UIGestureRecognizer) {
        guard let translationGesture = recognizer as? EntityTranslationGestureRecognizer, let entity = translationGesture.entity else { return }
            switch translationGesture.state {
            case .began:
                self.initialTransform = entity.transform
            case .ended:
                let position = entity.position(relativeTo: board)
                // X = behind and ahead
                // Y = "height"
                // Z = "width"
                let row = Int(floor(position.y / 2))
                let col = Int(floor(position.z / 2))
                let owner: Owner = entity.name == "red" ? .player1 : .player2
                entity.move(to: initialTransform, relativeTo: entity.parent, duration: 1)
                
                print(row, col, owner)
                Task {
                    await gameVM?.playMove(move: Move(of: owner, toRow: row, toColumn: col))
                }
            default:
                break
            }
    }
}
