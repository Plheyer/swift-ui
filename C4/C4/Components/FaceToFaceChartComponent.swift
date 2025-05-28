import SwiftUI
import Connect4Core
import Charts

struct FaceToFaceChartComponent: View {
    @ObservedObject public var games : GameResultsVM
    private let states = [Owner.noOne, Owner.player1, Owner.player2]
    var player1Name: String
    private func getChartValues() -> [(key: String, value: Int)] {
        var win = 0, loss = 0, draw = 0

        for result in games.gameResults {
            if result.winner == .noOne {
                draw += 1
            } else if let winner = result.players.first(where: { $0.id == result.winner }) {
                if winner.name == player1Name {
                    win += 1
                } else {
                    loss += 1
                }
            }
        }

        return [
            (key: "Win", value: win),
            (key: "Loss", value: loss),
            (key: "Draw", value: draw)
        ]
    }
    
    var body: some View {
         Chart {
             ForEach (getChartValues(), id: \.key) { chartData in
                 SectorMark(
                    angle: .value("Name", chartData.value),
                    angularInset: 1.0
                 )
                 .foregroundStyle(by: .value("Type", "\(chartData.key)"))
                 .cornerRadius(2.0)
                 .annotation(position: .overlay) {
                     Text("\(chartData.value)")
                         .font(.headline)
                         .foregroundStyle(.white)
                 }
             }
         }
         .chartLegend(.hidden)
    }
}
