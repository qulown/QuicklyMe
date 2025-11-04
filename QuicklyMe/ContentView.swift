import SwiftUI

struct ContentView: View {
    @State private var selectedMode: GameMode? = nil
    @State private var playerName: String = ""
    @State private var multiplayerService: MultiplayerService?
    @State private var showWaitingRoom = false
    @State private var startGame = false

    var body: some View {
        Group {
            if selectedMode == nil {
                // Mode selection screen
                ModeSelectionView(selectedMode: $selectedMode)
            } else if selectedMode == .solo {
                // Solo mode
                SoloJournalView()
            } else if selectedMode == .multiplayer {
                // Multiplayer flow
                if !startGame {
                    if showWaitingRoom, let service = multiplayerService {
                        WaitingRoomView(
                            multiplayerService: service,
                            isWaiting: $showWaitingRoom,
                            onGameStart: {
                                startGame = true
                            }
                        )
                    } else {
                        Color.clear
                            .onAppear {
                                setupMultiplayer()
                            }
                    }
                } else if let service = multiplayerService {
                    MultiplayerJournalView(multiplayerService: service)
                }
            }
        }
        .onChange(of: selectedMode) { newMode in
            if newMode == .multiplayer {
                setupMultiplayer()
            }
        }
    }

    private func setupMultiplayer() {
        // Get player name from storage or generate one
        if playerName.isEmpty {
            playerName = "Player\(Int.random(in: 1000...9999))"
        }

        let service = MultiplayerService(playerName: playerName)
        multiplayerService = service

        // Try to join or create a room
        Task {
            do {
                _ = try await service.joinRandomRoom()
                await MainActor.run {
                    showWaitingRoom = true
                }
            } catch {
                print("Error joining room: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
