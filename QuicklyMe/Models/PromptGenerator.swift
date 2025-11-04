import Foundation

class PromptGenerator {
    static let prompts = [
        "Dream", "Journey", "Hope", "Memory", "Change",
        "Discovery", "Adventure", "Wonder", "Courage", "Peace",
        "Growth", "Freedom", "Mystery", "Strength", "Joy",
        "Challenge", "Harmony", "Passion", "Vision", "Trust",
        "Resilience", "Balance", "Clarity", "Purpose", "Gratitude",
        "Transformation", "Serenity", "Innovation", "Connection", "Reflection",
        "Inspiration", "Wisdom", "Creativity", "Energy", "Focus",
        "Curiosity", "Simplicity", "Abundance", "Patience", "Love",
        "Nature", "Success", "Beauty", "Truth", "Spirit",
        "Opportunity", "Intention", "Kindness", "Progress", "Potential"
    ]

    static func randomPrompt() -> String {
        prompts.randomElement() ?? "Journey"
    }
}
