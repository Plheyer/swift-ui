import SwiftUI

struct DeviceOrientationViewModifier: ViewModifier {
    @Binding var orientation: UIDeviceOrientation?

    func body(content: Content) -> some View {
        content
            .onAppear(perform: detectOrientation)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                detectOrientation()
            }
    }

    private func detectOrientation() {
        let current = UIDevice.current.orientation
        // Ignorer "unknown" ou "faceUp", "faceDown"
        if current.isPortrait || current.isLandscape {
            orientation = current
        }
    }
}
