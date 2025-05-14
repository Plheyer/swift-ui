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
        VStack {
            HStack {
                VStack {
                    Text(String(localized: "Player1"))
                    Picker("Player type", selection: $selectedPlayer1) {
                        ForEach(ais, id: \.self) { ai in
                            Text(ai)
                        }
                    }
                    if (selectedPlayer1 == "Human") {
                        TextField(String(localized: "Player1Placeholder"), text: $player1Name)
                    } else {
                        Text(selectedPlayer1)
                    }
                    Image("HomeImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    if (selectedPlayer1 == "Human") {
                        Button("Modify", systemImage: "photo.artframe", action: {})
                    }
                    Spacer()
                }
                VStack {
                    Text(String(localized: "Player2"))
                    Picker("IA", selection: $selectedPlayer2) {
                        ForEach(ais, id: \.self) { ai in
                            Text(ai)
                        }
                    }
                    if (selectedPlayer2 == "Human") {
                        TextField(String(localized: "Player2Placeholder"), text: $player2Name)
                    } else {
                        Text(selectedPlayer2)
                    }
                    Image("HomeImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    if (selectedPlayer2 == "Human") {
                        Button("Modify", systemImage: "photo.artframe", action: {})
                    }
                    Spacer()
                }
            }
            Spacer()
            Divider()
            Spacer()
            VStack {
                HStack {
                    Text(String(localized: "Rules"))
                    Picker("Rules", selection: $selectedRule) {
                        ForEach(rules, id: \.self) { rule in
                            Text(rule)
                        }
                    }
                }
                HStack {
                    VStack {
                        Text(String(localized: "Dimensions"))
                        Spacer()
                    }
                    VStack {
                        Stepper(value: $nbRows, in: range, step: 1){
                            Text("\(String(localized: "Rows")) \(nbRows)")
                        }
                        Stepper(value: $nbColumns, in: range, step: 1){
                            Text("\(String(localized: "Columns")) \(nbColumns)")
                        }
                        Stepper(value: $tokenToAlign, in: range, step: 1){
                            Text("\(String(localized: "TokensToAlign")) \(tokenToAlign)")
                        }
                    }
                }
                HStack {
                    Text(String(localized: "LimitedTime"))
                    Toggle("", isOn: $isLimitedTime).toggleStyle(.switch)
                    if (isLimitedTime) {
                        TextField("", text: $minutesString).textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                        Text(String(localized: "min"))
                        TextField("", text: $secondsString).textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                        Text(String(localized: "sec"))
                    }
                }
            }
            Button(action: {}) {
                Text(String(localized: "Play"))
            }.buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LaunchGame()
}
