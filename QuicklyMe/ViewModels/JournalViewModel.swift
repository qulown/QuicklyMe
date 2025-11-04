import Foundation
import Combine

class JournalViewModel: ObservableObject {
    @Published var currentEntry: JournalEntry
    @Published var timeRemaining: TimeInterval = 30 * 60 // 30 minutes
    @Published var isTimerRunning = false
    @Published var showFireworks = false
    @Published var score = 0
    @Published var sentenceCount = 0

    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var previousSentenceCount = 0

    init() {
        let prompt = PromptGenerator.randomPrompt()
        self.currentEntry = JournalEntry(prompt: prompt)

        // Start timer automatically
        startTimer()
    }

    func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            stopTimer()
        }
    }

    func updateText(_ text: String) {
        currentEntry.text = text

        let result = ScoringEngine.calculateScore(text: text)
        score = result.score
        sentenceCount = result.sentenceCount
        currentEntry.score = result.score
        currentEntry.sentenceCount = result.sentenceCount

        // Check for 10 sentence milestone
        if result.milestone && previousSentenceCount < 10 {
            triggerFireworks()
        }

        previousSentenceCount = result.sentenceCount
    }

    private func triggerFireworks() {
        showFireworks = true

        // Hide fireworks after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.showFireworks = false
        }
    }

    func formattedTime() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    deinit {
        timer?.invalidate()
    }
}
