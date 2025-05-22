//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        VStack {
            Spacer()
            Image("HomeImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(String(localized: "Connect4")).bold().font(.largeTitle)
            Spacer()
            
            NavigationLink(destination: LaunchGame()) {
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

#Preview {
    HomePage()
}
