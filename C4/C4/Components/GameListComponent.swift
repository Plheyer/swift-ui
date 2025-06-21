import SwiftUI
import Connect4Core
import Connect4Persistance

struct GameListComponent: View {
    var gameListTitle : String
    @ObservedObject var games : GameResultsVM
    
    var body: some View {
        LazyVStack {
            Text(gameListTitle).padding(.bottom, 5)
            
            HStack {
                Text(String(localized: "Date"))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(localized: "Players"))
                .frame(maxWidth: .infinity, alignment: .center)
                
                Text(String(localized: "Rules"))
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Divider()
            
            ForEach (games.gameResults, id: \.self) { g in
                HStack {
                    Text(DateFormatter().defaultFormat(date: g.date))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    switch (g.winner) {
                        case .noOne:
                            Text(g.players.map { $0.name }.joined(separator: " vs. "))
                            .frame(maxWidth: .infinity, alignment: .center)
                        case .player1:
                            Text(g.players.map { $0.name }.joined(separator: " \(String(localized: "beat")) "))
                            .frame(maxWidth: .infinity, alignment: .center)
                        case .player2:
                            Text(g.players.reversed().map { $0.name }.joined(separator: " \(String(localized: "beat")) "))
                            .frame(maxWidth: .infinity, alignment: .center)
                        default:
                            Text(g.players.map { $0.name }.joined(separator: ","))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Text(g.rules.shortName)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Divider()
            }
        }
        .padding()
    }
}

#Preview {
    GameListComponentPreview()
}

private struct GameListComponentPreview : View {
    @State var gameResultsVM : GameResultsVM = GameResultsVM(gameResults: [])
    var body : some View {
        GameListComponent(gameListTitle: "Preview", games: gameResultsVM)
            .task {
                do {
                    let results: [GameResult] = try await Persistance.loadGameResults(withName: "GameResults.co4") ?? []
                    gameResultsVM = GameResultsVM(gameResults: results.map {
                            GameResultVM(date: $0.date, players: $0.players, rules: $0.rules, winner: $0.winner)
                    })
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}
