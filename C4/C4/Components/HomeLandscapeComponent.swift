//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import SwiftUI

struct HomeLandscapeComponent: View {
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image("HomeImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(String(localized: "Connect4")).bold().font(.largeTitle)
            }
            Spacer()
            VStack {
                NavigationLink(destination: LaunchGame(orientation: $orientation, idiom: $idiom)) {
                    Text(String(localized: "NewGame"))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                }
                .background(Color(.primaryAccentBackground))
                .foregroundColor(.primaryBackground)
                .cornerRadius(5)
                
                NavigationLink(destination: SavedGames()) {
                    Text(String(localized: "Results"))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                }
                .background(Color(.primaryAccentBackground))
                .foregroundColor(.primaryBackground)
                .cornerRadius(5)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview("Phone/Portait") {
    HomeLandscapeComponentPreview(orientation: .portrait, idiom: .phone)
}

#Preview("Phone/Landscape") {
    HomeLandscapeComponentPreview(orientation: .landscapeLeft, idiom: .phone)
}

#Preview("Pad") {
    HomeLandscapeComponentPreview(orientation: .portrait, idiom: .pad)
}

private struct HomeLandscapeComponentPreview : View {
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    var body: some View {
        HomeLandscapeComponent(orientation: $orientation, idiom: $idiom)
    }
}

