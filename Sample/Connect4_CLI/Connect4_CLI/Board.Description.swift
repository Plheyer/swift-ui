import Connect4Core

extension Board: @retroactive CustomStringConvertible {
    public var description: String {
        var string = String()
        string.append("   ")
        for s in (1...nbColumns).map({ "  \($0) " }) {
            string.append(s)
        }
        for r in (0..<nbRows).reversed() {
            string.append("\n\n \(r+1) ")
            for c in 0..<nbColumns {
                let cellString = (grid[r][c]?.owner ?? .noOne).symbol
                string.append(" \(cellString) ")
            }
        }
        return string
    }
}
