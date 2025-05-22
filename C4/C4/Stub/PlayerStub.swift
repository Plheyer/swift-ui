import Foundation
import Connect4Core

public struct PlayerStub {
    public func getPlayersVM() -> [PlayerVM]
    {
        return [
            PlayerVM(name: "Erwan"),
            PlayerVM(name: "Clément"),
            PlayerVM(name: "Mathis"),
            PlayerVM(name: "Renaud"),
            PlayerVM(name: "Emma"),
            PlayerVM(name: "M. Chevaldonne"),
            PlayerVM(name: "Corentin"),
            PlayerVM(name: "Géraldine Tulipe"),
        ]
    }
}
