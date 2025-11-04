import Foundation

struct JournalEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let prompt: String
    var text: String
    var score: Int
    var sentenceCount: Int

    init(prompt: String) {
        self.id = UUID()
        self.date = Date()
        self.prompt = prompt
        self.text = ""
        self.score = 0
        self.sentenceCount = 0
    }
}
