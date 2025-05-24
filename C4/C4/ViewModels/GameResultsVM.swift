//
//  GameVM.swift
//  C4
//
//  Created by etudiant on 21/05/2025.
//

import SwiftUI
import Connect4Core
import Connect4Persistance

public class GameResultsVM : ObservableObject {
    @Published public var gameResults : [GameResultVM]
    
    public init(gameResults: [GameResultVM]) {
        self.gameResults = gameResults
    }
    
    public convenience init() {
        self.init(gameResults: [])
    }
}
