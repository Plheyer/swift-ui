import Foundation
import Connect4Core
import Connect4Rules

public class TimerVM : ObservableObject {
    @Published public var isLimitedTime = false
    @Published public var minutesString = ""
    @Published public var secondsString = ""
}
