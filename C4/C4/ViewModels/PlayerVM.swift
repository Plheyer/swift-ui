//
//  GameVM.swift
//  C4
//
//  Created by etudiant on 21/05/2025.
//

import SwiftUI
import Connect4Core

public class PlayerVM : Identifiable, ObservableObject, Hashable {
    public let id : UUID
    public let name : String
    
    public init(name : String) {
        self.id = UUID()
        self.name = name
    }
    
    public static func == (lhs: PlayerVM, rhs: PlayerVM) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
