import SwiftUI
import Connect4Core

struct LaunchGame: View {
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    @State var isPresented = false
    
    @State var player1Name: String = ""
    @State var player2Name: String = ""
    var ais = ["Negamax", "MinMax", "Finish him", "Human"]
    var rules = ["Classic", "Push", "TicTacToe"]
    @State var selectedPlayerType1: String = String("Human")
    @State var selectedPlayerType2: String = String("Random")
    @State var selectedPlayer1: PlayerVM = PlayerVM(name: "Player 1")
    @State var selectedPlayer2: PlayerVM = PlayerVM(name: "Player 2")
    @State private var selectedRule: String = "Classic"
    @State var nbRows = 6
    @State var nbColumns = 7
    @State var tokenToAlign = 4
    let range = 4...20
    @State var isLimitedTime = false
    @State var minutesString = "2"
    @State var secondsString = "0"
    @State var isPlayer1Turn = true
    @State var isPlayer2Turn = false
    
    @State var board = BoardStub().getBoards()[0]
    @State var rule : Rules = Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!
    
    var body: some View {
        ScrollView {
            HStack {
                ChoosePlayerComponent(selectedPlayerType: $selectedPlayerType1, selectedPlayer: $selectedPlayer1, isPresented: $isPresented, playerText: String(localized: "Player1"))
                ChoosePlayerComponent(selectedPlayerType: $selectedPlayerType2, selectedPlayer: $selectedPlayer2, isPresented: $isPresented, playerText: String(localized: "Player2"))
            }
            Divider()
            ChooseRulesComponent(selectedRule: $selectedRule, nbRows: $nbRows, nbColumns: $nbColumns, tokenToAlign: $tokenToAlign, isLimitedTime: $isLimitedTime, minutesString: $minutesString, secondsString: $secondsString)

            NavigationLink(destination: GameView(board: $board, rules: $rule, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn, orientation: $orientation, idiom: $idiom)) {
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
        .sheet(isPresented: $isPresented) {
            AddPlayerComponent(isPresented: $isPresented)
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
        LaunchGamePreview(orientation: orientation, idiom: idiom)
    }
}
