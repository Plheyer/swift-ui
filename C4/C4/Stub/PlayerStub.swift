import Foundation
import Connect4Core
import SwiftUI

public struct PlayerStub {
    public func getPlayersVM() -> [PlayerVM]
    {
        return [
            PlayerVM(with: PlayerModel(name: "Erwan", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png"))),
            PlayerVM(with: PlayerModel(name: "Clément", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp"))),
            PlayerVM(with: PlayerModel(name: "Mathis", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png"))),
            PlayerVM(with: PlayerModel(name: "Renaud", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp"))),
            PlayerVM(with: PlayerModel(name: "Emma", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png"))),
            PlayerVM(with: PlayerModel(name: "M. Chevaldonne", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp"))),
            PlayerVM(with: PlayerModel(name: "Corentin", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png"))),
            PlayerVM(with: PlayerModel(name: "Géraldine Tulipe", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp"))),
        ]
    }
    
    public func getImagePath(fileName : String) -> String {
        return "/Users/etudiant/Downloads/\(fileName)"
    }
}
