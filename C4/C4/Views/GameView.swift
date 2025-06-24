//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import Connect4Rules
import SwiftUI

struct GameView: View {
    @StateObject public var gameVM: GameVM
    
    // Orientation
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    
    let debug = false
    
    var body: some View {
        VStack {
            if gameVM.isAR {
                if let scene = gameVM.arScene {
                    GameARViewRepresentable(gameARView: scene)
                        .ignoresSafeArea()
                }
            } else {
                switch(orientation, idiom) {
                    case (.portrait, .phone), (.portraitUpsideDown, .phone), (.portrait, .pad), (.portraitUpsideDown, .pad),
                        (.unknown, .phone), (.unknown, .pad):
                    GamePortraitView(gameVM: gameVM)
                    case (.landscapeLeft, .phone), (.landscapeRight, .phone):
                    GameLandscapeView(gameVM: gameVM)
                    default:
                    GameLandscapeView(gameVM: gameVM)
                }
            }
        }
        .task {
            await gameVM.startGame()
        }
    }
}


#Preview("Phone/Portait") {
    GameViewPreview(orientation: .portrait, idiom: .phone)
}

#Preview("Phone/Landscape") {
    GameViewPreview(orientation: .landscapeLeft, idiom: .phone)
}

#Preview("Pad") {
    GameViewPreview(orientation: .portrait, idiom: .pad)
}

private struct GameViewPreview : View {
    @StateObject public var gameVM = try! GameVM(with: PlayerVM(with: PlayerStub().getPlayersModel()[0]), andWith: PlayerVM(with: PlayerStub().getPlayersModel()[1]), rules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, board: BoardStub().getBoards()[4], isAR: false, timerVM: TimerVM(time: 0, gameVM: nil))
    @StateObject public var timerVM = TimerVM(time: 0, gameVM: nil)
    
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    @State var isPlayer1Turn: Bool = true
    @State var isPlayer2Turn: Bool = false
    var body: some View {
        GameView(gameVM: gameVM, orientation: $orientation, idiom: $idiom)
    }
}
