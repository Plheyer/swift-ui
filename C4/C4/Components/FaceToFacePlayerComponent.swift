import SwiftUI
import Connect4Core
import Charts

struct FaceToFacePlayerComponent: View {
    var pickerCallback : () async -> ()
    @Binding public var selectedPlayer : String
    @ObservedObject public var playersVM : PlayersVM
    var body: some View {
        VStack {
            Image("HomeImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Picker("Player", selection: $selectedPlayer) {
                ForEach(playersVM.players.map { $0.name }, id: \.self) { name in
                    Text(name)
                }
            }
            .onChange(of: selectedPlayer) {
                Task {
                    await self.pickerCallback()
                }
            }
            .tint(.primaryAccentBackground)
        }
    }
}
