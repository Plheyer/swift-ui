import SwiftUI

struct LaunchGame: View {
    @State var player1Name: String = ""
    @State var player2Name: String = ""
    var ais = ["Negamax", "MinMax", "Finish him", "Human"]
    var rules = ["Classic", "Push", "TicTacToe"]
    @State private var selectedPlayer1: String = "Negamax"
    @State private var selectedPlayer2: String = "Negamax"
    @State private var selectedRule: String = "Classic"
    @State var nbRows = 6
    @State var nbColumns = 7
    @State var tokenToAlign = 4
    let range = 4...20
    @State var isLimitedTime = false
    @State var minutesString = "2"
    @State var secondsString = "0"
    
    var body: some View {
        ScrollView {
            HStack {
                ChoosePlayerComponent(playerName: $player1Name, selectedPlayer: $selectedPlayer1, playerText: String(localized: "Player1"))
                ChoosePlayerComponent(playerName: $player2Name, selectedPlayer: $selectedPlayer2, playerText: String(localized: "Player2"))
            }
            Divider()
            ChooseRulesComponent(selectedRule: $selectedRule, nbRows: $nbRows, nbColumns: $nbColumns, tokenToAlign: $tokenToAlign, isLimitedTime: $isLimitedTime, minutesString: $minutesString, secondsString: $secondsString)
            Button(action: {}) {
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
        .frame(height: .infinity)
    }
}

#Preview {
    LaunchGame()
}
