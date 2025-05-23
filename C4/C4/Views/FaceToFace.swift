import SwiftUI
import Connect4Core
import Charts

struct FaceToFace: View {
    @State public var games : [(name: String, value: Int)] = [
        (Connect4Core.Result.even.description, GamesStub().getGamesVM()[1].games.filter { $0.getGameResult() == .even }.count ),
        (Connect4Core.Result.winner(winner: .player1, alignment: []).description, GamesStub().getGamesVM()[1].games.filter {
            if case .winner(let w, _) = $0.getGameResult(), w == .player2 {
                return true
            }
            return false
        }.count ),
        (Connect4Core.Result.winner(winner: .player2, alignment: []).description, GamesStub().getGamesVM()[1].games.filter {
            if case .winner(let w, _) = $0.getGameResult(), w == .player1 {
                return true
            }
            return false
        }.count ),
        ("test", GamesStub().getGamesVM()[1].games.count ),
        ]
    
    @State public var player1 : PlayerVM = PlayerStub().getPlayersVM()[0]
    @State public var player2 : PlayerVM = PlayerStub().getPlayersVM()[1]
    @State public var players : [PlayerVM] = PlayerStub().getPlayersVM()
    var body: some View {
         ScrollView {
             HStack(spacing: 10) {
                 FaceToFacePlayerComponent(selectedPlayer: $player1, players: $players).frame(maxWidth: .infinity, alignment: .leading)
                 FaceToFaceChartComponent(games: $games).frame(maxWidth: .infinity, alignment: .center)
                 FaceToFacePlayerComponent(selectedPlayer: $player2, players: $players).frame(maxWidth: .infinity, alignment: .trailing)
             }
             FaceToFaceListComponent(games: GamesStub().getGamesVM()[1])
        }
         .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
        .navigationBarTitle(String(localized: "SavedGamesTitle"))
    }
}

#Preview {
    FaceToFace(games: [
            ("Even", 4),
            ("2 Wins", 3),
            ("Player 1 Wins", 2)
        ])
    //FaceToFace()
}
