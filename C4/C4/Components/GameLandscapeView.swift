//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import SwiftUI

struct GameLandscapeView: View {
    @ObservedObject public var game: GameVM
    
    @State var isPaused : Bool = false
    
    @Binding var isPlayer1Turn : Bool
    @Binding var isPlayer2Turn : Bool
    
    @State private var errorShowing = false
    var body: some View {
        VStack {
            if let player1 = game.players[.player1], let player2 = game.players[.player2] {
                HStack {
                    Spacer()
                    
                    VStack {
                        GamePlayerComponent(player: player1, isPlayerTurn: $isPlayer1Turn, color: Color(red: 255, green: 0, blue: 0, opacity: 0.3))
                        VStack {
                            Button("", systemImage: isPaused ? "play.circle" : "pause.circle") {
                                isPaused.toggle()
                            }
                            .foregroundColor(.primaryAccentBackground)
                            .font(.largeTitle)
                            .padding(.top, 10)
                            
                            Text("\(String(localized: "Rules")) : \(game.rules.model?.shortName ?? "Unknown rules")")
                        }
                        GamePlayerComponent(player: player2, isPlayerTurn: $isPlayer2Turn, color: Color(red: 255, green: 255, blue: 0, opacity: 0.3))
                    }
                    
                    Spacer()
                    
                    GridBoardComponent(board: $game.board, player1ImagePath: game.players[.player1]?.model.imagePath ?? "", player2ImagePath: game.players[.player2]?.model.imagePath ?? "")
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                Text(String("Error"))
                    .onAppear() {
                        errorShowing = true
                    }
                    .alert("Players have not been set correctly", isPresented: $errorShowing) {
                        Button("OK", role: .destructive) { }
                    } message: {
                        Text("Try again later.")
                    }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
    }
}

#Preview {
    GameLandscapeViewPreview()
}

private struct GameLandscapeViewPreview: View {
    @StateObject public var game = GameVM(with: PlayerStub().getPlayersVM()[0], andWith: PlayerStub().getPlayersVM()[1], board: Board(withNbRows: 6, andNbColumns: 7)!)
    
    @State private var index = 0
    @State var isPlayer1Turn = false
    @State var isPlayer2Turn = true

    var body: some View {
        VStack {
            GameLandscapeView(game: game, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
            Button("New grid") {
                index = (index + 1) % 7
                game.board = BoardStub().getBoards()[index]
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(Color(.primaryAccentBackground))
            .foregroundColor(.primaryBackground)
            .cornerRadius(5)
            
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
