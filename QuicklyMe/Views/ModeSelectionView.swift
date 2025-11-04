import SwiftUI

struct ModeSelectionView: View {
    @Binding var selectedMode: GameMode?
    @State private var playerName: String = ""
    @State private var showNameInput = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    // Title
                    VStack(spacing: 16) {
                        Text("QuicklyMe")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

                        Text("Gamified Daily Journal")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 60)

                    Spacer()

                    // Mode buttons
                    VStack(spacing: 24) {
                        // Solo Mode
                        ModeButton(
                            title: "Solo Mode",
                            subtitle: "Write alone, beat your best score",
                            icon: "person.fill",
                            color: .blue
                        ) {
                            selectedMode = .solo
                        }

                        // Multiplayer Mode
                        ModeButton(
                            title: "Multiplayer",
                            subtitle: "Compete with another writer",
                            icon: "person.2.fill",
                            color: .purple
                        ) {
                            showNameInput = true
                        }
                    }
                    .padding(.horizontal, 32)

                    Spacer()

                    // Info footer
                    VStack(spacing: 8) {
                        HStack(spacing: 16) {
                            InfoTag(icon: "clock.fill", text: "30 min")
                            InfoTag(icon: "star.fill", text: "Points")
                            InfoTag(icon: "sparkles", text: "Fireworks")
                        }

                        Text("Write 10 sentences to unlock the fireworks!")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 40)
                }
            }
            .sheet(isPresented: $showNameInput) {
                NameInputView(
                    playerName: $playerName,
                    isPresented: $showNameInput,
                    onStart: {
                        selectedMode = .multiplayer
                    }
                )
            }
        }
    }
}

struct ModeButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)

                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(color)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            )
        }
    }
}

struct InfoTag: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(.system(size: 14, weight: .medium))
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
}

struct NameInputView: View {
    @Binding var playerName: String
    @Binding var isPresented: Bool
    let onStart: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Text("Enter Your Name")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 40)

                TextField("Your name", text: $playerName)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 20))
                    .padding(.horizontal, 32)
                    .submitLabel(.done)
                    .onSubmit {
                        if !playerName.isEmpty {
                            startGame()
                        }
                    }

                Button(action: startGame) {
                    Text("Start Game")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(playerName.isEmpty ? Color.gray : Color.purple)
                        )
                }
                .disabled(playerName.isEmpty)
                .padding(.horizontal, 32)

                Spacer()
            }
            .navigationBarItems(
                trailing: Button("Cancel") {
                    isPresented = false
                }
            )
        }
    }

    private func startGame() {
        if playerName.isEmpty {
            playerName = "Player"
        }
        isPresented = false
        onStart()
    }
}

#Preview {
    ModeSelectionView(selectedMode: .constant(nil))
}
