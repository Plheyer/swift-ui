import SwiftUI
import Connect4Core

struct GameListComponent: View {
    var gameListTitle : String
    @ObservedObject var games : GamesVM
    var formatter : DateFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            Text(gameListTitle).padding(.bottom, 5)
            HStack {
                Text(String(localized: "Date"))
                Spacer()
                Text(String(localized: "Players"))
                Spacer()
                Text(String(localized: "Rules"))
            }
            ForEach (games.games) { g in
                HStack {
                    Text(g.dateFormatted)
                    Spacer()
                    Text(g.players.map { $0.name }.joined(separator: ","))
                    Spacer()
                    Text(g.rules.name)
                }
            }
        }
        .padding()
    }
}
