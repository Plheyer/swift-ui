//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import SwiftUI

struct GameView: View {
    @ObservedObject public var game: GameVM
    @ObservedObject public var timer: TimerVM
    
    // Orientation
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    
    // Gameplay
    @State var isPaused : Bool = false
    @State var isPlayer1Turn = true
    @State var isPlayer2Turn = false
    
    let debug = false
    
    var body: some View {
        if debug { // To see if the parameters are passed correctly from the LaunchGame
            Text("nb Rows \(game.rules.nbRows)")
            Text("nb Columns \(game.rules.nbColumns)")
            Text("tokens to align \(game.rules.tokensToAlign)")
            Text("type rules \(game.rules.type)")
            Text("p1 name \(game.players[.player1]?.model.name ?? "BUG")")
            Text("p1 type \(game.players[.player1]?.model.type ?? "BUG")")
            Text("p2 name \(game.players[.player2]?.model.name ?? "BUG")")
            Text("p2 type \(game.players[.player2]?.model.type ?? "BUG")")
            Text("p1 image")
            game.players[.player1]!.model.image
                .resizable()
                .frame(width: 100, height: 100)
            Text("p2 image")
            game.players[.player2]!.model.image
                .resizable()
                .frame(width: 100, height: 100)
            Text("timer limited? \(timer.isLimitedTime)")
            Text("timer minutes \(timer.minutesString)")
            Text("timer seconds \(timer.secondsString)")
        }
        
        switch(orientation, idiom) {
            case (.portrait, .phone), (.portraitUpsideDown, .phone), (.portrait, .pad), (.portraitUpsideDown, .pad):
                GamePortraitView(game: game, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
            case (.landscapeLeft, .phone), (.landscapeRight, .phone):
                GameLandscapeView(game: game, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
            default:
                GameLandscapeView(game: game, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
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
    @StateObject public var gameVM : GameVM = GameVM(with: PlayerStub().getPlayersVM()[0], andWith: PlayerStub().getPlayersVM()[1], board: Board(withNbRows: 6, andNbColumns: 7)!)
    @StateObject public var timerVM = TimerVM()
    
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    var body: some View {
        GameView(game: gameVM, timer: timerVM, orientation: $orientation, idiom: $idiom)
    }
}
