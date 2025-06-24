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
    @ObservedObject public var timer: TimerVM
    public var gameVM: GameVM
    
    // Orientation
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    
    // Gameplay
    @State var isPaused : Bool = false
    
    let debug = false
    
    public init(gameVM: GameVM, timer: TimerVM, orientation: Binding<UIDeviceOrientation?>, idiom: Binding<UIUserInterfaceIdiom?>) {
        self.gameVM = gameVM
        self.timer = timer
        self._orientation = orientation
        self._idiom = idiom
    }
    
    var body: some View {
        VStack {
            if gameVM.isAR {
                if let scene = gameVM.arScene {
                    GameARViewRepresentable(gameARView: scene)
                        .ignoresSafeArea()
                }
            } else {
                switch(orientation, idiom) {
                    case (.portrait, .phone), (.portraitUpsideDown, .phone), (.portrait, .pad), (.portraitUpsideDown, .pad):
                    GamePortraitView(gameVM: gameVM, isPaused: $isPaused)
                    case (.landscapeLeft, .phone), (.landscapeRight, .phone):
                    GameLandscapeView(gameVM: gameVM, isPaused: $isPaused)
                    default:
                    GameLandscapeView(gameVM: gameVM, isPaused: $isPaused)
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
    @StateObject public var gameVM = try! GameVM(with: PlayerVM(with: PlayerStub().getPlayersModel()[0]), andWith: PlayerVM(with: PlayerStub().getPlayersModel()[1]), rules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, board: BoardStub().getBoards()[4], isAR: false)
    @StateObject public var timerVM = TimerVM()
    
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    @State var isPlayer1Turn: Bool = true
    @State var isPlayer2Turn: Bool = false
    var body: some View {
        GameView(gameVM: gameVM, timer: timerVM, orientation: $orientation, idiom: $idiom)
    }
}
