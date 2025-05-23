//
//  PlayerExtensions.swift
//  C4
//
//  Created by etudiant on 23/05/2025.
//

import Foundation
import Connect4Core

public extension Player {
    var type : String {
        switch self {
            case is HumanPlayer:
                return "Human"
            case is AIPlayer:
                return "AI"
            default:
                return "Unknown"
        }
    }
}
