import SwiftUI
import Connect4Core
import Connect4Persistance

// This VM is used to handle results in lists, thus we need : Identifiable, Hashable, ...
public class GameResultVM : Identifiable, ObservableObject, Hashable {
    public let date: Date
    public let players: [PlayerData]
    public let rules: RulesData
    public let winner: Owner
    
    public init(date : Date, players : [PlayerData], rules : RulesData, winner: Owner) {
        self.date = date
        self.players = players
        self.rules = rules
        self.winner = winner
    }
    
    public static func == (lhs: GameResultVM, rhs: GameResultVM) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
