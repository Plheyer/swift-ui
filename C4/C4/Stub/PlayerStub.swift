import Foundation
import Connect4Core
import SwiftUI

public struct PlayerStub {
    public func getPlayersModel() -> [PlayerModel]
    {
        return [
            PlayerModel(name: "Erwan", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png")),
            PlayerModel(name: "Clément", owner: .player2, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp")),
            PlayerModel(name: "Mathis", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png")),
            PlayerModel(name: "Renaud", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp")),
            PlayerModel(name: "Emma", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png")),
            PlayerModel(name: "M. Chevaldonne", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp")),
            PlayerModel(name: "Corentin", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png")),
            PlayerModel(name: "Géraldine Tulipe", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp")),
        ]
    }
    
    public func getImagePath(fileName : String) -> String {
        return "/Users/etudiant/Downloads/\(fileName)"
    }
}
