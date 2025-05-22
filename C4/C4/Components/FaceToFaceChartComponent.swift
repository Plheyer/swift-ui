import SwiftUI
import Connect4Core
import Charts

struct FaceToFaceChartComponent: View {
    @Binding public var games : [(name: String, value: Int)]
    var body: some View {
         Chart {
             ForEach (games, id: \.name) { g in
                 SectorMark(
                    angle: .value("Name", g.value),
                    angularInset: 1.0
                 )
                 .foregroundStyle(by: .value("Type", g.name))
                 .cornerRadius(2.0)
                 .annotation(position: .overlay) {
                     Text("\(g.value)")
                         .font(.headline)
                         .foregroundStyle(.white)
                 }
             }
         }
         .chartLegend(.hidden)
    }
}
