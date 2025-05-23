import Foundation
import SwiftUI

struct NavigationView: View {
    @State var showingMenu : Bool = false
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                if showingMenu {
                    VStack(alignment: .leading) {
                        SideMenu(showingMenu: $showingMenu, orientation: $orientation, idiom: $idiom)
                    }
                    .transition(.move(edge: .leading))
                    .zIndex(1)
                    .padding()
                    .frame(width: 200, alignment: .topLeading)
                    .background(Color(.primaryBackground))
                }
                
                HomePage(orientation: $orientation, idiom: $idiom)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if showingMenu {
                            Button("") {
                                
                            }
                        } else {
                            Button("", systemImage: "line.3.horizontal") {
                                showingMenu.toggle()
                            }
                            .tint(Color(.primaryAccentBackground))
                        }
                    }
                }
                .transition(.move(edge: .leading))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.primaryBackground))
                .onTapGesture {
                    if showingMenu {
                        showingMenu.toggle()
                    }
                }
            }
        }
        .animation(.easeInOut, value: showingMenu)
        .tint(.primaryAccentBackground)
    }
}

#Preview("Phone/Portait") {
    NavigationViewPreview(orientation: .portrait, idiom: .phone)
}

#Preview("Phone/Landscape") {
    NavigationViewPreview(orientation: .landscapeLeft, idiom: .phone)
}

#Preview("Pad") {
    NavigationViewPreview(orientation: .portrait, idiom: .pad)
}

private struct NavigationViewPreview : View {
    @State var orientation: UIDeviceOrientation?
    @State var idiom: UIUserInterfaceIdiom?
    var body: some View {
        NavigationView(orientation: $orientation, idiom: $idiom)
    }
}
