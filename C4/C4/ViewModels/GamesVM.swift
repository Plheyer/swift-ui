//
//  GameVM.swift
//  C4
//
//  Created by etudiant on 21/05/2025.
//

import SwiftUI
import Connect4Core

public class GamesVM : ObservableObject {
    public let games : [GameVM]
    
    public init(games: [GameVM]) {
        self.games = games
    }
    
    public convenience init() {
        self.init(games: [])
    }
}
