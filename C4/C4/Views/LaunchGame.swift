import SwiftUI
import Connect4Core
import Connect4Rules

struct LaunchGame: View {
    // Orientation
    @Binding public var orientation: UIDeviceOrientation?
    @Binding public var idiom: UIUserInterfaceIdiom?
    
    // Game
    // TODO: Change the stub
    private let defaultPlayer1 = PlayerStub().getPlayersVM()[0]
    private let defaultPlayer2 = PlayerStub().getPlayersVM()[1]
    
    @StateObject public var gameVM : GameVM = GameVM(with: PlayerStub().getPlayersVM()[0], andWith: PlayerStub().getPlayersVM()[1], board: Board(withNbRows: 6, andNbColumns: 7)!)
    
    @StateObject public var newPlayerVM : PlayerVM = PlayerVM(name: "", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)")
    
    public var players = PlayersVM(players: PlayerStub().getPlayersVM()) // Have to fetch all players from persistance
    
    // Timer
    @StateObject public var timerVM = TimerVM()
    
    var body: some View {
        ScrollView {
            HStack {
                ChoosePlayerComponent(playerVM: gameVM.players[.player1] ?? defaultPlayer1, newPlayerVM: newPlayerVM, playerText: String(localized: "Player1"))
                ChoosePlayerComponent(playerVM: gameVM.players[.player2] ?? defaultPlayer2, newPlayerVM: newPlayerVM, playerText: String(localized: "Player2"))
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
        }
        .padding()
        .background(Color(.primaryBackground))
        .navigationBarTitle(String(localized: "LaunchGameTitle"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $newPlayerVM.isEditing) {
            NavigationStack {
                AddPlayerComponent(playerVM: newPlayerVM)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            Task {
                                await newPlayerVM.onEdited(isCancelled: false)
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .foregroundColor(.primaryAccentBackground)
                        .cornerRadius(5)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            Task {
                                await newPlayerVM.onEdited(isCancelled: true)
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .foregroundColor(.secondaryBackground)
                        .cornerRadius(5)
                    }
                }
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
