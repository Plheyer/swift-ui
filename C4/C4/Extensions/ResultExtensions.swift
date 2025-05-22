//
//  ResultExtensions.swift
//  C4
//
//  Created by etudiant on 21/05/2025.
//

import Foundation
import Connect4Core

public extension Result {
    var description : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .even: return "Even"
        case .notFinished: return "Not Finished"
        case .winner(winner: let winner, alignment: _): return "\(winner.simpleDescription) Won"
        @unknown default:
            return "Unknown"
        }
      }
}
