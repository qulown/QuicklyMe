import SwiftUI

struct SoloJournalView: View {
    @StateObject private var viewModel = JournalViewModel()
    @FocusState private var isTextEditorFocused: Bool

    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 0) {
                // Header with timer and prompt
                headerView

                // Scrollable text editor
                textEditorView

                // Footer with score
                footerView
            }
            .background(Color(uiColor: .systemBackground))

            // Fireworks overlay
            if viewModel.showFireworks {
                FireworksView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Auto-focus text editor
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextEditorFocused = true
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 12) {
            // Timer
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(timeColor)
                Text(viewModel.formattedTime())
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(timeColor)
                    .monospacedDigit()
            }
            .padding(.top, 20)

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

            // Milestone indicator
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(milestoneColor)
                        .frame(width: 32, height: 32)
                    Text(viewModel.sentenceCount >= 10 ? "✓" : "10")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                Text("Milestone")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 16)
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

    private var milestoneColor: Color {
        viewModel.sentenceCount >= 10 ? .green : .gray
    }
}

#Preview {
    SoloJournalView()
}
