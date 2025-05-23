//
//  ResultExtensions.swift
//  C4
//
//  Created by etudiant on 21/05/2025.
//

import Foundation
import Connect4Core
import Connect4Rules

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
}
