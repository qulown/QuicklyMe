import SwiftUI

struct WaitingRoomView: View {
    @ObservedObject var multiplayerService: MultiplayerService
    @Binding var isWaiting: Bool
    let onGameStart: () -> Void

    @State private var dotCount = 0

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Animated waiting indicator
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .stroke(Color.purple.opacity(0.2), lineWidth: 4)
                            .frame(width: 100, height: 100)

                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.purple, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))
                            .rotationEffect(.degrees(Double(dotCount) * 60))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: dotCount)

                        Image(systemName: "person.2.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.purple)
                    }

                    Text("Waiting for opponent" + String(repeating: ".", count: dotCount))
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(height: 30)
                }

                // Room info
                if let room = multiplayerService.currentRoom {
                    VStack(spacing: 16) {
                        Text("Room ID")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        Text(room.id.prefix(8).uppercased())
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(uiColor: .secondarySystemBackground))
                            )

                        Text("Share this code with a friend")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                // Cancel button
                Button(action: {
                    multiplayerService.leaveRoom()
                    isWaiting = false
                }) {
                    Text("Cancel")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 2)
                        )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            startAnimation()
            checkForOpponent()
        }
        .onChange(of: multiplayerService.currentRoom?.isFull) { isFull in
            if isFull == true {
                // Small delay before starting
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isWaiting = false
                    onGameStart()
                }
            }
        }
    }

    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if !isWaiting {
                timer.invalidate()
                return
            }
            dotCount = (dotCount + 1) % 4
        }
    }

    private func checkForOpponent() {
        // The MultiplayerService handles real-time updates
        // This is just a placeholder for additional logic if needed
    }
}

#Preview {
    WaitingRoomView(
        multiplayerService: MultiplayerService(playerName: "Test"),
        isWaiting: .constant(true),
        onGameStart: {}
    )
}
