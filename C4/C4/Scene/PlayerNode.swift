import Foundation
import SpriteKit

public class PlayerNode : SKNode {
    let width: CGFloat
    let height: CGFloat
    let imagePath : String
    var crop : SKCropNode?
    
    let droppedAction: (CGPoint, String?, SKCropNode?) -> ()
    
    var ghost : PlayerNode?
    
    public init(width: CGFloat, height: CGFloat, imagePath: String, droppedAction: @escaping (CGPoint, String?, SKCropNode?) -> ()) {
        self.width = width
        self.height = height
        self.imagePath = imagePath
        self.droppedAction = droppedAction
        super.init()
        
        let sprite : SKSpriteNode
        if let image = UIImage(contentsOfFile: imagePath) {
            let maxSize = CGSize(width: 819, height: 819) // max is 8192 but it would make the app lag so I divided by 10
            let resizedImage = ImageHelper.resizeImage(image: image, targetSize: maxSize) ?? image // Having a bug/crash when there's not this call because the image is too big for the Texture
            let texture = SKTexture(image: resizedImage)
            
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
    
    public init(width: CGFloat, height: CGFloat, crop: SKCropNode?, droppedAction: @escaping (CGPoint, String?, SKCropNode?) -> ()) {
        self.width = width
        self.height = height
        self.crop = crop
        self.droppedAction = droppedAction
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
        let dragged: PlayerNode
        if let nodeCopy = crop?.copy(), let cropCopy = nodeCopy as? SKCropNode {
            dragged = PlayerNode(width: width, height: height, crop: cropCopy, droppedAction: droppedAction) // More opti, but can fail
        } else {
            dragged = PlayerNode(width: width, height: height, imagePath: imagePath, droppedAction: droppedAction)
        }
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
            
            if let copy = NodeHelper.deepCopyCropNode(self.crop) {
                droppedAction(correctedPosition, nil, copy) // More opti, but can fail (to copy)
            } else {
                droppedAction(correctedPosition, self.imagePath, nil)
            }
        }
    }
}
