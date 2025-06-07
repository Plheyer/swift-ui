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
    
    public static func loadAllPlayers() async -> [PlayerVM] {
        var players : [PlayerVM] = []
        players.append(contentsOf: await loadAIs())
        players.append(contentsOf: await loadHumanPlayers())
        return players
    }
    
    private static func loadHumanPlayers() async -> [PlayerVM] {
        var players : [PlayerVM] = []
        // TODO: Get all players and append them to players
        for player in PlayerStub().getPlayersVM() {
            do {
                let loaded = try await Persistance.loadImage(withName: player.name, withFolderName: "images")
                player.image = loaded.image ?? Image("DefaultPlayerImage")
                player.imagePath = loaded.path
            } catch {
                player.image = Image("DefaultPlayerImage")
            }
            players.append(player)
        }
        
        return players
    }
    
    // Allows to create default AIs when they don't exist
    private static func loadAIs() async -> [PlayerVM] {
        var players : [PlayerVM] = []
        let ais = ["\(RandomPlayer.self)" : RandomPlayer(withName: "\(RandomPlayer.self)", andId: .player1), "\(FinnishHimPlayer.self)" : FinnishHimPlayer(withName: "\(FinnishHimPlayer.self)", andId: .player1), "\(SimpleNegaMaxPlayer.self)" : SimpleNegaMaxPlayer(withName: "\(SimpleNegaMaxPlayer.self)", andId: .player1)]
        
        do {
            // Fetching each default AI
            for ai in ais {
                do {
                    if let loadedPlayer = try await Persistance.loadPlayer(withName: ai.key, withFolderName: "aiPlayers") {
                        // Correctly loaded player
                        players.append(PlayerVM(name: loadedPlayer.name, owner: loadedPlayer.id, image: Image("DefaultPlayerImage"), type: ai.key))
                    } else {
                        // Corrupted player
                        players.append(contentsOf: await loadAndSavePlayer(with: ai))
                    }
                } catch {
                    // Not existing player
                    players.append(contentsOf: await loadAndSavePlayer(with: ai))
                }
            }
        }
        return players
    }
    
    private static func loadAndSavePlayer(with keyValue: (key: String, value: Player?)) async -> [PlayerVM] {
        var players : [PlayerVM] = []
        do {
            if let value = keyValue.value {
                try await Persistance.savePlayer(withName: keyValue.key, andPlayer: value, withFolderName: "aiPlayers")
                if let player = try await Persistance.loadPlayer(withName: keyValue.key, withFolderName: "aiPlayers") {
                    players.append(PlayerVM(name: player.name, owner: player.id, image: Image("DefaultPlayerImage"), type: keyValue.key))
                } else {
                    print("Error when fetching back the just saved player!")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return players
    }
}
