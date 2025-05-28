import SwiftUI
import Connect4Core
import Charts

struct FaceToFaceListComponent: View {
    @ObservedObject var games : GameResultsVM
    var body: some View {
        VStack {
            HStack {
                Text(String(localized: "Date")).frame(maxWidth: .infinity, alignment: .leading)
                Text(String(localized: "Winner")).frame(maxWidth: .infinity, alignment: .center)
                Text(String(localized: "Rules")).frame(maxWidth: .infinity, alignment: .trailing)
            }
            Divider()
            ForEach (games.gameResults) { g in
                HStack {
                    Text(DateFormatter().defaultFormat(date: g.date))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(g.players.first { $0.id == g.winner }?.name ?? "Draw")
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(g.rules.shortName)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Divider()
            }
        }
        .padding()
    }
}
