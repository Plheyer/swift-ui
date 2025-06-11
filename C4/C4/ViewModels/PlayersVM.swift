import SwiftUI
import Connect4Core
import Connect4Persistance
import Connect4Players

public class PlayersVM : ObservableObject {
    @Published public var players : [PlayerVM]
    
    public init(players: [PlayerVM]) {
        self.players = players
    }
    
    public convenience init() {
        self.init(players: [])
    }
    
    public func update(with playerVM: PlayerVM) {
        if let i = players.firstIndex(where: { $0.model.id == playerVM.model.id }) {
            players[i] = playerVM
        } else {
            players.append(playerVM)
        }
    }
    
    public func loadAllPlayers() async {
        do {
            let playersLoaded = try await Persistance.getPlayers(withName: "players22")
            if let playersLoaded {
                DispatchQueue.main.async {
                    self.players.removeAll()
                }
                for player in playersLoaded {
                    let loaded = try await Persistance.loadImage(withName: player.name, withFolderName: "images")
                    let playerImage = loaded.image ?? Image("DefaultPlayerImage")
                    let playerImagePath = loaded.path
                    let playerVM = PlayerVM(with: PlayerModel(name: player.name, owner: player.id, image: playerImage, type: "\(HumanPlayer.self)", imagePath: playerImagePath))
                    DispatchQueue.main.async {
                        self.players.append(playerVM)
                    }
                }
            }
        } catch {
            print("No players found")
        }
    }
}
