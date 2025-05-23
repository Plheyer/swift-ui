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
    @Binding var isPlayer1Turn : Bool
    @Binding var isPlayer2Turn : Bool
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    
    var body: some View {
        switch(orientation, idiom) {
        case (.portrait, .phone), (.portraitUpsideDown, .phone), (.portrait, .pad), (.portraitUpsideDown, .pad):
                GamePortraitView(board: $board, rules: $rules, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
            case (.landscapeLeft, .phone), (.landscapeRight, .phone):
                GameLandscapeView(board: $board, rules: $rules, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
            default:
                GameLandscapeView(board: $board, rules: $rules, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn)
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
    @State private var index = 0
    @State private var board = BoardStub().getBoards()[0]
    @State private var rules : Rules = Connect4Rules(nbRows: 6, nbColumns: 7, nbPiecesToAlign: 4)!
    @State var isPlayer1Turn = false
    @State var isPlayer2Turn = true
    
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    @State var isPaused : Bool = false
    var body: some View {
        GameView(board: $board, rules: $rules, isPaused: isPaused, isPlayer1Turn: $isPlayer1Turn, isPlayer2Turn: $isPlayer2Turn, orientation: $orientation, idiom: $idiom)
    }
}
