import Foundation
import Connect4Core
import SwiftUI

public struct PlayerStub {
    public func getPlayersVM() -> [PlayerVM]
    {
        return [
            PlayerVM(name: "Erwan", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer"),
            PlayerVM(name: "Clément", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer"),
            PlayerVM(name: "Mathis", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer"),
            PlayerVM(name: "Renaud", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer"),
            PlayerVM(name: "Emma", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer"),
            PlayerVM(name: "M. Chevaldonne", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer"),
            PlayerVM(name: "Corentin", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer"),
            PlayerVM(name: "Géraldine Tulipe", owner: .player1, image: Image("DefaultPlayerImage"), type: "HumanPlayer"),
        ]
    }
}
