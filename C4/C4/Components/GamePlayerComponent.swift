//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import SwiftUI

struct GamePlayerComponent: View {
    var player : Player
    @Binding var isPlayerTurn : Bool
    var timer = "00:00:00"
    var color : Color
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image("HomeImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.circle)
                        .frame(width: 70)
                    HStack(alignment: .bottom) {
                        Spacer()
                        VStack {
                            Spacer()
                            Circle()
                                .fill(color)
                                .frame(width: 30, alignment: .bottomTrailing)
                                
                                .overlay(Circle().strokeBorder(.black, lineWidth: 1))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 70)
                        
                        
                }
                VStack(alignment: .leading) {
                    Text(player.name)
                    Text(player.type)
                        .font(.caption)
                }
                Spacer()
            }
            HStack {
                Text(timer)
                Spacer()
            }
            if isPlayerTurn {
                VStack {
                    Image(systemName: "triangle.fill")
                    Text(String(localized: "YourTurn"))
                }
            }
            Spacer()
        }
        .frame(maxWidth: 200)
    }
}

#Preview {
    GamePlayerComponentPreview()
}

private struct GamePlayerComponentPreview : View {
    @State var isPlayer1Turn = false
    @State var isPlayer2Turn = true
    var body : some View {
        VStack {
            HStack {
                GamePlayerComponent(player: HumanPlayer(withName: "Preview", andId: .player1)!, isPlayerTurn: $isPlayer1Turn, color: Color(red: 255, green: 0, blue: 0, opacity: 0.003))
                Spacer()
                GamePlayerComponent(player: HumanPlayer(withName: "Preview2", andId: .player2)!, isPlayerTurn: $isPlayer2Turn, color: Color(red: 255, green: 255, blue: 0, opacity: 0.003))
            }
            Button(action: {
                isPlayer1Turn.toggle()
                isPlayer2Turn.toggle()
            }) {
                Text("Change player turn")
            }
            Spacer()
        }
    }
}
