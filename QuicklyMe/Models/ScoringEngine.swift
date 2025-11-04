import Foundation
import NaturalLanguage
import UIKit

class ScoringEngine {

    /// Analyzes text and calculates score based on rules:
    /// - First 10 sentences: 30 points total
    /// - Each sentence after 10: 3 points
    /// - -2 points for sentences with 3+ same/similar words
    static func calculateScore(text: String) -> (score: Int, sentenceCount: Int, milestone: Bool) {
        let sentences = extractSentences(from: text)
        var totalScore = 0
        var previousCount = 0
        var milestoneReached = false

        for (index, sentence) in sentences.enumerated() {
            let sentenceNumber = index + 1

            // Check if sentence is valid (not nonsense)
            guard isValidSentence(sentence) else {
                continue
            }

            // Base points for sentence
            var sentenceScore = 0
            if sentenceNumber <= 10 {
                sentenceScore = 3 // Will total 30 for first 10
            } else {
                sentenceScore = 3
            }

            // Check for repetitive words
            if hasRepetitiveWords(sentence) {
                sentenceScore -= 2
            }

            totalScore += sentenceScore

            // Check if we just reached 10 sentences
            if sentenceNumber == 10 && previousCount < 10 {
                milestoneReached = true
            }
        }

        previousCount = sentences.count

        return (max(0, totalScore), sentences.count, milestoneReached)
    }

    /// Extracts sentences from text using NLTokenizer
    private static func extractSentences(from text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text

        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !sentence.isEmpty {
                sentences.append(sentence)
            }
            return true
        }

        return sentences
    }

    /// Checks if a sentence has 3 or more same/similar words
    private static func hasRepetitiveWords(_ sentence: String) -> Bool {
        let words = sentence
            .lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .map { $0.trimmingCharacters(in: .punctuationCharacters) }

        // Count word frequencies
        var wordCounts: [String: Int] = [:]
        for word in words {
            // Skip very short words (articles, etc.)
            if word.count <= 2 {
                continue
            }
            wordCounts[word, default: 0] += 1
        }

        // Check if any word appears 3 or more times
        return wordCounts.values.contains { $0 >= 3 }
    }

    /// Validates that a sentence is in English and not nonsense
    private static func isValidSentence(_ sentence: String) -> Bool {
        // Must have at least 3 words to be a complete thought
        let words = sentence
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        if words.count < 3 {
            return false
        }

        // Check language
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(sentence)

        if let language = recognizer.dominantLanguage {
            if language != .english {
                return false
            }
        }

        // Check that words are real English words using spell checker
        let checker = UITextChecker()
        var realWordCount = 0

        for word in words {
            let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
            if cleanWord.isEmpty {
                continue
            }

            let range = NSRange(location: 0, length: cleanWord.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(
                in: cleanWord,
                range: range,
                startingAt: 0,
                wrap: false,
                language: "en"
            )

            // If no misspelling found, it's a real word
            if misspelledRange.location == NSNotFound {
                realWordCount += 1
            }
        }

        // At least 60% of words should be real English words
        let validWordRatio = Double(realWordCount) / Double(words.count)
        return validWordRatio >= 0.6
    }
}
