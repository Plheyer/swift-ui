import Foundation
import Connect4Core
import Connect4Rules
import Combine

public class TimerVM: ObservableObject {
    @Published private(set) var secondsElapsed: Int = 0
    @Published public private(set) var formattedTime: String = "00:00"
    @Published public var isOver: Bool = false
    @Published public var isRunning = false
    
    private let gameVM: GameVM?
    private var timer: Timer?
    private var time: Int

    public init(time: Int, gameVM: GameVM?) {
        self.time = time
        self.gameVM = gameVM
    }
    
    public func start() {
        reset()
        if time > 0 {
            secondsElapsed = time
        } else {
            secondsElapsed = 0
        }
        updateFormattedTime()
        play()
    }

    public func play() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }

            if self.time > 0 {
                self.secondsElapsed -= 1
                if self.secondsElapsed <= 0 {
                    self.secondsElapsed = 0
                    self.pause()
                    DispatchQueue.main.async {
                        self.isOver = true
                        self.gameVM?.endTimer()
                    }
                }
            } else {
                self.secondsElapsed += 1
            }

            self.updateFormattedTime()
        }
    }

    public func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    public func reset() {
        pause()
        secondsElapsed = 0
        formattedTime = "00:00"
    }

    private func updateFormattedTime() {
        let minutes = max(0, secondsElapsed) / 60
        let seconds = max(0, secondsElapsed) % 60
        formattedTime = String(format: "%02d:%02d", minutes, seconds)
    }
}
