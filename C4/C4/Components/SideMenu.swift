import SwiftUI

struct SideMenu: View {
    @Binding var showingMenu : Bool
    @Binding var orientation: UIDeviceOrientation?
    @Binding var idiom: UIUserInterfaceIdiom?
    
    var body: some View {
        HStack {
            Button(String(localized: "Back"), systemImage: "chevron.backward") {
                showingMenu.toggle()
            }
            .tint(Color(.primaryAccentBackground))
            Spacer()
        }
        .padding(.bottom, 15)
        
        VStack(alignment: .leading) {
            NavigationLink(destination: LaunchGame(orientation: $orientation, idiom: $idiom)) {
                Text(String(localized: "NewGame"))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
            }
            .foregroundColor(.primaryAccentBackground)
            
            NavigationLink(destination: SavedGames()) {
                Text(String(localized: "Results"))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
            }
            .foregroundColor(.primaryAccentBackground)
            
            NavigationLink(destination: FaceToFace()) {
                Text(String(localized: "FaceToFace"))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
            }
            .foregroundColor(.primaryAccentBackground)
        }
        Spacer()
    }
}
