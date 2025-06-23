import SwiftUI
import PhotosUI
import Connect4Core
import Connect4Players
import Connect4Persistance

struct ChoosePlayerComponent: View {
    @ObservedObject public var playerVM : PlayerVM
    @ObservedObject var playersVM: PlayersVM
    @StateObject var newPlayerVM: PlayerVM = PlayerVM(with: PlayerModel(name: "", owner: .noOne, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)"))
    @State private var avatarItem: PhotosPickerItem?
    @State private var originalName: String = ""
    
    var playerText: String
    var playersType: [String] = ["\(HumanPlayer.self)", "\(RandomPlayer.self)", "\(FinnishHimPlayer.self)", "\(SimpleNegaMaxPlayer.self)"]
    
    var body: some View {
        VStack {
            Picker("Player type", selection: $playerVM.model.type) {
                ForEach(playersType, id: \.self) { player in
                    Text(PlayerModel.getLocalizedType(from: player))
                }
            }
            .tint(.primaryAccentBackground)
            .onChange(of: playerVM.model.type) {
                if playerVM.model.type == "\(HumanPlayer.self)" {
                    playerVM.model.name = playersVM.players.first { $0.model.type == "\(HumanPlayer.self)" }?.model.name ?? "" // Updating the name when passing to human player
                } else {
                    playerVM.model.name = playerVM.model.type
                }
            }
            if (playerVM.model.type == "\(HumanPlayer.self)") {
                HStack {
                    Picker("Player", selection: $playerVM.model.name) {
                        ForEach(playersVM.players.filter { $0.model.type == "\(HumanPlayer.self)" }.map { $0.model.name }, id: \.self) { name in
                            Text(name)
                        }
                    }
                    .tint(Color(.primaryAccentBackground))
                    .onChange(of: playerVM.model.name) {
                        Task {
                            do {
                                let loaded = try await Persistance.loadImage(withName: playerVM.model.name, withFolderName: "images")
                                
                                if let loadedImage = loaded.image {
                                    playerVM.model.image = loadedImage
                                    playerVM.model.imagePath = loaded.path
                                } else {
                                    playerVM.model.image = Image("DefaultPlayerImage")
                                    await playerVM.savePlayerImage() // Save for sync
                                }
                            } catch {
                                playerVM.model.image = Image("DefaultPlayerImage")
                                await playerVM.savePlayerImage() // Save for sync
                            }
                        }
                    }
                    Button("", systemImage: "plus") {
                        newPlayerVM.model.name = ""
                        newPlayerVM.model.image = Image("DefaultPlayerImage")
                        newPlayerVM.isEditing = true
                        originalName = newPlayerVM.model.name
                    }
                    .tint(Color(.primaryAccentBackground))
                }
            } else {
                Text(PlayerModel.getLocalizedType(from: playerVM.model.type))
            }
            playerVM.model.image
                .resizable()
                .frame(width: 100, height: 100)
            if (playerVM.model.type == "\(HumanPlayer.self)") {
                HStack {
                    Button(String(localized: "Modify"), systemImage: "photo.artframe") {
                        newPlayerVM.model.name = playerVM.model.name
                        newPlayerVM.model.image = playerVM.model.image
                        newPlayerVM.isEditing = true
                        originalName = newPlayerVM.model.name
                    }
                    .tint(Color(.primaryAccentBackground))
                }
            }
        }
        .padding()
        .sheet(isPresented: $newPlayerVM.isEditing, onDismiss: {
            Task { await playersVM.loadAllPlayers() } }
        ) {
            NavigationStack {
                AddPlayerComponent(playerVM: newPlayerVM, playersVM: playersVM, originalName: originalName)
            }
        }
    }
}

#Preview {
    ChoosePlayerComponentPreview()
}

private struct ChoosePlayerComponentPreview : View {
    @State var player1VM = PlayerVM(with: PlayerModel(name: "Player 1", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)"))
    @State var player2VM = PlayerVM(with: PlayerModel(name: "Player 2", owner: .player2, image: Image("DefaultPlayerImage"), type: "\(RandomPlayer.self)"))
    @State public var players = PlayersVM()
    var body: some View {
        HStack{
            ChoosePlayerComponent(playerVM: player1VM, playersVM: players, playerText: "Player 1")
            ChoosePlayerComponent(playerVM: player2VM, playersVM: players, playerText: "Player 2")
        }
        Spacer()
    }
}
