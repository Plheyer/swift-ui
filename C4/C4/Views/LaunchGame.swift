import SwiftUI
import Connect4Core
import Connect4Rules

struct LaunchGame: View {
    // Orientation
    @Binding public var orientation: UIDeviceOrientation?
    @Binding public var idiom: UIUserInterfaceIdiom?
    
    // Game
    @StateObject public var newGameVM : NewGameVM = NewGameVM(with: PlayerVM(with: PlayerModel(name: "\(RandomPlayer.self)", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(RandomPlayer.self)")), andWith: PlayerVM(with: PlayerModel(name: "\(RandomPlayer.self)", owner: .player2, image: Image("DefaultPlayerImage"), type: "\(RandomPlayer.self)")), rulesName: "\(Connect4Rules.self)", nbRows: 6, nbColumns: 7, nbTokensToAlign: 4)
    
    @State public var players = PlayersVM()
    @State public var isPlayer1Turn = false
    @State public var isPlayer2Turn = false
    @State public var showErrorAlert = false
    @State public var isFormValid = false
    
    // Timer
    @StateObject public var timerVM = TimerVM()
    
    var body: some View {
        ScrollView {
            HStack {
                ChoosePlayerComponent(playerVM: newGameVM.player1, playersVM: players, playerText: String(localized: "Player1"))
                ChoosePlayerComponent(playerVM: newGameVM.player2, playersVM: players, playerText: String(localized: "Player2"))
            }
            Divider()
            ChooseRulesComponent(rulesName: $newGameVM.rulesName, nbRows: $newGameVM.nbRows, nbColumns: $newGameVM.nbColumns, nbTokensToAlign: $newGameVM.nbTokensToAlign, timer: timerVM)
            
            VStack {
                Button(String(localized: "Play")) {
                    Task {
                        showErrorAlert = !newGameVM.createGame()
                        if !showErrorAlert {
                            isFormValid = true
                            await newGameVM.player1.onSelected(isCancelled: false)
                            await newGameVM.player2.onSelected(isCancelled: false)
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
            }
            .navigationDestination(isPresented: $isFormValid) {
                GameView(gameVM: newGameVM.gameVM, timer: timerVM, orientation: $orientation, idiom: $idiom, isPlayer1Turn: isPlayer1Turn, isPlayer2Turn: isPlayer2Turn)
            }
            .background(Color(.primaryAccentBackground))
            .foregroundColor(.primaryBackground)
            .cornerRadius(5)
        }
        .padding()
        .background(Color(.primaryBackground))
        .navigationBarTitle(String(localized: "LaunchGameTitle"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            Task {
                await players.loadAllPlayers()
                newGameVM.player1.onSelecting()
                newGameVM.player2.onSelecting()
            }
        }
        .alert("LaunchGameErrorTitle", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(String(localized: "LaunchGameErrorDescription"))
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
