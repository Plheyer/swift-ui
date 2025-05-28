//
//  GameVM.swift
//  C4
//
//  Created by etudiant on 21/05/2025.
//

import SwiftUI
import Connect4Core
import Connect4Persistance

public class PlayersVM : ObservableObject {
    @Published public var players : [PlayerVM]
    
    public init(players: [PlayerVM]) {
        self.players = players
    }
    
    public convenience init() {
        self.init(players: [])
    }
}
