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
    
    public func loadAllPlayers() async {
        do {
            let playersLoaded = try await Persistance.getPlayers(withName: "players")
            if let playersLoaded {
                DispatchQueue.main.async {
                    self.players.removeAll()
                }
                for player in playersLoaded {
                    let loaded = try await Persistance.loadImage(withName: player.name, withFolderName: "images")
                    let playerImage = loaded.image ?? Image("DefaultPlayerImage")
                    let playerImagePath = loaded.path
                    let playerVM = PlayerVM(name: player.name, owner: player.id, image: playerImage, type: "\(HumanPlayer.self)", imagePath: playerImagePath)
                    DispatchQueue.main.async {
                        self.players.append(playerVM)
                    }
                }
            }
        } catch {
            print("No players found")
        }
    }
    
    // May not be useful, waiting to see... TODO: remove it
//    // Allows to create default AIs when they don't exist
//    private static func loadAIs() async -> [PlayerVM] {
//        var players : [PlayerVM] = []
//        let ais = ["\(RandomPlayer.self)" : RandomPlayer(withName: "\(RandomPlayer.self)", andId: .player1), "\(FinnishHimPlayer.self)" : FinnishHimPlayer(withName: "\(FinnishHimPlayer.self)", andId: .player1), "\(SimpleNegaMaxPlayer.self)" : SimpleNegaMaxPlayer(withName: "\(SimpleNegaMaxPlayer.self)", andId: .player1)]
//        
//        do {
//            // Fetching each default AI
//            for ai in ais {
//                do {
//                    if let aiPlayer = ai.value {
//                        _ = try await Persistance.addPlayer(withName: "players", andPlayer: aiPlayer)
//                        players.append(PlayerVM(name: aiPlayer.name, owner: aiPlayer.id, image: Image("DefaultPlayerImage"), type: aiPlayer.type))
//                    }
//                } catch {
//                    // Not existing player
//                    print("Error: Can't save an AI.")
//                }
//            }
//        }
//        return players
//    }
}
