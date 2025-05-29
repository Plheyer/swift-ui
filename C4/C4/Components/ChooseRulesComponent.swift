import SwiftUI
import Connect4Core
import Connect4Rules

struct ChooseRulesComponent: View {
    public var rules = ["\(Connect4Rules.self)", "\(TicTacToeRules.self)", "\(PopOutRules.self)"]
    @ObservedObject public var rule: RuleVM
    @ObservedObject public var timer : TimerVM
    let range = 4...20
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "list.bullet.clipboard")
                Text(String(localized: "Rules"))
                Picker("Rules", selection: $rule.type) {
                    ForEach(rules, id: \.self) { rule in
                        Text(rule)
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
                        Stepper(value: $rule.nbRows, in: range, step: 1) {
                            Text(rule.nbRows.description)
                        }
                    }
                    GridRow {
                        Text(String(localized: "Columns"))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        Stepper(value: $rule.nbColumns, in: range, step: 1) {
                            Text(rule.nbColumns.description)
                        }
                    }
                    GridRow {
                        Text(String(localized: "TokensToAlign"))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        Stepper(value: $rule.tokensToAlign, in: range, step: 1) {
                            Text(rule.tokensToAlign.description)
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
