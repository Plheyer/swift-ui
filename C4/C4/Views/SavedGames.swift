import SwiftUI

struct SavedGames: View {
    @StateObject public var inProgressGames : GamesVM = GamesStub().getGamesVM()[0]
    @StateObject public var finishedGames : GamesVM = GamesStub().getGamesVM()[1]
    var body: some View {
         ScrollView {
            Spacer()
            GameListComponent(gameListTitle: "\(String(localized: "inProgressGames"))...", games: inProgressGames)
            Spacer()
            GameListComponent(gameListTitle: String(localized: "finishedGames"), games: finishedGames)
            Spacer()
        }
        .navigationBarTitle(String(localized: "SavedGamesTitle"))
    }
}

#Preview {
    SavedGames()
}
