import SwiftUI
import Connect4Core
import Connect4Persistance
import Connect4Players

extension PlayerModel {
    struct Data: Identifiable {
        public let id: UUID
        public var name: String
        public var owner: Connect4Core.Owner
        public var type: String
        public var image: Image
        public var imagePath: String
        public var imageEdited = false
    }
    
    var data: Data {
        Data(id: self.id, name: self.name, owner: self.owner, type: self.type, image: self.image, imagePath: self.imagePath)
    }
    
    mutating nonisolated func update(from data: Data) async {
        guard data.id == id else { return }
        self.name = data.name
        self.owner = data.owner
        self.type = data.type
        self.image = data.image
        self.imagePath = data.imagePath
        await savePlayer()
        if data.imageEdited {
            await savePlayerImage()
        }
    }
    
    public var toC4Model : Player? {
        switch (type) {
        case "\(HumanPlayer.self)":
            return HumanPlayer(withName: self.name, andId: self.owner)
        case "\(RandomPlayer.self)":
            return RandomPlayer(withName: self.name, andId: self.owner)
        case "\(FinnishHimPlayer.self)":
            return FinnishHimPlayer(withName: self.name, andId: self.owner)
        case "\(SimpleNegaMaxPlayer.self)":
            return SimpleNegaMaxPlayer(withName: self.name, andId: self.owner)
        default:
            return nil
        }
    }
    
    // Public to allow image updates
    public mutating func savePlayerImage() async {
        do {
            if let uiImage = try? self.image.asUIImage() {
                let targetSize = CGSize(width: 82, height: 82) // 8192 = max image, /100
                let resizedImage = Image(uiImage: ImageHelper.resizeImage(image: uiImage, targetSize: targetSize) ?? uiImage)
                
                self.imagePath = try await Persistance.saveImage(resizedImage, withName: self.name, withFolderName: "images") ?? ""
            }
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
                _ = try await Persistance.addPlayer(withName: "players.co4", andPlayer: player)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

public class PlayerVM : Identifiable, ObservableObject, Hashable {
    var original: PlayerModel
    @Published var model: PlayerModel.Data
    @Published var isEditing: Bool = false // For the modal view
    
    init(with player: PlayerModel) {
        original = player
        model = original.data
    }
    
    public static func == (lhs: PlayerVM, rhs: PlayerVM) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public func toModel() -> PlayerModel {
        return original
    }
    
    // When updating a player (or creating it)
    public func onEditing() {
        self.isEditing = true
    }
    
    public func onEdited() {
        self.isEditing = false
    }
    
    // When selecting the player to play with
    public func onSelecting() {
        model = original.data
        // No self.isEditing = true because it's used for the .sheet, and we use onEditing only after chosen the player, it's not the modification of the player but the choice of the player
    }
    
    public func onSelected(isCancelled: Bool = true) async {
        if !isCancelled {
            DispatchQueue.main.async {
                Task {
                    await self.original.update(from: self.model)
                }
            }
        }
        DispatchQueue.main.async {
            self.model = self.original.data
        }
    }
    
    // Public to allow image updates
    public func savePlayerImage() async {
        do {
            if let uiImage = try? self.model.image.asUIImage() {
                let targetSize = CGSize(width: 82, height: 82) // 8192 = max image, /100
                let resizedImage = Image(uiImage: ImageHelper.resizeImage(image: uiImage, targetSize: targetSize) ?? uiImage)
                
                self.model.imagePath = try await Persistance.saveImage(resizedImage, withName: self.model.name, withFolderName: "images") ?? ""
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
