import Foundation
import SpriteKit

public struct NodeHelper {
    public static func deepCopyCropNode(_ original: SKCropNode?) -> SKCropNode? {
        if let original {
            let copy = SKCropNode()
            
            // Copy the mask
            if let mask = original.maskNode?.copy() as? SKShapeNode {
                copy.maskNode = mask
            }

            // Copy children
            for child in original.children {
                if let childCopy = child.copy() as? SKNode {
                    copy.addChild(childCopy)
                }
            }
            
            return copy
        }
        return nil
    }
}
