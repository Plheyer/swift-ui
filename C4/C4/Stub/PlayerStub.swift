import Foundation
import Connect4Core
import SwiftUI

public struct PlayerStub {
    public func getPlayersVM() -> [PlayerVM]
    {
        return [
            PlayerVM(name: "Erwan", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png")),
            PlayerVM(name: "Clément", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp")),
            PlayerVM(name: "Mathis", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png")),
            PlayerVM(name: "Renaud", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp")),
            PlayerVM(name: "Emma", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png")),
            PlayerVM(name: "M. Chevaldonne", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp")),
            PlayerVM(name: "Corentin", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "anonymous.png")),
            PlayerVM(name: "Géraldine Tulipe", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer", imagePath: getImagePath(fileName: "larry.webp")),
        ]
    }
    
    public func getImagePath(fileName : String) -> String {
        return "/Users/etudiant/Downloads/\(fileName)"
    }
}
