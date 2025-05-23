import SwiftUI

struct ChoosePlayerComponent: View {
    @Binding var playerName: String
    @Binding var selectedPlayer: String
    public var playerText: String
    var ais = ["Negamax", "MinMax", "Finish him", "Human"]
    
    var body: some View {
        VStack {
            Text(playerText)
            Picker("Player type", selection: $selectedPlayer) {
                ForEach(ais, id: \.self) { ai in
                    Text(ai)
                }
            }
            .tint(.primaryAccentBackground)
            if (selectedPlayer == "Human") {
                TextField(String(localized: "ChoosePlayerNamePlaceholer"), text: $playerName)
            } else {
                Text(selectedPlayer)
            }
            Image("HomeImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 200)
            if (selectedPlayer == "Human") {
                Button("Modify", systemImage: "photo.artframe", action: {})
            }
        }
        .padding()
    }
}
