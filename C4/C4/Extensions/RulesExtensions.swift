//
//  ResultExtensions.swift
//  C4
//
//  Created by etudiant on 21/05/2025.
//

import Foundation
import Connect4Core
import Connect4Rules
import Connect4Persistance

public extension Connect4Core.Rules {
    var shortName : String {
        switch self {
            case is Connect4Rules:
                return "Classic"
            case is PopOutRules:
                return "PopOut"
            case is TicTacToeRules:
                return "Tic tac toe"
            default:
                return "Unknown"
        }
    }
    
    static func getLocalizedType(from type: String) -> String {
        switch (type) {
        case "\(Connect4Rules.self)":
            return String(localized: "Connect4Rules")
        case "\(TicTacToeRules.self)":
            return String(localized: "TicTacToeRules")
        case "\(PopOutRules.self)":
            return String(localized: "PopOutRules")
        default:
            return "Unknown"
        }
    }
    
}


public extension Connect4Persistance.RulesData {
    var shortName : String {
        switch self.type {
            case "\(Connect4Rules.self)":
                return "Classic"
            case "\(PopOutRules.self)":
                return "PopOut"
            case "\(TicTacToeRules.self)":
                return "Tic tac toe"
            default:
                return "Unknown"
        }
    }
}
