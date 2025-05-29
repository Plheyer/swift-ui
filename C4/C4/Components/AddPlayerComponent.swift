//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import SwiftUI
import _PhotosUI_SwiftUI

struct AddPlayerComponent: View {
    @ObservedObject var playerVM: PlayerVM
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image? = Image("HomeImage")
    @State private var playerName: String = ""
    var body: some View {
        VStack(alignment: .center) {
            Text(String(localized: "AddPlayer"))
                .font(.title)
            
            avatarImage?
                .resizable()
                .frame(width: 100, height: 100)
            HStack {
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    HStack {
                        Image(systemName: "photo.artframe")
                        Text(String(localized: "Modify"))
                    }
                }
                .tint(Color(.primaryAccentBackground))
            }
            .onChange(of: avatarItem) {
                Task {
                    if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                        avatarImage = loaded
                    } else {
                        print("Failed")
                    }
                }
            }
            TextField(String(localized: "ChoosePlayerNamePlaceholer"), text: $playerName)
                .frame(width: 200)
                .textFieldStyle(.roundedBorder)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
    }
}

#Preview {
    AddPlayerComponentPreview()
}

private struct AddPlayerComponentPreview : View {
    @StateObject var playerVM = PlayerVM(name: "", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)")
    var body: some View {
        AddPlayerComponent(playerVM: playerVM)
    }
}
