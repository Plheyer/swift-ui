//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import Connect4Core
import Connect4Persistance
import SwiftUI
import _PhotosUI_SwiftUI

struct AddPlayerComponent: View {
    @ObservedObject var playerVM: PlayerVM
    @ObservedObject var playersVM: PlayersVM
    
    @State private var showWarningNameChangedPopup: Bool = false
    @State private var hasWarningBeenSeen: Bool = false
    
    @State private var showWarningSameNamePopup: Bool = false
    
    @State private var imageEdited = false
    
    public let originalName: String
    @State private var avatarItem: PhotosPickerItem?
    var body: some View {
        VStack(alignment: .center) {
            Text(String(localized: "AddPlayer"))
                .font(.title)
            
            playerVM.model.image
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
                .onChange(of: avatarItem) {
                    imageEdited = true
                }
            }
            .onChange(of: avatarItem) {
                Task {
                    if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                        playerVM.model.image = loaded
                    } else {
                        print("Failed")
                    }
                }
            }
            TextField(String(localized: "ChoosePlayerNamePlaceholer"), text: $playerVM.model.name)
                .frame(width: 200)
                .textFieldStyle(.roundedBorder)
                .onChange(of: playerVM.model.name) {
                    // Done only one time thanks to hasWarningBeenSeen
                    if !hasWarningBeenSeen && originalName != "" {
                        showWarningNameChangedPopup = true
                        hasWarningBeenSeen = true
                    }
                }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.primaryBackground))
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                            // Somebody has already the same name
                        if let modelName = playersVM.players.first(where: { $0.model.name == playerVM.model.name }), modelName.model.name != originalName {
                            showWarningSameNamePopup = true
                            return
                        }
                        var playerModel = PlayerModel(name: playerVM.model.name, owner: .player1, image: playerVM.model.image, type: "\(HumanPlayer.self)")
                        if imageEdited {
                            await playerModel.savePlayerImage()
                            playerVM.model.imageEdited = true
                        }
                        if let playerC4Model = playerModel.toC4Model {
                            _ = try? await Persistance.addPlayer(withName: "players.co4", andPlayer: playerC4Model)
                        }
                        playerVM.onEdited()
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .foregroundColor(.primaryAccentBackground)
                .cornerRadius(5)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    Task {
                        playerVM.onEdited()
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .foregroundColor(.secondaryBackground)
                .cornerRadius(5)
            }
        }
        .alert(String(localized: "NameChangedAlertTitle"), isPresented: $showWarningNameChangedPopup) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(String(localized: "NameChangedAlertDescription"))
        }
        .alert(String(localized: "SameNameAlertTitle"), isPresented: $showWarningSameNamePopup) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(String(localized: "SameNameAlertDescription"))
        }
    }
}

#Preview {
    AddPlayerComponentPreview()
}

private struct AddPlayerComponentPreview : View {
    @StateObject var playerVM = PlayerVM(with: PlayerModel(name: "", owner: .player1, image: Image("DefaultPlayerImage"), type: "\(HumanPlayer.self)"))
    var body: some View {
        AddPlayerComponent(playerVM: playerVM, playersVM: PlayersVM(players: [playerVM]), originalName: "")
    }
}
