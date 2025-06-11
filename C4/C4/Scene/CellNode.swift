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
    
    private var _imagePath: String?
    public var spriteNode: SKSpriteNode?
    
    var imagePath: String? {
        get { _imagePath }
        set {
            _imagePath = newValue
            if let spriteNode {
                spriteNode.removeFromParent()
            }
            if let imagePath = newValue {
                let sprite : SKSpriteNode
                if let image = UIImage(contentsOfFile: imagePath) {
                    let maxSize = CGSize(width: 82, height: 82)
                    let resizedImage = ImageHelper.resizeImage(image: image, targetSize: maxSize) ?? image
                    let texture = SKTexture(image: resizedImage)
                    
                    sprite = SKSpriteNode(texture: texture)
                } else {
                    sprite = SKSpriteNode(imageNamed: "DefaultPlayerImage")
                }
                sprite.size.width = width
                sprite.size.height = height
                sprite.position.x = width / 2
                sprite.position.y = height / 2
                spriteNode = sprite
                
                let crop = SKCropNode()
                let mask = SKShapeNode(ellipseIn: CGRect(x: 0, y: 0, width: width, height: height))
                mask.fillColor = .white
                crop.maskNode = mask
                crop.addChild(sprite)
                self.addChild(crop)
            }
        }
    }
    
    private var _cropNode: SKCropNode?
    
    var cropNode: SKCropNode? {
        get { _cropNode }
        set {
            _cropNode = newValue
            if let cropNode = newValue {
                self.addChild(cropNode)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeColor(color: UIColor) {
        shapeNode.fillColor = color
    }
}
