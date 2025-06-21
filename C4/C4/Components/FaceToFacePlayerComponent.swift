import SwiftUI
import Connect4Core
import Charts

struct FaceToFacePlayerComponent: View {
    var pickerCallback : () async -> ()
    @Binding public var selectedPlayerName : String
    @ObservedObject public var playersVM : PlayersVM
    var body: some View {
        VStack {
            Image("HomeImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Picker("Player", selection: $selectedPlayerName) {
                ForEach(playersVM.players.map { $0.model.name }, id: \.self) { name in
                    Text(name)
                }
            }
            .onChange(of: selectedPlayerName) {
                Task {
                    await self.pickerCallback()
                }
            }
            .tint(.primaryAccentBackground)
        }
    }
}
