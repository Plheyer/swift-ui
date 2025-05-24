import SwiftUI
import PhotosUI
import Connect4Core
import Connect4Players

struct ChoosePlayerComponent: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image? = Image("HomeImage")
    
    @Binding var selectedPlayerType: String
    @Binding var selectedPlayer: PlayerVM
    @Binding var isPresented: Bool
    var playerText: String
    var playersType: [String] = [String(localized: "Human"), String(localized: "Random"), String(localized: "FinishHim"), String(localized: "Negamax")]
    var players: [PlayerVM] = PlayerStub().getPlayersVM()
    
    var body: some View {
        VStack {
            Text(playerText)
            Picker("Player type", selection: $selectedPlayerType) {
                ForEach(playersType, id: \.self) { player in
                    Text(player)
                }
            }
            .tint(.primaryAccentBackground)
            if (selectedPlayerType == String("Human")) {
                HStack {
                    Picker("Player", selection: $selectedPlayer) {
                        ForEach(players, id: \.self) { player in
                            Text(player.name)
                        }
                    }
                    .tint(Color(.primaryAccentBackground))
                    Button("", systemImage: "plus") {
                        isPresented.toggle()
                    }
                    .tint(Color(.primaryAccentBackground))
                }
            } else {
                Text(selectedPlayer.name)
            }
            avatarImage?
                .resizable()
                .frame(width: 100, height: 100)
            if (selectedPlayerType == String("Human")) {
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
                            avatarImage = loaded
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
    @State var selectedPlayerType1: String = String("Human")
    @State var selectedPlayerType2: String = String("Random")
    @State var selectedPlayer1: PlayerVM = PlayerVM(name: "Player 1")
    @State var selectedPlayer2: PlayerVM = PlayerVM(name: "Player 2")
    @State var isPresented: Bool = false
    var body: some View {
        HStack{
            ChoosePlayerComponent(selectedPlayerType: $selectedPlayerType1, selectedPlayer: $selectedPlayer1, isPresented: $isPresented, playerText: "Player 1")
            ChoosePlayerComponent(selectedPlayerType: $selectedPlayerType2, selectedPlayer: $selectedPlayer2, isPresented: $isPresented, playerText: "Player 2")
        }
        Spacer()
    }
}
