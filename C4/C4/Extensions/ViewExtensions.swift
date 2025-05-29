import SwiftUI
import Foundation
import UIKit

extension View {
    public func asUIImage() throws -> UIImage {
        var image: UIImage?

        DispatchQueue.main.sync {
            let controller = UIHostingController(rootView: self)
            controller.view.backgroundColor = .clear
            controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.view.addSubview(controller.view)
            }

            let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
            controller.view.bounds = CGRect(origin: .zero, size: size)
            controller.view.sizeToFit()

            image = controller.view.asUIImage()
            controller.view.removeFromSuperview()
        }

        if let image = image {
            return image
        } else {
            throw NSError(domain: "View.asUIImage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to render image"])
        }
    }
}


extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
