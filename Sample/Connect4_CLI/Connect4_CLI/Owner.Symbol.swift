import Connect4Core

extension Owner {
    public var symbol: String {
        switch self{
        case .noOne:
            return "⚪️"
        case .player1:
            return "🔴"
        case .player2:
            return "🟡"
        }
    }
}
