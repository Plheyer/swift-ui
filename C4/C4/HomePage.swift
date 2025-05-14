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
            Spacer()
            
            Button(action: {}) {
                Text(String(localized: "NewGame"))
            }.buttonStyle(.borderedProminent)
            
            Button(action: {}) {
                Text(String(localized: "Results"))
            }.buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomePage()
}
