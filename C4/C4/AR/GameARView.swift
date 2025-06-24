import SwiftUI
import ARKit
import RealityKit
import Connect4Core

public class GameARView: ARView {
    public var gameVM: GameVM?
    var nbRows : Int
    var nbColumns : Int
    private var board: Entity?
    private var game: Entity?
    private var player1Token: ModelEntity?
    private var player2Token: ModelEntity?
    var cellMatrix: [[Entity?]] = []
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

        createBoard()
    }
    
    @discardableResult
    func loadObject(named name: String, in anchor: Entity, at position: SIMD3<Float> = SIMD3(0.0, 0.0, 0.0), scale: SIMD3<Float> = SIMD3(1, 1, 1), gestures: Bool = false, entityName: String = "") -> ModelEntity? {
        let entity = try? Entity.loadModel(named: name)
        if let entity {
            entity.scale = scale
            entity.position = position
            anchor.addChild(entity)
        }
        if gestures, let entity {
            entity.generateCollisionShapes(recursive: true)
            entity.name = entityName
            self.installGestures([.all], for: entity as Entity & HasCollision).forEach { gestureRecognizer in
                gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
            }
        }
        return entity
    }
    
    func createBoard() {
        let matRed = SimpleMaterial(color: .red, isMetallic: true)
        let matYellow = SimpleMaterial(color: .yellow, isMetallic: true)
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.005, 0.005)))
        // fast debug
        // let anchor = AnchorEntity(world: .zero)
        scene.addAnchor(anchor)
        let board = Entity()
        for row in (0..<self.nbRows) {
            cellMatrix.append([])
            for col in (0..<self.nbColumns) {
                cellMatrix[row].append(loadObject(named: "Cell", in: board, at: SIMD3(0, Float(row)*2, Float(col)*2)))
            }
        }
        loadObject(named: "LeftFoot", in: board)
        loadObject(named: "RightFoot", in: board, at: SIMD3(0.0, 0.0, Float(nbColumns * 2 - 2)))
        
        self.player1Token = loadObject(named: "Token", in: board, at: SIMD3(-1, 0, Float(nbColumns * 2 - 3)), gestures: true, entityName: "red")
        self.player1Token?.apply(material: matRed)
        self.player2Token = loadObject(named: "Token", in: board, at: SIMD3(-1, 0, 1), gestures: true, entityName: "yellow")
        self.player2Token?.apply(material: matYellow)
        self.player2Token?.removeFromParent()
        
        self.board = board
        anchor.addChild(board)
        anchor.transform.rotation = simd_quatf(angle: GLKMathDegreesToRadians(90), axis: SIMD3(0, 1, 0))
        anchor.scale = SIMD3(0.02, 0.02, 0.02)
    }
    
    public func placeToken(row: Int, col: Int, owner: Owner) {
        DispatchQueue.main.async {
            if owner == .player1, let redToken = try? Entity.loadModel(named: "Token") {
                redToken.model?.materials.removeAll()
                redToken.model?.materials.append(SimpleMaterial(color: .red, isMetallic: true))
                redToken.generateCollisionShapes(recursive: true)
                redToken.name = "red"
                
                // Parallel threads, here it's the main one but callbacks are on others
                guard self.gameVM?.isOver == false else { return }
                self.cellMatrix[row][col]?.addChild(redToken)
                
                if let player2Token = self.player2Token {
                    self.board?.addChild(player2Token)
                }
                self.player1Token?.removeFromParent()
            } else if let yellowToken = try? Entity.loadModel(named: "Token") {
                yellowToken.model?.materials.removeAll()
                yellowToken.model?.materials.append(SimpleMaterial(color: .yellow, isMetallic: true))
                yellowToken.generateCollisionShapes(recursive: true)
                yellowToken.name = "yellow"
                
                guard self.gameVM?.isOver == false else { return }
                self.cellMatrix[row][col]?.addChild(yellowToken)
                
                if let player1Token = self.player1Token {
                    self.board?.addChild(player1Token)
                }
                self.player2Token?.removeFromParent()
                
            }
        }
    }
    
    public func win(alignment: [Cell]) {
        DispatchQueue.main.async {
            self.player1Token?.removeFromParent()
            self.player2Token?.removeFromParent()
            for cell in alignment {
                if let token = self.cellMatrix[cell.row][cell.col]?.children.first as? ModelEntity {
                    token.model?.materials.removeAll()
                    token.model?.materials.append(SimpleMaterial(color: .green, isMetallic: true))
                }
            }
        }
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
                let row = Int(round(position.y / 2))
                let col = Int(round(position.z / 2))
                let owner: Owner = entity.name == "red" ? .player1 : .player2
                entity.move(to: initialTransform, relativeTo: entity.parent, duration: 1)
                
                Task {
                    if row >= 0, row < self.nbRows, col >= 0, col < self.nbColumns {
                        await gameVM?.playMove(move: Move(of: owner, toRow: row, toColumn: col))
                    }
                }
            default:
                break
            }
    }
}
