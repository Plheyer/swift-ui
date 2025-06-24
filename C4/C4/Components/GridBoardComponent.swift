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
    @StateObject public var gameVM: GameVM
    
    var body: some View {
        VStack {
            if let scene = gameVM.gameScene {
                GeometryReader { geometry in
                    let s = findSize(geometry.size, scene.size)
                    SpriteView(scene: scene, options: [.allowsTransparency])
                        .frame(width: s.width, height: s.height, alignment: .center)
                        .scaledToFit()
                        .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)) // This position enables the scene to be centered in the geometry reader
                }
                .frame(alignment: .center)
            } else {
                Text(String(localized: "ErrorLoadingGameScene"))
            }
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

@MainActor
private struct GridBoardComponentPreview : View {
    var gameVM: GameVM = try! GameVM(with: PlayerVM(with: PlayerStub().getPlayersModel()[0]), andWith: PlayerVM(with: PlayerStub().getPlayersModel()[1]), rules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, board: BoardStub().getBoards()[0], isAR: false)
    var body : some View {
        GridBoardComponent(gameVM: gameVM)
    }
}
