// It's the model to use a struct and the copy mechanism showed during the course
import Foundation
import Connect4Core
import SwiftUI
import Connect4Players

public struct PlayerModel {
    public let id: UUID
    public var name: String
    public var owner: Connect4Core.Owner
    public var type: String
    public var image: Image
    public var imagePath: String
    
    public init(name : String, owner: Owner, image: Image, type: String, imagePath: String = "") {
        self.id = UUID()
        self.name = name
        self.owner = owner
        self.image = image
        self.type = type
        self.imagePath = imagePath
    }
    
    public static func getLocalizedType(from type: String) -> String {
        switch (type) {
        case "\(HumanPlayer.self)":
            return String(localized: "Human")
        case "\(RandomPlayer.self)":
            return String(localized: "Random")
        case "\(FinnishHimPlayer.self)":
            return String(localized: "FinishHim")
        case "\(SimpleNegaMaxPlayer.self)":
            return String(localized: "Negamax")
        default:
            return "Unknown"
        }
    }
}
