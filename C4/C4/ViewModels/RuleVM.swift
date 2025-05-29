import Foundation
import Connect4Core
import Connect4Rules

public class RuleVM : ObservableObject {
    @Published public var nbRows : Int
    @Published public var nbColumns : Int
    @Published public var tokensToAlign : Int
    @Published public var type : String
    
    public var model : Rules? {
        switch (self.type) {
        case "\(Connect4Rules.self)":
            return Connect4Rules(nbRows: self.nbRows, nbColumns: self.nbColumns, nbPiecesToAlign: self.tokensToAlign)
        case "\(TicTacToeRules.self)":
            return TicTacToeRules(nbRows: self.nbRows, nbColumns: self.nbColumns, nbPiecesToAlign: self.tokensToAlign)
        case "\(PopOutRules.self)":
            return PopOutRules(nbRows: self.nbRows, nbColumns: self.nbColumns, nbPiecesToAlign: self.tokensToAlign)
        default:
            return nil
        }
    }
    
    public init(nbRows: Int, nbColumns: Int, tokensToAlign: Int, type: String) {
        self.nbRows = nbRows
        self.nbColumns = nbColumns
        self.tokensToAlign = tokensToAlign
        self.type = type
    }
}
