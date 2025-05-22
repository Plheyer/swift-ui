//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import SwiftUI

struct GameView: View {
    @Binding var board : Board
    @Binding var rules : Rules
    @State var isPaused : Bool = false
    var body: some View {
        ScrollView {
            GridBoardComponent(board: $board)
            Button("", systemImage: isPaused ? "play.circle" : "pause.circle") {
                isPaused.toggle()
            }
            .foregroundColor(.primaryAccentBackground)
            .font(.largeTitle)
            .padding(.top, 10)
            
            Text("\(String(localized: "Rules")) : \(rules.name)")
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var index = 0
    @State private var board = BoardStub().getBoards()[0]
    @State private var rules : Rules = Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!

    var body: some View {
        VStack {
            GameView(board: $board, rules: $rules)
            Button("New grid") {
                index = (index + 1) % 7
                board = BoardStub().getBoards()[index]
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(Color(.primaryAccentBackground))
            .foregroundColor(.primaryBackground)
            .cornerRadius(5)
        }
    }
}
