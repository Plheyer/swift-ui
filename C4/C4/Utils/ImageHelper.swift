import UIKit

public struct ImageHelper {
    public static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let sourceSize = image.size
        let min = min(sourceSize.width, sourceSize.height)
        let ratio = min > 1000 ? min / 1000 : min
        let newSize = CGSize(width: sourceSize.width / ratio, height: sourceSize.height / ratio)

        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)

        image.draw(in: CGRect(origin: .zero, size: newSize))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
