import Foundation
import SwiftUI

struct NavigationView: View {
    var body: some View {
        NavigationStack {
            HomePage()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "line.3.horizontal", action: {})
                }
            }
        }
    }
}

#Preview {
    NavigationView()
}
