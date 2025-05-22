import Foundation
import Connect4Core

public struct GamesStub {
    public func getGamesVM() -> [GamesVM]
    {
        let player1 = Player(withName: "Erwan", andId: Owner.player1)!
        let player2 = Player(withName: "Clément", andId: Owner.player2)!
        let player3 = Player(withName: "Mathis", andId: Owner.player1)!
        let player4 = Player(withName: "Renaud", andId: Owner.player2)!
        let player5 = Player(withName: "Emma", andId: Owner.player1)!
        let player6 = Player(withName: "M. Chevaldonne", andId: Owner.player2)!
        let player7 = Player(withName: "Corentin", andId: Owner.player1)!
        let player8 = Player(withName: "Géraldine Tulipe", andId: Owner.player2)!
        
        let classic = Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!
        let boards = BoardStub().getBoards()
        
        return [
            GamesVM(games: [
                GameVM(date: Date(timeIntervalSinceReferenceDate: 12345678), players: [player1, player2], rules: classic, board: boards[0]),
                GameVM(date: Date(timeIntervalSinceReferenceDate: 223523441), players: [player5, player4], rules: classic, board: boards[1]),
                GameVM(date: Date(timeIntervalSinceReferenceDate: 215373932), players: [player1, player7], rules: classic, board: boards[2]),
                GameVM(date: Date(timeIntervalSinceReferenceDate: 265483930), players: [player3, player2], rules: classic, board: boards[3]),
                GameVM(date: Date(timeIntervalSinceReferenceDate: 246393303), players: [player8, player6], rules: classic, board: boards[4])
            ]),
            GamesVM(games: [
                GameVM(date: Date(timeIntervalSinceReferenceDate: 235673832), players: [player3, player7], rules: classic, board: boards[5]),
                GameVM(date: Date(timeIntervalSinceReferenceDate: 256483932), players: [player1, player6], rules: classic, board: boards[6]),
                GameVM(date: Date(timeIntervalSinceReferenceDate: 276483723), players: [player4, player2], rules: classic, board: boards[4]),
                GameVM(date: Date(timeIntervalSinceReferenceDate: 287453622), players: [player4, player3], rules: classic, board: boards[3]),
                GameVM(date: Date(timeIntervalSinceReferenceDate: 284925233), players: [player8, player6], rules: classic, board: boards[1])
            ])
        ]
    }
}
