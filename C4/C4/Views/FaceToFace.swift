import SwiftUI
import Connect4Core
import Connect4Persistance
import Charts

struct FaceToFace: View {
    @State public var player1Name : String = PlayerStub().getPlayersVM()[0].name
    @State public var player2Name : String = PlayerStub().getPlayersVM()[1].name
    @StateObject public var players : PlayersVM = PlayersVM(players: PlayerStub().getPlayersVM())
    @StateObject var results: GameResultsVM = GameResultsVM()
    @State private var debug: String = ""
    
    func loadFaceToFace() async {
        do {
            let res = try await Connect4Persistance.FaceToFace.getResults(in: "GameResults", with: PlayerData(name: player1Name, id: .player1, type: "HumanPlayer"), and: PlayerData(name: player2Name, id: .player2, type: "HumanPlayer"))
            results.gameResults = res
                .map {
                    GameResultVM(date: $0.date, players: $0.players, rules: $0.rules, winner: $0.winner)
                }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
         ScrollView {
             Text(debug)
             HStack(spacing: 10) {
                 FaceToFacePlayerComponent(pickerCallback: self.loadFaceToFace, selectedPlayer: $player1Name, playersVM: players).frame(maxWidth: .infinity, alignment: .leading)
                 FaceToFaceChartComponent(games: results, player1Name: player1Name).frame(maxWidth: .infinity, alignment: .center)
                 FaceToFacePlayerComponent(pickerCallback: self.loadFaceToFace, selectedPlayer: $player2Name, playersVM: players).frame(maxWidth: .infinity, alignment: .trailing)
             }
             
             FaceToFaceListComponent(games: results)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
        .navigationBarTitle(String(localized: "SavedGamesTitle"))
        .task {
            await loadFaceToFace()
        }
        .refreshable {
            await loadFaceToFace()
        }
    }
}

#Preview {
    FaceToFacePreview()
}

private struct FaceToFacePreview : View {
    @State var selectedPlayer1: PlayerVM = PlayerStub().getPlayersVM()[0]
    @State var selectedPlayer2: PlayerVM = PlayerStub().getPlayersVM()[0]
    var states: [Owner] = [.noOne, .player1, .player2]
    @State var state: Owner = .player1
    var players: [PlayerVM] = PlayerStub().getPlayersVM()
    @State var debug: String = ""
    var body : some View {
        VStack {
            Text(debug)
            HStack {
                Picker("Player", selection: $selectedPlayer1) {
                    ForEach(players, id: \.self) { player in
                        Text(player.name)
                    }
                }
                Picker("Player", selection: $selectedPlayer2) {
                    ForEach(players, id: \.self) { player in
                        Text(player.name)
                    }
                }
                Picker("State", selection: $state) {
                    ForEach(states, id: \.self) { state in
                        Text("\(state)")
                    }
                }
                Button(action: {
                    Task {
                        let player1 = HumanPlayer(withName: selectedPlayer1.name, andId: .player1)!
                        let player2 = HumanPlayer(withName: selectedPlayer2.name, andId: .player2)!
                        _ = try await Persistance.addPlayer(withName: "players", andPlayer: player1)
                        _ = try await Persistance.addPlayer(withName: "players", andPlayer: player2)
                        
                        let game = try Game(withBoard: BoardStub().getBoards()[0], withRules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, andPlayer1: player1, andPlayer2: player2)
                        _ = try await Persistance.saveGameResult(withName: "GameResults", andGame: game, andResult: Result.winner(winner: state, alignment: []))
                        
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
