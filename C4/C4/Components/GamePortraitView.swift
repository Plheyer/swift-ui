import Connect4Core
import Connect4Rules
import SwiftUI

struct GamePortraitView: View {
    @StateObject public var gameVM: GameVM
    @State public var isRunning = true
    
    var body: some View {
        VStack {
            HStack {
                GamePlayerComponent(player: gameVM.player1, isPlayerTurn: gameVM.isPlayer1Turn, color: Color(red: 255, green: 0, blue: 0, opacity: 0.3), timerVM: gameVM.timerVM)
                Spacer()
                GamePlayerComponent(player: gameVM.player2, isPlayerTurn: gameVM.isPlayer2Turn, color: Color(red: 255, green: 255, blue: 0, opacity: 0.3), timerVM: gameVM.timerVM)
            }
                
            GridBoardComponent(gameVM: gameVM)
            Button("", systemImage: isRunning ? "pause.circle" : "play.circle") {
                isRunning.toggle()
                if gameVM.timerVM.isRunning {
                    gameVM.timerVM.pause()
                } else {
                    gameVM.timerVM.play()
                }
            }
            .foregroundColor(.primaryAccentBackground)
            .font(.largeTitle)
            .padding(.top, 10)
                
            Text("\(String(localized: "Rules")) : \(gameVM.rules.name)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
    }
}

#Preview {
    GamePortraitViewPreview()
}

@MainActor
private struct GamePortraitViewPreview: View {
    public var gameVM = try! GameVM(with: PlayerVM(with: PlayerStub().getPlayersModel()[0]), andWith: PlayerVM(with: PlayerStub().getPlayersModel()[1]), rules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, board: BoardStub().getBoards()[0], isAR: false, timerVM: TimerVM(time: 0, gameVM: nil))
    
    @State private var index = 0
    @State var isPlayer1Turn = false
    @State var isPlayer2Turn = true
    @State var isPaused = false

    var body: some View {
        VStack {
            GamePortraitView(gameVM: gameVM)
            Button(action: {
                isPlayer1Turn.toggle()
                isPlayer2Turn.toggle()
            }) {
                Text("Change player turn")
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(Color(.primaryAccentBackground))
            .foregroundColor(.primaryBackground)
            .cornerRadius(5)
        }
        .background(Color(.primaryBackground))
    }
}
