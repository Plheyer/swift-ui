//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import SwiftUI

struct HomePortraitComponent: View {
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    
    var body: some View {
        VStack {
            Spacer()
            Image("HomeImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(String(localized: "Connect4")).bold().font(.largeTitle)
            Spacer()
            
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
            
            Spacer()
        }
        .padding()
    }
}

#Preview("Phone/Portait") {
    HomePortraitComponentPreview(orientation: .portrait, idiom: .phone)
}

#Preview("Phone/Landscape") {
    HomePortraitComponentPreview(orientation: .landscapeLeft, idiom: .phone)
}

#Preview("Pad") {
    HomePortraitComponentPreview(orientation: .portrait, idiom: .pad)
}

private struct HomePortraitComponentPreview : View {
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    var body: some View {
        HomePortraitComponent(orientation: $orientation, idiom: $idiom)
    }
}
