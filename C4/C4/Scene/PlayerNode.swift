import Foundation
import SpriteKit
import Connect4Core

public class PlayerNode : SKNode {
    let width: CGFloat
    let height: CGFloat
    let imagePath : String
    let owner: Owner
    var crop : SKCropNode?
    
    var ghost : PlayerNode?
    
    public init(width: CGFloat, height: CGFloat, imagePath: String, owner: Owner) {
        self.width = width
        self.height = height
        self.imagePath = imagePath
        self.owner = owner
        super.init()
        
        let sprite : SKSpriteNode
        if let image = UIImage(contentsOfFile: imagePath) {
            // max is 8192 but it would make the app lag so I divided by 100
            // let resizedImage = ImageHelper.resizeImage(image: image, targetSize: 82) ?? image // Having a bug/crash when there's not this call because the image is too big for the Texture
            let texture = SKTexture(image: image)
            
            sprite = SKSpriteNode(texture: texture)
        } else {
            sprite = SKSpriteNode(imageNamed: "DefaultPlayerImage")
        }
        
        sprite.size.width = width
        sprite.size.height = height
        sprite.position.x = width / 2
        sprite.position.y = height / 2
        
        let crop = SKCropNode()
        let mask = SKShapeNode(ellipseIn: CGRect(x: 0, y: 0, width: width, height: height))
        mask.fillColor = .white
        crop.maskNode = mask
        crop.addChild(sprite)
        self.crop = crop
        self.addChild(crop)
    }
    
    public init(width: CGFloat, height: CGFloat, crop: SKCropNode?, owner: Owner) {
        self.width = width
        self.height = height
        self.crop = crop
        self.owner = owner
        self.imagePath = "" // Useless
        super.init()
        
        if let crop = crop {
            self.addChild(crop)
        } else {
            let sprite = SKSpriteNode(imageNamed: "DefaultPlayerImage")
            sprite.size.width = width
            sprite.size.height = height
            sprite.position.x = width / 2
            sprite.position.y = height / 2
            
            let crop = SKCropNode()
            let mask = SKShapeNode(ellipseIn: CGRect(x: 0, y: 0, width: width, height: height))
            mask.fillColor = .white
            crop.maskNode = mask
            crop.addChild(sprite)
            self.crop = crop
            self.addChild(crop)
        }
    }
    
    override public var isUserInteractionEnabled: Bool {
        get { true }
        set { }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let gameScene = self.parent?.parent as? GameScene else { return }
        guard let touch = touches.first else { return }
        guard gameScene.gameVM?.isOver == false else { return }
        
        let touchPosition = touch.location(in: gameScene)
        let dragged: PlayerNode
        if let nodeCopy = crop?.copy(), let cropCopy = nodeCopy as? SKCropNode {
            dragged = PlayerNode(width: width, height: height, crop: cropCopy, owner: owner) // More opti, but can fail
        } else {
            dragged = PlayerNode(width: width, height: height, imagePath: imagePath, owner: owner)
        }
        dragged.position = CGPoint(x: touchPosition.x - self.width / 2, y: touchPosition.y - self.height / 2)
        ghost = dragged
        gameScene.addChild(dragged)
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
        guard let gameScene = self.parent?.parent as? GameScene else { return }
        guard let touch = touches.first else { return }
        
        let boardNode = gameScene.boardNode
        let (row, col) = getCellCoordinates(from: touch, in: boardNode)
        if row >= 0, row < boardNode.nbRows, col >= 0, col < boardNode.nbColumns {
            if let gameVM = gameScene.gameVM {
                let move = Move(of: owner, toRow: row, toColumn: col)
                Task {
                    await gameVM.playMove(move: move)
                }
                let moveAction = SKAction.move(to: self.position, duration: 0.2)
                dropped.run(moveAction) {
                    dropped.removeFromParent()
                }
            } else {
                dropped.removeFromParent()
            }
        } else {
            dropped.removeFromParent()
        }
        ghost = nil
    }
    
    public func placeToken(row: Int, col: Int) {
        guard let gameScene = self.parent?.parent as? GameScene else { return }
        
        let dragged: PlayerNode
        if let nodeCopy = crop?.copy(), let cropCopy = nodeCopy as? SKCropNode {
            dragged = PlayerNode(width: width, height: height, crop: cropCopy, owner: owner) // More opti, but can fail
        } else {
            dragged = PlayerNode(width: width, height: height, imagePath: imagePath, owner: owner)
        }
        dragged.position = CGPoint(x: self.position.x, y: self.position.y)
        gameScene.addChild(dragged)
        
        let cell = gameScene.boardNode.cellMatrix[row][col]
        guard let convertedPosition = self.parent?.parent?.convert(cell.position, from: gameScene.boardNode) else { return }
        let moveActionX = SKAction.move(to: CGPoint(x: convertedPosition.x, y: self.position.y), duration: 0.2)
        if gameScene.gameVM?.rules.shortName == "Classic" {
            dragged.run(moveActionX) {
                let moveActionY = SKAction.move(to: CGPoint(x: convertedPosition.x, y: convertedPosition.y), duration: 0.4)
                
                dragged.run(moveActionY) {
                    if let crop = self.crop, let copy = NodeHelper.deepCopyCropNode(crop) {
                        cell.cropNode = copy
                    } else {
                        cell.imagePath = self.imagePath
                    }
                    dragged.removeFromParent()
                }
            }
        } else if gameScene.gameVM?.rules.shortName == "PopOut" {
            if row == gameScene.boardNode.nbRows - 1, cell.cropNode != nil {
                for popOutRow in 0..<gameScene.boardNode.nbRows - 1 {
                    let cell1 = gameScene.boardNode.cellMatrix[popOutRow][col]
                    let cell2 = gameScene.boardNode.cellMatrix[popOutRow + 1][col]
                    
                    if let cropNode = cell2.cropNode {
                        cropNode.removeFromParent()
                        cell1.cropNode = cropNode
                    } else {
                        cell1.imagePath = cell2.imagePath
                    }
                }
                if let crop = self.crop, let copy = NodeHelper.deepCopyCropNode(crop) {
                    gameScene.boardNode.cellMatrix[gameScene.boardNode.nbRows - 1][col].cropNode = copy
                } else {
                    gameScene.boardNode.cellMatrix[gameScene.boardNode.nbRows - 1][col].imagePath = self.imagePath
                }
                dragged.removeFromParent()
            } else {
                dragged.run(moveActionX) {
                    let moveActionY = SKAction.move(to: CGPoint(x: convertedPosition.x, y: convertedPosition.y), duration: 0.4)
                    
                    dragged.run(moveActionY) {
                        if let crop = self.crop, let copy = NodeHelper.deepCopyCropNode(crop) {
                            cell.cropNode = copy
                        } else {
                            cell.imagePath = self.imagePath
                        }
                        dragged.removeFromParent()
                    }
                }
            }
        } else {
            if let crop = self.crop, let copy = NodeHelper.deepCopyCropNode(crop) {
                cell.cropNode = copy
            } else {
                cell.imagePath = self.imagePath
            }
            dragged.removeFromParent()
        }
    }
    
    public func getCellCoordinates(from touch : UITouch, in board : BoardNode) -> (row: Int, col: Int) {
        let touchPoint = touch.location(in: board)
        let col = Int(floor(touchPoint.x / (board.width / CGFloat(board.nbColumns))))
        let row = Int(floor(touchPoint.y / (board.height / CGFloat(board.nbRows))))
        return (row, col)
    }
}
