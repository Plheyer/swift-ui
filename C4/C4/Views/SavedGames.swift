import SwiftUI
import Connect4Core
import Connect4Persistance

struct SavedGames: View {
    @State var results : [GameResult] = []
    @StateObject public var inProgressGames : GameResultsVM = GameResultsVM()
    @StateObject public var finishedGames : GameResultsVM = GameResultsVM()
    
    public func loadResults() async {
        do {
            results = try await Persistance.loadGameResults(withName: "GameResults.co4") ?? []
            
            inProgressGames.gameResults = results.filter {
                switch ($0.winner) {
                    case .noOne:
                        return true
                    default:
                        return false
                }
            }
            .map {
                GameResultVM(date: $0.date, players: $0.players, rules: $0.rules, winner: $0.winner)
            }
            
            finishedGames.gameResults = results.filter {
                switch ($0.winner) {
                    case .player1, .player2:
                        return true
                    default:
                        return false
                }
            }
            .map {
                GameResultVM(date: $0.date, players: $0.players, rules: $0.rules, winner: $0.winner)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
         ScrollView {
            Spacer()
            GameListComponent(gameListTitle: "\(String(localized: "inProgressGames"))...", games: inProgressGames)
            Spacer()
            GameListComponent(gameListTitle: String(localized: "finishedGames"), games: finishedGames)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
        .navigationBarTitle(String(localized: "SavedGamesTitle"))
        .task {
            await loadResults()
        }
        .refreshable {
            await loadResults()
        }
    }
}

#Preview {
    VStack {
        HStack {
            saveGameButton(result: .winner(winner: .player1, alignment: []), text: "Save p1 wins")
            saveGameButton(result: .winner(winner: .player2, alignment: []), text: "Save p2 wins")
            saveGameButton(result: .even, text: "Save even")
            saveGameButton(result: .notFinished, text: "Save not finished")
        }
        SavedGames()
    }
}

private struct saveGameButton : View {
    var result: Result
    var text: String
    var body : some View {
        Button(action: {
            Task {
                let game = try Game(withBoard: BoardStub().getBoards()[0], withRules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, andPlayer1: HumanPlayer(withName: "p1", andId: .player1)!, andPlayer2: HumanPlayer(withName: "p2", andId: .player2)!)
                _ = try await Persistance.saveGameResult(withName: "GameResults.co4", andGame: game, andResult: result)
                
            }
        }) {
            Text(text)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(Color(.primaryAccentBackground))
        .foregroundColor(.primaryBackground)
        .cornerRadius(5)
    }
}
