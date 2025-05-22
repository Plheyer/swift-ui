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
    public let board : Board
    
    public var dateFormatted : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    public init(date : Date, players : [Player], rules : Rules, board: Board) {
        self.id = UUID()
        self.date = date
        self.players = players
        self.rules = rules
        self.board = board
    }
    
    public func getGameResult() -> Connect4Core.Result {
        if let lastMove = self.rules.historic.last {
            do {
                let (_, result) = try self.rules.isGameOver(withBoard: self.board, andLastRowPlayed: lastMove.row, andLastColumnPlayed: lastMove.column)
                return result
            } catch {
                return Result.notFinished
            }
        }
        return Result.notFinished
    }
    
    public func getWinnerPlayer() -> Player? {
        if let lastMove = self.rules.historic.last {
            do {
                let (_, result) = try self.rules.isGameOver(withBoard: self.board, andLastRowPlayed: lastMove.row, andLastColumnPlayed: lastMove.column)
                switch (result) {
                    case .winner(winner: let winner, alignment: _):
                        switch (winner) {
                        case .noOne:
                            return nil
                        default:
                            return self.players.first { $0.id == winner }
                        }
                    default:
                        return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
