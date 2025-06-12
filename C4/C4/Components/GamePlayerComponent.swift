//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import SwiftUI

struct GamePlayerComponent: View {
    public var player : PlayerVM
    @Binding var isPlayerTurn : Bool
    var timer = "00:00:00"
    var color : Color
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    player.model.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.circle)
                        .frame(width: 70, height: 70)
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
                    Text(player.model.name)
                    Text(player.model.type)
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
    @State var player1VM = PlayerVM(with: PlayerModel(name: "player1", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)", imagePath: "/Users/etudiant/Downloads/anonymous.png"))
    @State var player2VM = PlayerVM(with: PlayerModel(name: "player2", owner: .player2, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)", imagePath: "/Users/etudiant/Downloads/larry.webp"))
    var body : some View {
        VStack {
            HStack {
                GamePlayerComponent(player: player1VM, isPlayerTurn: $isPlayer1Turn, color: Color(red: 255, green: 0, blue: 0, opacity: 0.3))
                Spacer()
                GamePlayerComponent(player: player2VM, isPlayerTurn: $isPlayer2Turn, color: Color(red: 255, green: 255, blue: 0, opacity: 0.3))
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
