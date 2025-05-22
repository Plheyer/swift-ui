import Foundation
import Connect4Core

public struct BoardStub {
    public func getBoards() -> [Board]
    {
        return [
            Board(withGrid: [
                [Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player2), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .noOne), Piece(withOwner: .player1), Piece(withOwner: .player2)],
                [Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player1), Piece(withOwner: .player1), Piece(withOwner: .player1)],
                [Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2)],
            ])!, // Won
            Board(withGrid: [
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .player1)],
                [Piece(withOwner: .player2), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .player2)],
                [Piece(withOwner: .player1), Piece(withOwner: .player1), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player1), Piece(withOwner: .player2)],
                [Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player1)],
            ])!, // Won
            Board(withGrid: [
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .player1), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .player1), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .noOne)],
            ])!, // Won
            Board(withGrid: [
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player2), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
            ])!, // Won
            Board(withGrid: [
                [Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1)],
                [Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2)],
                [Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1)],
                [Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2)],
                [Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1)],
                [Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2)],
            ])!, // Even
            Board(withGrid: [
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
            ])!, // Not finished
            Board(withGrid: [
                [Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .noOne), Piece(withOwner: .player1), Piece(withOwner: .noOne), Piece(withOwner: .noOne), Piece(withOwner: .player2), Piece(withOwner: .noOne), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .noOne)],
                [Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .player2), Piece(withOwner: .player1), Piece(withOwner: .noOne)],
            ])! // Not finished
        ]
    }
}
