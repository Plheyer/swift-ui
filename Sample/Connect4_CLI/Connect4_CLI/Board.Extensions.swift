import Connect4Core

extension Board {
    public func asString(withHighlighting highlights: [Cell]) -> String {
        var string = String()
        string.append("   ")
        for s in (1...nbColumns).map({ "  \($0) " }) {
            string.append(s)
        }
        for r in (0..<nbRows).reversed() {
            string.append("\n\n \(r+1) ")
            for c in 0..<nbColumns {
                let owner = grid[r][c]?.owner
                var cellString: String
                if highlights.contains(Cell(row: r, col: c, piece: grid[r][c])) {
                    cellString = switch owner {
                    case .player1: "🟥"
                    case .player2: "🟨"
                    default: "⬜️"
                    }
                } else {
                    cellString = (owner ?? .noOne).symbol
                }
                string.append(" \(cellString) ")
            }
        }
        return string
    }
}
