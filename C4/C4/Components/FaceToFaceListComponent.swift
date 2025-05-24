import SwiftUI
import Connect4Core
import Charts

struct FaceToFaceListComponent: View {
    @ObservedObject var games : GamesVM
    var body: some View {
        VStack {
            HStack {
                Text(String(localized: "Date")).frame(maxWidth: .infinity, alignment: .leading)
                Text(String(localized: "Winner")).frame(maxWidth: .infinity, alignment: .center)
                Text(String(localized: "Rules")).frame(maxWidth: .infinity, alignment: .trailing)
            }
            Divider()
            ForEach (games.games) { g in
                HStack {
                    // Text(g.dateFormatted).frame(maxWidth: .infinity, alignment: .leading)
                    Text(g.getWinnerPlayer()?.name ?? "Draw").frame(maxWidth: .infinity, alignment: .center)
                    Text(g.rules.shortName).frame(maxWidth: .infinity, alignment: .trailing)
                }
                Divider()
            }
        }
        .padding()
    }
}
