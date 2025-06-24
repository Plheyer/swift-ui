//
//  C4App.swift
//  C4
//
//  Created by etudiant on 14/05/2025.
//

import SwiftUI

@main
struct C4App: App {
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    var body: some Scene {
        WindowGroup {
            NavigationView(orientation: $orientation, idiom: $idiom)
                .modifier(DeviceOrientationViewModifier(orientation: $orientation))
                .onAppear {
                    idiom = UIDevice.current.userInterfaceIdiom
                }
        }
    }
}
