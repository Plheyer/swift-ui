import SwiftUI
import PhotosUI
import Connect4Core
import Connect4Players
import Connect4Persistance

struct ChoosePlayerComponent: View {
    @ObservedObject public var playerVM : PlayerVM
    @ObservedObject public var newPlayerVM : PlayerVM
    @State private var avatarItem: PhotosPickerItem?
    
    
    var playerText: String
    var playersType: [String] = ["\(HumanPlayer.self)", "\(RandomPlayer.self)", "\(FinnishHimPlayer.self)", "\(SimpleNegaMaxPlayer.self)"]
    @State var players: [PlayerVM] = []
    var body: some View {
        VStack {
            Text(playerText)
            Picker("Player type", selection: $playerVM.type) {
                ForEach(playersType, id: \.self) { player in
                    Text(PlayerVM.getLocalizedType(from: player))
                }
            }
            .tint(.primaryAccentBackground)
            .onChange(of: playerVM.type) {
                if playerVM.type == "\(HumanPlayer.self)" {
                    playerVM.name = players.first { $0.type == "\(HumanPlayer.self)" }?.name ?? "Unknown" // Updating the name when passing to human player
                } else {
                    playerVM.name = playerVM.type
                }
                Task {
                    await playerVM.savePlayerImage() // Save for sync
                }
            }
            if (playerVM.type == "\(HumanPlayer.self)") {
                HStack {
                    Picker("Player", selection: $playerVM.name) {
                        ForEach(players.filter { $0.type == "\(HumanPlayer.self)" }.map { $0.name }, id: \.self) { name in
                            Text(name)
                        }
                    }
                    .tint(Color(.primaryAccentBackground))
                    .onChange(of: playerVM.name) {
                        Task {
                            do {
                                let loaded = try await Persistance.loadImage(withName: playerVM.name, withFolderName: "images")
                                
                                if let loadedImage = loaded.image {
                                    playerVM.image = loadedImage
                                    playerVM.imagePath = loaded.path
                                } else {
                                    playerVM.image = Image("DefaultPlayerImage")
                                    await playerVM.savePlayerImage() // Save for sync
                                }
                            } catch {
                                playerVM.image = Image("DefaultPlayerImage")
                                await playerVM.savePlayerImage() // Save for sync
                            }
                        }
                    }
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
                            await playerVM.savePlayerImage()
                        } else {
                            print("Failed")
                        }
                    }
                }
            }
        }
        .padding()
        .task {
            players.append(contentsOf: await PlayersVM.loadAllPlayers())
            await playerVM.savePlayerImage() // Saving default images to have a more consistent state with images, not half images as ImageSet and the other half saved in the storage.
        }
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
