//
//  ContentView.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import SwiftUI

struct HomePage: View {
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    
    var body: some View {
        switch(orientation, idiom) {
        case (.portrait, .phone), (.portraitUpsideDown, .phone), (.portrait, .pad), (.portraitUpsideDown, .pad),
            (.unknown, .phone), (.unknown, .pad):
                HomePortraitComponent(orientation: $orientation, idiom: $idiom)
            case (.landscapeLeft, .phone), (.landscapeRight, .phone):
                HomeLandscapeComponent(orientation: $orientation, idiom: $idiom)
            default:
                HomeLandscapeComponent(orientation: $orientation, idiom: $idiom)
        }
    }
}

#Preview("Phone/Portait") {
    HomePagePreview(orientation: .portrait, idiom: .phone)
}

#Preview("Phone/Landscape") {
    HomePagePreview(orientation: .landscapeLeft, idiom: .phone)
}

#Preview("Pad") {
    HomePagePreview(orientation: .portrait, idiom: .pad)
}

private struct HomePagePreview : View {
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    var body: some View {
        HomePage(orientation: $orientation, idiom: $idiom)
    }
}
