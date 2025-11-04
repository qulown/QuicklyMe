# QuicklyMe - Gamified Daily Journal

A gamified daily journaling app for iOS and iPadOS that makes writing fun and rewarding.

## Features

### Core Functionality
- **30-Minute Timer**: Each journal session is timed with a 30-minute countdown
- **Daily Prompts**: Each session starts with a one-word prompt to inspire your writing
- **Scrolling Text Editor**: Clean, distraction-free writing interface

### Gamification Elements

#### Scoring System
- **First 10 Sentences**: Earn 30 points total (3 points per sentence)
- **Sentences 11+**: Earn 3 points per sentence
- **Penalty**: -2 points for sentences with 3 or more repeated words
- **10 Sentence Milestone**: Spectacular fireworks animation when you reach 10 sentences!

#### Quality Controls
- **Complete Thoughts**: Sentences must form complete thoughts (minimum 3 words)
- **English Only**: All words must be valid English words
- **Spell Check**: Built-in validation ensures proper spelling
- **No Repetition**: Discourages overuse of the same words within a sentence

### User Interface
- **Real-Time Score Display**: See your points accumulate as you write
- **Sentence Counter**: Track your progress toward the 10-sentence milestone
- **Color-Coded Timer**: Visual feedback on remaining time
  - Green: More than 10 minutes
  - Orange: 5-10 minutes
  - Red: Less than 5 minutes
- **Milestone Indicator**: Visual indicator showing progress to 10 sentences
- **Fireworks Celebration**: Animated celebration when reaching 10 sentences

## Technical Details

### Requirements
- iOS 16.0+
- iPadOS 16.0+
- Xcode 14.0+
- Swift 5.0+

### Architecture
The app follows the MVVM (Model-View-ViewModel) pattern:

- **Models**: `JournalEntry`, `PromptGenerator`, `ScoringEngine`
- **ViewModels**: `JournalViewModel`
- **Views**: `ContentView`, `FireworksView`

### Key Components

#### ScoringEngine
Handles all scoring logic including:
- Sentence detection using NaturalLanguage framework
- Repetitive word detection
- English language validation
- Spell checking using UITextChecker
- Complete thought validation

#### JournalViewModel
Manages the application state:
- Timer management
- Real-time score calculation
- Fireworks trigger on milestone
- Text updates

#### FireworksView
Animated celebration with:
- Multiple particle bursts
- Colorful firework effects
- Celebration text
- Auto-dismissing overlay

## Building and Running

1. Open `QuicklyMe.xcodeproj` in Xcode
2. Select your target device (iPhone or iPad simulator)
3. Press Cmd+R to build and run

## Usage

1. Launch the app
2. You'll see a one-word prompt at the top
3. The 30-minute timer starts automatically
4. Begin writing in the text editor
5. Watch your score increase as you write valid sentences
6. Reach 10 sentences to trigger the fireworks celebration!
7. Continue writing to earn more points

## Tips for Maximum Points

- Write complete, meaningful sentences (at least 3 words)
- Avoid repeating the same word 3+ times in a sentence
- Use varied vocabulary
- Ensure proper spelling
- Keep your thoughts flowing naturally

## Future Enhancements

Potential features for future versions:
- Save journal entries locally
- View past entries and scores
- Daily streaks and achievements
- Customizable prompts
- Export entries
- Dark mode support
- iCloud sync

## License

Copyright © 2025 QuicklyMe. All rights reserved.
