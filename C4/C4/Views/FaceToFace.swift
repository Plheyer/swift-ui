import SwiftUI
import Connect4Core
import Connect4Persistance
import Charts

struct FaceToFace: View {
    @State public var player1Name: String
    @State public var player2Name: String
    @StateObject public var players : PlayersVM
    @StateObject var results: GameResultsVM = GameResultsVM()
    @State private var debug: String = ""
    
    init() {
        let playersVM = PlayersVM()
        self._players = StateObject(wrappedValue: playersVM)
        let defaultPlayerName = playersVM.players.first?.model.name ?? "\(RandomPlayer.self)"
        self.player1Name = defaultPlayerName
        self.player2Name = defaultPlayerName
    }
    
    func loadFaceToFace() async {
        do {
            let p1 = players.players.first { $0.model.name == player1Name }
            let p2 = players.players.first { $0.model.name == player2Name }
            if let p1, let p2 {
                let res = try await Connect4Persistance.FaceToFace.getResults(in: "GameResults.co4", with: PlayerData(name: p1.model.name, id: .player1, type: p1.model.type), and: PlayerData(name: p2.model.name, id: .player2, type: p2.model.type))
                results.gameResults = res
                    .map {
                        GameResultVM(date: $0.date, players: $0.players, rules: $0.rules, winner: $0.winner)
                    }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
         ScrollView {
             Text(debug)
             HStack(spacing: 10) {
                 FaceToFacePlayerComponent(pickerCallback: self.loadFaceToFace, selectedPlayerName: $player1Name, playersVM: players).frame(maxWidth: .infinity, alignment: .leading)
                 FaceToFaceChartComponent(games: results, player1Name: player1Name).frame(maxWidth: .infinity, alignment: .center)
                 FaceToFacePlayerComponent(pickerCallback: self.loadFaceToFace, selectedPlayerName: $player2Name, playersVM: players).frame(maxWidth: .infinity, alignment: .trailing)
             }
             
             FaceToFaceListComponent(games: results)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
        .navigationBarTitle(String(localized: "SavedGamesTitle"))
        .task {
            await players.loadAllPlayersAndAIs()
            await loadFaceToFace()
        }
        .refreshable {
            await players.loadAllPlayersAndAIs()
            await loadFaceToFace()
        }
    }
}

#Preview {
    FaceToFacePreview()
}

private struct FaceToFacePreview : View {
    @State var selectedPlayer1: PlayerVM = PlayerVM(with: PlayerStub().getPlayersModel()[0])
    @State var selectedPlayer2: PlayerVM = PlayerVM(with: PlayerStub().getPlayersModel()[0])
    var states: [Owner] = [.noOne, .player1, .player2]
    @State var state: Owner = .player1
    var players: [PlayerVM] = PlayerStub().getPlayersModel().map { PlayerVM(with: $0) }
    @State var debug: String = ""
    var body : some View {
        VStack {
            Text(debug)
            HStack {
                Picker("Player", selection: $selectedPlayer1) {
                    ForEach(players, id: \.self) { player in
                        Text(player.model.name)
                    }
                }
                Picker("Player", selection: $selectedPlayer2) {
                    ForEach(players, id: \.self) { player in
                        Text(player.model.name)
                    }
                }
                Picker("State", selection: $state) {
                    ForEach(states, id: \.self) { state in
                        Text("\(state)")
                    }
                }
                Button(action: {
                    Task {
                        let player1 = HumanPlayer(withName: selectedPlayer1.model.name, andId: .player1)!
                        let player2 = HumanPlayer(withName: selectedPlayer2.model.name, andId: .player2)!
                        _ = try await Persistance.addPlayer(withName: "players22", andPlayer: player1)
                        _ = try await Persistance.addPlayer(withName: "players22", andPlayer: player2)
                        
                        let game = try Game(withBoard: BoardStub().getBoards()[0], withRules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, andPlayer1: player1, andPlayer2: player2)
                        _ = try await Persistance.saveGameResult(withName: "GameResults.co4", andGame: game, andResult: Result.winner(winner: state, alignment: []))
                    }
                }) {
                    Text("Save")
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color(.primaryAccentBackground))
                .foregroundColor(.primaryBackground)
                .cornerRadius(5)
            }
            FaceToFace()
        }
    }
}
