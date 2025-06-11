import SwiftUI
import PhotosUI
import Connect4Core
import Connect4Players
import Connect4Persistance

// This is a separate view because we need to observe playersVM.current.isEditing, but because it's nested, swift UI does not check every nestde property. We need to provide this class reference as a component parameter to force swift UI to watch all properties of this reference thanks to ObservedObject. I don't use playerVM but it force swift UI to observe changes of the playersVM.current and thus allowing us to use isPresented: $playersVM.current.isEditing
struct ChoosePlayerSheetComponent: View {
    @ObservedObject public var playerVM : PlayerVM
    @ObservedObject var playersVM: PlayersVM
    
    var body: some View {
        VStack {
        }
        .padding()
        
    }
}

#Preview {
    ChoosePlayerSheetComponentPreview()
}

private struct ChoosePlayerSheetComponentPreview : View {
    @State var player1VM = PlayerVM(with: PlayerModel(name: "Player 1", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)"))
    @State var player2VM = PlayerVM(with: PlayerModel(name: "Player 2", owner: .player2, image: Image("DefaultPlayerImage"), type: "\(RandomPlayer.self)"))
    @State public var players = PlayersVM()
    var body: some View {
        HStack{
            ChoosePlayerSheetComponent(playerVM: player1VM, playersVM: players)
            ChoosePlayerSheetComponent(playerVM: player2VM, playersVM: players)
        }
        Spacer()
    }
}
