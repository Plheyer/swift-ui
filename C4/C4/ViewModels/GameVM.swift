//
//  GameVM.swift
//  C4
//
//  Created by etudiant on 21/05/2025.
//

import SwiftUI
import Connect4Core

public class GameVM : Identifiable, ObservableObject {
    public let id : UUID
    public let date : Date
    public let players : [Player]
    public let rules : Rules
    
    public var dateFormatted : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    public init(date : Date, players : [Player], rules : Rules) {
        self.id = UUID()
        self.date = date
        self.players = players
        self.rules = rules
    }
}
