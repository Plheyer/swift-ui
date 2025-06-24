import SwiftUI
import Connect4Core
import Connect4Rules

struct ChooseRulesComponent: View {
    public var rules = ["\(Connect4Rules.self)", "\(TicTacToeRules.self)", "\(PopOutRules.self)"]
    @ObservedObject public var newGameVM: NewGameVM
    let range = -1...20
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "list.bullet.clipboard")
                Text(String(localized: "Rules"))
                Picker("Rules", selection: $newGameVM.rulesName) {
                    ForEach(rules, id: \.self) { rule in
                        //Text(rule)
                        Text(Connect4Rules.getLocalizedType(from: rule))
                    }
                }
                .tint(.primaryAccentBackground)
                Spacer()
            }
            HStack(alignment: .top) {
                HStack {
                    Image(systemName: "square.resize")
                    Text(String(localized: "Dimensions"))
                }.padding(.top, 5)
                Grid {
                    GridRow {
                        Text(String(localized: "Rows"))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        Stepper(value: $newGameVM.nbRows, in: range, step: 1) {
                            Text(newGameVM.nbRows.description)
                        }
                    }
                    GridRow {
                        Text(String(localized: "Columns"))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        Stepper(value: $newGameVM.nbColumns, in: range, step: 1) {
                            Text(newGameVM.nbColumns.description)
                        }
                    }
                    GridRow {
                        Text(String(localized: "TokensToAlign"))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        Stepper(value: $newGameVM.nbTokensToAlign, in: range, step: 1) {
                            Text(newGameVM.nbTokensToAlign.description)
                        }
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                Image(systemName: "clock")
                Toggle(String(localized: "LimitedTime"), isOn: $newGameVM.isLimitedTime).toggleStyle(.switch).fixedSize()
                .tint(.primaryAccentBackground)
                if (newGameVM.isLimitedTime) {
                    TextField("", text: $newGameVM.minutesString).textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    Text(String(localized: "min"))
                    TextField("", text: $newGameVM.secondsString).textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    Text(String(localized: "sec"))
                }
                Spacer()
            }
            HStack {
                Spacer()
                Toggle(String(localized: "IsAR"), isOn: $newGameVM.isAR).toggleStyle(.switch).fixedSize()
                .tint(.primaryAccentBackground)
                Spacer()
            }
        }.padding(2)
    }
}
