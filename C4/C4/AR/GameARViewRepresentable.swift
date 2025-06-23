import SwiftUI

struct GameARViewRepresentable: UIViewRepresentable {
    var gameVM: GameVM
    func makeUIView(context: Context) -> GameARView {
        GameARView(nbRows: 6, nbColumns: 7, gameVM: gameVM)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
