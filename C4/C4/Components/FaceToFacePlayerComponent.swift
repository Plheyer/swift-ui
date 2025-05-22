import SwiftUI
import Connect4Core
import Charts

struct FaceToFacePlayerComponent: View {
    @Binding public var selectedPlayer : PlayerVM
    @Binding public var players : [PlayerVM]
    var body: some View {
        VStack {
            Image("HomeImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Picker("Player", selection: $selectedPlayer) {
                ForEach(players, id: \.self) { player in
                    Text(player.name)
                }
            }
            .tint(.primaryAccentBackground)
        }
    }
}
