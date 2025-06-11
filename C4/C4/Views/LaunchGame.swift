import SwiftUI
import Connect4Core
import Connect4Rules

struct LaunchGame: View {
    // Orientation
    @Binding public var orientation: UIDeviceOrientation?
    @Binding public var idiom: UIUserInterfaceIdiom?
    
    // Game
    private let defaultPlayer1: PlayerVM = PlayerVM(with: PlayerModel(name: "\(RandomPlayer.self)", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(RandomPlayer.self)"))
    private let defaultPlayer2: PlayerVM = PlayerVM(with: PlayerModel(name: "\(RandomPlayer.self)", owner: .player2, image: Image("DefaultPlayerImage"), type: "\(RandomPlayer.self)"))
    
    @StateObject public var gameVM : GameVM = GameVM(with: PlayerVM(with: PlayerModel(name: "\(RandomPlayer.self)", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(RandomPlayer.self)")), andWith: PlayerVM(with: PlayerModel(name: "\(RandomPlayer.self)", owner: .player2, image: Image("DefaultPlayerImage"), type: "\(RandomPlayer.self)")), board: Board(withNbRows: 6, andNbColumns: 7)!)
    
    @State public var players = PlayersVM() // Have to fetch all players from persistance
    
    // Timer
    @StateObject public var timerVM = TimerVM()
    
    var body: some View {
        ScrollView {
            HStack {
                ChoosePlayerComponent(playerVM: gameVM.players[.player1] ?? defaultPlayer1, playersVM: players, playerText: String(localized: "Player1"))
                ChoosePlayerComponent(playerVM: gameVM.players[.player2] ?? defaultPlayer2, playersVM: players, playerText: String(localized: "Player2"))
            }
            Divider()
            ChooseRulesComponent(rule: gameVM.rules, timer: timerVM)

            NavigationLink(destination: GameView(game: gameVM, timer: timerVM, orientation: $orientation, idiom: $idiom)) {
                Text(String(localized: "Play"))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
            }
            .background(Color(.primaryAccentBackground))
            .foregroundColor(.primaryBackground)
            .cornerRadius(5)
            .onTapGesture {
                let p1 = gameVM.players[.player1] ?? defaultPlayer1
                let p2 = gameVM.players[.player2] ?? defaultPlayer2
                Task {
                    await p1.onSelected(isCancelled: false)
                    await p2.onSelected(isCancelled: false)
                }
            }
        }
        .padding()
        .background(Color(.primaryBackground))
        .navigationBarTitle(String(localized: "LaunchGameTitle"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            Task {
                await players.loadAllPlayers()
                let p1 = gameVM.players[.player1] ?? defaultPlayer1
                let p2 = gameVM.players[.player2] ?? defaultPlayer2
                p1.onSelecting()
                p2.onSelecting()
            }
        }
    }
}

#Preview("Phone/Portait") {
    LaunchGamePreview(orientation: .portrait, idiom: .phone)
}

#Preview("Phone/Landscape") {
    LaunchGamePreview(orientation: .landscapeLeft, idiom: .phone)
}

#Preview("Pad") {
    LaunchGamePreview(orientation: .portrait, idiom: .pad)
}

private struct LaunchGamePreview : View {
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    var body: some View {
        LaunchGame(orientation: $orientation, idiom: $idiom)
    }
}
