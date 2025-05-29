import SwiftUI
import PhotosUI
import Connect4Core
import Connect4Players

struct ChoosePlayerComponent: View {
    @ObservedObject public var playerVM : PlayerVM
    @ObservedObject public var newPlayerVM : PlayerVM
    @State private var avatarItem: PhotosPickerItem?
    
    
    var playerText: String
    var playersType: [String] = ["\(HumanPlayer.self)", "\(RandomPlayer.self)", "\(FinnishHimPlayer.self)", "\(SimpleNegaMaxPlayer.self)"]
    var players: [PlayerVM] = PlayerStub().getPlayersVM()
    
    var body: some View {
        VStack {
            Text(playerText)
            Picker("Player type", selection: $playerVM.type) {
                ForEach(playersType, id: \.self) { player in
                    Text(PlayerVM.getLocalizedType(from: player))
                }
            }
            .tint(.primaryAccentBackground)
            if (playerVM.type == "\(HumanPlayer.self)") {
                HStack {
                    Picker("Player", selection: $playerVM.name) {
                        ForEach(players.map { $0.name }, id: \.self) { name in
                            Text(name)
                        }
                    }
                    .tint(Color(.primaryAccentBackground))
                    Button("", systemImage: "plus") {
                        newPlayerVM.onEditing()
                    }
                    .tint(Color(.primaryAccentBackground))
                }
            } else {
                Text(PlayerVM.getLocalizedType(from: playerVM.type))
            }
            playerVM.image
                .resizable()
                .frame(width: 100, height: 100)
            if (playerVM.type == "\(HumanPlayer.self)") {
                HStack {
                    PhotosPicker(selection: $avatarItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo.artframe")
                            Text(String(localized: "Modify"))
                        }
                    }
                    .tint(Color(.primaryAccentBackground))
                }
                .onChange(of: avatarItem) {
                    Task {
                        if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                            playerVM.image = loaded
                        } else {
                            print("Failed")
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ChoosePlayerComponentPreview()
}

private struct ChoosePlayerComponentPreview : View {
    @State var player1VM = PlayerVM(name: "Player 1", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)")
    @State var player2VM = PlayerVM(name: "Player 2", owner: .player2, image: Image("DefaultPlayerImage"), type: "\(RandomPlayer.self)")
    @State var newPlayerVM = PlayerVM(name: "", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)")
    var body: some View {
        HStack{
            ChoosePlayerComponent(playerVM: player1VM, newPlayerVM: newPlayerVM, playerText: "Player 1")
            ChoosePlayerComponent(playerVM: player2VM, newPlayerVM: newPlayerVM, playerText: "Player 2")
        }
        Spacer()
    }
}
