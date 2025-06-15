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
    public let gameVM: GameVM
    
    // Orientation
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    
    // Gameplay
    @State var isPaused : Bool = false
    @State var isPlayer1Turn = true
    @State var isPlayer2Turn = false
    
    let debug = false
    
    public init(gameVM: GameVM, timer: TimerVM, orientation: Binding<UIDeviceOrientation?>, idiom: Binding<UIUserInterfaceIdiom?>, isPlayer1Turn: Bool, isPlayer2Turn: Bool) {
        self.gameVM = gameVM
        self.isPlayer1Turn = isPlayer1Turn
        self.isPlayer2Turn = isPlayer2Turn
        self.timer = timer
        self._orientation = orientation
        self._idiom = idiom
    }
    
    var body: some View {
        if debug { // To see if the parameters are passed correctly from the LaunchGame
            Text("nb Rows \(gameVM.rules.nbRows)")
            Text("nb Columns \(gameVM.rules.nbColumns)")
            Text("tokens to align \(gameVM.rules.nbPiecesToAlign)")
            Text("type rules \(gameVM.rules.name)")
            Text("p1 name \(gameVM.player1.model.name)")
            Text("p1 type \(gameVM.player1.model.type)")
            Text("p2 name \(gameVM.player2.model.name)")
            Text("p2 type \(gameVM.player2.model.type)")
            Text("p1 image")
            gameVM.player1.model.image
                .resizable()
                .frame(width: 100, height: 100)
            Text("p2 image")
            gameVM.player2.model.image
                .resizable()
                .frame(width: 100, height: 100)
            Text("timer limited? \(timer.isLimitedTime)")
            Text("timer minutes \(timer.minutesString)")
            Text("timer seconds \(timer.secondsString)")
        }
        
        VStack {
            switch(orientation, idiom) {
                case (.portrait, .phone), (.portraitUpsideDown, .phone), (.portrait, .pad), (.portraitUpsideDown, .pad):
                GamePortraitView(gameVM: gameVM, board: gameVM.board, rules: gameVM.rules, isPaused: $isPaused, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
                case (.landscapeLeft, .phone), (.landscapeRight, .phone):
                GameLandscapeView(gameVM: gameVM, board: gameVM.board, rules: gameVM.rules, isPaused: $isPaused, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
                default:
                GameLandscapeView(gameVM: gameVM, board: gameVM.board, rules: gameVM.rules, isPaused: $isPaused, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
            }
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
    @StateObject public var gameVM = try! GameVM(with: PlayerVM(with: PlayerStub().getPlayersModel()[0]), andWith: PlayerVM(with: PlayerStub().getPlayersModel()[1]), rules: Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!, board: BoardStub().getBoards()[0])
    @StateObject public var timerVM = TimerVM()
    
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    @State var isPlayer1Turn: Bool = true
    @State var isPlayer2Turn: Bool = false
    var body: some View {
        GameView(gameVM: gameVM, timer: timerVM, orientation: $orientation, idiom: $idiom, isPlayer1Turn: isPlayer1Turn, isPlayer2Turn: isPlayer2Turn)
    }
}
