import SwiftUI
import Connect4Core
import Connect4Rules

struct ChooseRulesComponent: View {
    public var rules = ["\(Connect4Rules.self)", "\(TicTacToeRules.self)", "\(PopOutRules.self)"]
    @Binding public var rulesName: String
    @Binding public var nbRows: Int
    @Binding public var nbColumns: Int
    @Binding public var nbTokensToAlign: Int
    @ObservedObject public var timer: TimerVM
    let range = -1...20
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "list.bullet.clipboard")
                Text(String(localized: "Rules"))
                Picker("Rules", selection: $rulesName) {
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
                        Stepper(value: $nbRows, in: range, step: 1) {
                            Text(nbRows.description)
                        }
                    }
                    GridRow {
                        Text(String(localized: "Columns"))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        Stepper(value: $nbColumns, in: range, step: 1) {
                            Text(nbColumns.description)
                        }
                    }
                    GridRow {
                        Text(String(localized: "TokensToAlign"))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        Stepper(value: $nbTokensToAlign, in: range, step: 1) {
                            Text(nbTokensToAlign.description)
                        }
                    }
                }
                Spacer()
            }
            HStack {
                Image(systemName: "clock")
                Toggle(String(localized: "LimitedTime"), isOn: $timer.isLimitedTime).toggleStyle(.switch).fixedSize()
                .tint(.primaryAccentBackground)
                if (timer.isLimitedTime) {
                    TextField("", text: $timer.minutesString).textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    Text(String(localized: "min"))
                    TextField("", text: $timer.secondsString).textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    Text(String(localized: "sec"))
                }
                Spacer()
            }
        }.padding(2)
    }
}
