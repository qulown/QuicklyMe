import SwiftUI

struct ResultsView: View {
    let room: GameRoom
    let currentPlayerId: String
    let onDismiss: () -> Void

    private var winner: Player? {
        room.getWinner()
    }

    private var currentPlayer: Player? {
        if room.player1?.id == currentPlayerId {
            return room.player1
        } else {
            return room.player2
        }
    }

    private var opponent: Player? {
        if room.player1?.id == currentPlayerId {
            return room.player2
        } else {
            return room.player1
        }
    }

    private var didWin: Bool {
        winner?.id == currentPlayerId
    }

    private var isTie: Bool {
        winner == nil && room.player1 != nil && room.player2 != nil
    }

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Results card
                VStack(spacing: 24) {
                    // Result emoji and text
                    VStack(spacing: 16) {
                        Text(resultEmoji)
                            .font(.system(size: 80))

                        Text(resultTitle)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)

                        Text(resultSubtitle)
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 32)

                    Divider()

                    // Scores
                    VStack(spacing: 16) {
                        // Your score
                        if let player = currentPlayer {
                            PlayerScoreRow(
                                player: player,
                                isWinner: didWin && !isTie,
                                label: "You"
                            )
                        }

                        // Opponent score
                        if let player = opponent {
                            PlayerScoreRow(
                                player: player,
                                isWinner: !didWin && !isTie,
                                label: player.name
                            )
                        }
                    }
                    .padding(.horizontal, 24)

                    Divider()

                    // Close button
                    Button(action: onDismiss) {
                        Text("Close")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(didWin ? Color.green : (isTie ? Color.orange : Color.blue))
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(uiColor: .systemBackground))
                )
                .padding(.horizontal, 32)

                Spacer()
            }
        }
    }

    private var resultEmoji: String {
        if isTie {
            return "🤝"
        } else if didWin {
            return "🏆"
        } else {
            return "💪"
        }
    }

    private var resultTitle: String {
        if isTie {
            return "It's a Tie!"
        } else if didWin {
            return "You Won!"
        } else {
            return "Good Try!"
        }
    }

    private var resultSubtitle: String {
        if isTie {
            return "Both writers scored equally well!"
        } else if didWin {
            return "Congratulations! You out-wrote your opponent!"
        } else {
            return "Keep practicing to improve your score!"
        }
    }
}

struct PlayerScoreRow: View {
    let player: Player
    let isWinner: Bool
    let label: String

    var body: some View {
        HStack {
            // Player info
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isWinner ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                        .frame(width: 44, height: 44)

                    Image(systemName: isWinner ? "crown.fill" : "person.fill")
                        .font(.system(size: 20))
                        .foregroundColor(isWinner ? .yellow : .gray)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)

                    Text("\(player.sentenceCount) sentences")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Score
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("\(player.score)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isWinner ? Color.green.opacity(0.1) : Color(uiColor: .secondarySystemBackground))
        )
    }
}

#Preview {
    ResultsView(
        room: GameRoom(
            id: "test",
            player1: Player(name: "Alice"),
            player2: Player(name: "Bob"),
            status: .completed,
            createdAt: Date()
        ),
        currentPlayerId: "test",
        onDismiss: {}
    )
}
