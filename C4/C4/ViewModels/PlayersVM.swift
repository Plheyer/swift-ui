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
    
    public func loadAllPlayersAndAIs() async {
        await loadAllPlayers()
        let AIs = ["\(RandomPlayer.self)", "\(FinnishHimPlayer.self)", "\(SimpleNegaMaxPlayer.self)"]
        for ai in AIs {
            await loadOnePlayer(player: PlayerData(name: ai, id: .player1, type: ai))
        }
    }
    
    public func loadAllPlayers() async {
        do {
            let playersLoaded = try await Persistance.getPlayers(withName: "players.co4")
            if let playersLoaded {
                DispatchQueue.main.async {
                    self.players.removeAll()
                }
                for player in playersLoaded {
                    await loadOnePlayer(player: PlayerData(name: player.name, id: player.id, type: "\(HumanPlayer.self)"))
                }
            }
        } catch {
            print("No players found")
        }
    }
    
    private func loadOnePlayer(player: PlayerData) async {
        do {
            let loaded = try await Persistance.loadImage(withName: player.name, withFolderName: "images")
            let playerImage = loaded.image ?? Image("DefaultPlayerImage")
            let playerImagePath = loaded.path
            let playerVM = PlayerVM(with: PlayerModel(name: player.name, owner: player.id, image: playerImage, type: "\(HumanPlayer.self)", imagePath: playerImagePath))
            DispatchQueue.main.async {
                self.players.append(playerVM)
            }
        } catch {
            print("No players found")
        }
    }
}
