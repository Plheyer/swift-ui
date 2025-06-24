//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import Connect4Rules
import SwiftUI

struct GameLandscapeView: View {
    @StateObject public var gameVM: GameVM
    @State public var isRunning = true
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack {
                    GamePlayerComponent(player: gameVM.player1, isPlayerTurn: gameVM.isPlayer1Turn, color: Color(red: 255, green: 0, blue: 0, opacity: 0.3), timerVM: gameVM.timerVM)
                    VStack {
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
                    GamePlayerComponent(player: gameVM.player2, isPlayerTurn: gameVM.isPlayer2Turn, color: Color(red: 255, green: 255, blue: 0, opacity: 0.3), timerVM: gameVM.timerVM)
                }
                
                Spacer()
                
                GridBoardComponent(gameVM: gameVM)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
    }
}

#Preview {
    GameLandscapeViewPreview()
}

@MainActor
private struct GameLandscapeViewPreview: View {
    public var game = try! GameVM(with: PlayerVM(with: PlayerStub().getPlayersModel()[0]), andWith: PlayerVM(with: PlayerStub().getPlayersModel()[1]), rules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, board: BoardStub().getBoards()[0], isAR: false, timerVM: TimerVM(time: 0, gameVM: nil))
    
    @State private var index = 0
    @State var isPlayer1Turn = false
    @State var isPlayer2Turn = true

    var body: some View {
        VStack {
            GameLandscapeView(gameVM: game)
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
