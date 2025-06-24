import SwiftUI

struct GameARViewRepresentable: UIViewRepresentable {
    var gameARView: GameARView
    func makeUIView(context: Context) -> GameARView {
        gameARView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
