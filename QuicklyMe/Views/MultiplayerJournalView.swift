import SwiftUI

struct MultiplayerJournalView: View {
    @StateObject private var viewModel: JournalViewModel
    @ObservedObject var multiplayerService: MultiplayerService
    @FocusState private var isTextEditorFocused: Bool
    @State private var showResults = false

    init(multiplayerService: MultiplayerService) {
        self.multiplayerService = multiplayerService
        _viewModel = StateObject(wrappedValue: JournalViewModel())
    }

    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 0) {
                // Header with timer and scores
                headerView

                // Scrollable text editor
                textEditorView

                // Footer with your score
                footerView
            }
            .background(Color(uiColor: .systemBackground))

            // Fireworks overlay
            if viewModel.showFireworks {
                FireworksView()
                    .transition(.opacity)
            }

            // Results overlay
            if showResults {
                ResultsView(
                    room: multiplayerService.currentRoom!,
                    currentPlayerId: multiplayerService.getCurrentPlayer().id,
                    onDismiss: {
                        showResults = false
                    }
                )
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextEditorFocused = true
            }
        }
        .onChange(of: viewModel.score) { newScore in
            // Sync score to multiplayer service
            multiplayerService.updateScore(score: newScore, sentenceCount: viewModel.sentenceCount)
        }
        .onChange(of: viewModel.timeRemaining) { remaining in
            if remaining <= 0 {
                // Time's up!
                multiplayerService.endGame()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showResults = true
                }
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 12) {
            // Opponent score bar
            if let opponent = multiplayerService.getOpponent() {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.purple)
                    Text(opponent.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)

                    Spacer()

                    HStack(spacing: 8) {
                        Text("\(opponent.sentenceCount)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.secondary)
                        Text("sentences")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)

                        Divider()
                            .frame(height: 20)

                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                        Text("\(opponent.score)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.purple.opacity(0.1))
            }

            // Timer
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(timeColor)
                Text(viewModel.formattedTime())
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(timeColor)
                    .monospacedDigit()
            }
            .padding(.top, 8)

            // Prompt
            Text(viewModel.currentEntry.prompt)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.primary)
                .padding(.horizontal)
        }
        .padding(.bottom, 16)
        .background(Color(uiColor: .secondarySystemBackground))
        .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
    }

    private var textEditorView: some View {
        ScrollView {
            TextEditor(text: Binding(
                get: { viewModel.currentEntry.text },
                set: { viewModel.updateText($0) }
            ))
            .focused($isTextEditorFocused)
            .font(.system(size: 18, weight: .regular))
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .scrollContentBackground(.hidden)
            .frame(minHeight: 300)
        }
    }

    private var footerView: some View {
        HStack(spacing: 24) {
            // Your score indicator
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
                Text("You")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Sentence count
            VStack(spacing: 4) {
                Text("\(viewModel.sentenceCount)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                Text("Sentences")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Divider()
                .frame(height: 40)

            // Score
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 20))
                    Text("\(viewModel.score)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                Text("Points")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Divider()
                .frame(height: 40)

            // Lead indicator
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(leadColor)
                        .frame(width: 32, height: 32)
                    Image(systemName: leadIcon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                Text(leadText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color(uiColor: .secondarySystemBackground))
        .shadow(color: .black.opacity(0.1), radius: 2, y: -2)
    }

    private var timeColor: Color {
        if viewModel.timeRemaining > 10 * 60 {
            return .green
        } else if viewModel.timeRemaining > 5 * 60 {
            return .orange
        } else {
            return .red
        }
    }

    private var leadColor: Color {
        guard let opponent = multiplayerService.getOpponent() else { return .gray }
        if viewModel.score > opponent.score {
            return .green
        } else if viewModel.score < opponent.score {
            return .red
        } else {
            return .orange
        }
    }

    private var leadIcon: String {
        guard let opponent = multiplayerService.getOpponent() else { return "minus" }
        if viewModel.score > opponent.score {
            return "arrow.up"
        } else if viewModel.score < opponent.score {
            return "arrow.down"
        } else {
            return "equal"
        }
    }

    private var leadText: String {
        guard let opponent = multiplayerService.getOpponent() else { return "Solo" }
        if viewModel.score > opponent.score {
            return "Leading"
        } else if viewModel.score < opponent.score {
            return "Behind"
        } else {
            return "Tied"
        }
    }
}
