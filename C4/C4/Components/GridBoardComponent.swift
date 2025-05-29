//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import SwiftUI

struct GridBoardComponent: View {
    @Binding var board : Board
    var body: some View {
        Grid {
            ForEach (board.grid.indices, id: \.self) { rowIndex in
                GridRow {
                    ForEach (board.grid[rowIndex].indices, id: \.self) { pieceIndex in
                        let color = switch (board.grid[rowIndex][pieceIndex]?.owner) {
                            case .player1:
                                Color.red
                            case .player2:
                                Color.yellow
                            default:
                                Color.white
                        }
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
        .padding(6)
        .background(Color(.blue))
    }
}

#Preview {
    GridBoardComponentPreview()
}

private struct GridBoardComponentPreview : View {
    @State var board = BoardStub().getBoards()[1]
    var body : some View {
        GridBoardComponent(board: $board)
    }
}
