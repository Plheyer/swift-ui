//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import SwiftUI
import SpriteKit

struct GridBoardComponent: View {
    @Binding var board : Board
    @State var scene: GameScene
    
    public init(board: Binding<Board>) {
        self._board = board
        scene = GameScene(nbRows: board.wrappedValue.nbRows, nbColumns: board.wrappedValue.nbColumns)
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let s = findSize(geometry.size, scene.size)
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .frame(width: s.width, height: s.height, alignment: .center)
                    .scaledToFit()
                    .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)) // This position enables the scene to be centered in the geometry reader
            }
            .frame(alignment: .center)
        }
        .ignoresSafeArea()
    }
    
    func findSize(_ containerSize: CGSize, _ sceneSize : CGSize) -> CGSize {
        let containerRatio = containerSize.width / containerSize.height
        let sceneRatio = sceneSize.width / sceneSize.height
        if sceneRatio >= containerRatio {
            return CGSize(width: containerSize.width, height: containerSize.width / sceneRatio)
        } else {
            return CGSize(width: containerSize.height * sceneRatio, height: containerSize.height)
        }
    }
}

#Preview {
    GridBoardComponentPreview()
}

private struct GridBoardComponentPreview : View {
    @State var board = BoardStub().getBoards()[5]
    var body : some View {
        GridBoardComponent(board: $board)
    }
}
