# QuicklyMe - Gamified Daily Journal

A gamified daily journaling app for iOS and iPadOS that makes writing fun and rewarding. Write solo or compete against others in real-time!

## Features

### Game Modes

#### Solo Mode
- Write at your own pace and beat your personal best
- Focus on improving your writing skills
- Track your progress and sentence count

#### Multiplayer Mode
- **Real-time competition**: Face off against another writer
- **Live score tracking**: See your opponent's score update in real-time
- **Automatic matchmaking**: Join random games or create private rooms
- **Winner declaration**: Results screen shows who wrote the best entry
- **Leading indicator**: Know if you're ahead, behind, or tied during the game

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

- **Models**: `JournalEntry`, `PromptGenerator`, `ScoringEngine`, `GameRoom`, `Player`
- **ViewModels**: `JournalViewModel`
- **Services**: `MultiplayerService`
- **Views**: `ContentView` (coordinator), `ModeSelectionView`, `SoloJournalView`, `MultiplayerJournalView`, `WaitingRoomView`, `ResultsView`, `FireworksView`

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

#### MultiplayerService
Handles real-time multiplayer functionality:
- Room creation and matchmaking
- Real-time score synchronization
- Opponent tracking
- Game state management
- Winner calculation

## Building and Running

1. Open `QuicklyMe.xcodeproj` in Xcode
2. Select your target device (iPhone or iPad simulator)
3. Press Cmd+R to build and run

## Usage

### Solo Mode
1. Launch the app
2. Select "Solo Mode" from the main menu
3. You'll see a one-word prompt at the top
4. The 30-minute timer starts automatically
5. Begin writing in the text editor
6. Watch your score increase as you write valid sentences
7. Reach 10 sentences to trigger the fireworks celebration!
8. Continue writing to earn more points

### Multiplayer Mode
1. Launch the app
2. Select "Multiplayer" from the main menu
3. Enter your name (or use the auto-generated name)
4. Wait in the lobby for an opponent to join
5. Once matched, both players get the same prompt
6. Write to earn points while watching your opponent's score
7. The leading indicator shows if you're ahead, behind, or tied
8. When the timer runs out, the winner is declared!
9. View the results screen to see final scores

## Tips for Maximum Points

- Write complete, meaningful sentences (at least 3 words)
- Avoid repeating the same word 3+ times in a sentence
- Use varied vocabulary
- Ensure proper spelling
- Keep your thoughts flowing naturally
- In multiplayer mode, stay calm and focused even when behind
- Quality over quantity - a well-written sentence with no penalties beats rushed writing

## Multiplayer Implementation Notes

The current implementation uses a local in-memory "database" for demonstration purposes. For production deployment, you would want to integrate with a real-time backend service such as:

- **Firebase Firestore**: Real-time database with excellent iOS SDK support
- **WebSockets**: Custom real-time server implementation
- **GameCenter**: Apple's native multiplayer gaming service
- **Supabase**: Open-source Firebase alternative with real-time capabilities

The `MultiplayerService` class is designed to be easily swapped out with any of these implementations.

## Future Enhancements

Potential features for future versions:
- Persistent multiplayer backend (Firebase/GameCenter integration)
- Save journal entries locally
- View past entries and scores
- Daily streaks and achievements
- Customizable prompts
- Export entries
- Dark mode support
- iCloud sync
- Friend system and private matches
- Leaderboards and rankings
- Tournament mode with multiple rounds
- Replay and share winning entries

## License

Copyright © 2025 QuicklyMe. All rights reserved.
