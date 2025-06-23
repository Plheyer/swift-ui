import SwiftUI

struct GameARViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> GameARView {
        GameARView(nbRows: 6, nbColumns: 7)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
