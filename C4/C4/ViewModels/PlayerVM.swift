import SwiftUI
import Connect4Core
import Connect4Persistance
import Connect4Players

public class PlayerVM : Identifiable, ObservableObject, Hashable {
    public let id : UUID // Only to be identifiable in a list
    @Published public var name : String
    @Published public var image: Image
    @Published public var imagePath: String?
    @Published public var type : String // Not only useful when displaying all the players, to know which one is an AI, also when choosing a player type when launching a game
    @Published var isEditing: Bool = false // For the modal view
    
    public var model : Player? {
        switch (type) {
        case "\(HumanPlayer.self)":
            return HumanPlayer(withName: self.name, andId: .player1)
        case "\(FinnishHimPlayer.self)":
            return FinnishHimPlayer(withName: self.name, andId: .player1)
        case "\(SimpleNegaMaxPlayer.self)":
            return SimpleNegaMaxPlayer(withName: self.name, andId: .player1)
        default:
            return nil
        }
    }
    
    public init(name : String, owner: Owner, image: Image, type: String, imagePath: String? = "") {
        self.id = UUID()
        self.name = name
        self.image = image
        self.type = type
        self.imagePath = imagePath
    }
    
    public static func == (lhs: PlayerVM, rhs: PlayerVM) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public func onEditing() {
        self.isEditing = true
    }
    
    public func onEdited(isCancelled: Bool = true) async {
        if !isCancelled {
            await savePlayer()
            await savePlayerImage()
        }
        await MainActor.run {
            self.isEditing = false
        }
        self.name = ""
        self.image = Image("DefaultPlayerImage")
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
    
    // Public to allow image updates
    public func savePlayerImage() async {
        do {
            self.imagePath = try await Persistance.saveImage(self.image, withName: self.name, withFolderName: "images")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Private because to save a Player, it's required to pass through onEdited
    private func savePlayer() async {
        let player = HumanPlayer(withName: self.name, andId: .player1)
        if let player {
            do {
                // Saving as a HumanPlayer because we can't create AI Players
                _ = try await Persistance.addPlayer(withName: "players", andPlayer: player)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
