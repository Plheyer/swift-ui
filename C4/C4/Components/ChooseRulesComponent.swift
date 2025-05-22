import SwiftUI

struct ChooseRulesComponent: View {
    var rules = ["Classic", "Push", "TicTacToe"]
    @Binding var selectedRule: String
    @Binding var nbRows: Int
    @Binding var nbColumns: Int
    @Binding var tokenToAlign: Int
    let range = 4...20
    @Binding var isLimitedTime : Bool
    @Binding var minutesString : String
    @Binding var secondsString : String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "list.bullet.clipboard")
                Text(String(localized: "Rules"))
                Picker("Rules", selection: $selectedRule) {
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
                VStack {
                    HStack {
                        Text(String(localized: "Rows"))
                        Stepper(value: $nbRows, in: range, step: 1){
                            Text("\(nbRows)")
                        }
                    }
                    HStack {
                        Text(String(localized: "Columns"))
                        Stepper(value: $nbColumns, in: range, step: 1){
                            Text("\(nbColumns)")
                        }
                    }
                    HStack {
                        Text(String(localized: "TokensToAlign"))
                        Stepper(value: $tokenToAlign, in: range, step: 1){
                            Text("\(tokenToAlign)")
                        }
                    }
                }
                Spacer()
            }
            HStack {
                Image(systemName: "clock")
                Toggle(String(localized: "LimitedTime"), isOn: $isLimitedTime).toggleStyle(.switch).fixedSize()
                .tint(.primaryAccentBackground)
                if (isLimitedTime) {
                    TextField("", text: $minutesString).textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    Text(String(localized: "min"))
                    TextField("", text: $secondsString).textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    Text(String(localized: "sec"))
                }
                Spacer()
            }
        }.padding(2)
    }
}
