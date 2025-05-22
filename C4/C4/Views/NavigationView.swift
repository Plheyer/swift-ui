import Foundation
import SwiftUI

struct NavigationView: View {
    @State var showingMenu : Bool = false
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                if showingMenu {
                    VStack(alignment: .leading) {
                        SideMenu(showingMenu: $showingMenu)
                    }
                    .transition(.move(edge: .leading))
                    .zIndex(1)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width / 1.5, alignment: .topLeading)
                    .background(Color(.primaryBackground))
                }
                
                HomePage()
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
                .frame(maxHeight: .infinity)
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

#Preview {
    NavigationView()
}
