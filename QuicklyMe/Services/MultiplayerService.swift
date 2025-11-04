import Foundation
import Combine

/// Mock multiplayer service for real-time game synchronization
/// In production, this would connect to Firebase, WebSockets, or GameCenter
class MultiplayerService: ObservableObject {
    @Published var currentRoom: GameRoom?
    @Published var isConnected = false
    @Published var error: String?

    private var updateTimer: Timer?
    private let currentPlayer: Player

    // Simulated "database" for demo purposes
    private static var rooms: [String: GameRoom] = [:]

    init(playerName: String) {
        self.currentPlayer = Player(name: playerName)
    }

    // MARK: - Room Management

    func createRoom() async throws -> GameRoom {
        var room = GameRoom(
            id: UUID().uuidString,
            player1: currentPlayer,
            player2: nil,
            status: .waiting,
            createdAt: Date()
        )

        Self.rooms[room.id] = room
        currentRoom = room
        isConnected = true

        // Start listening for updates
        startListening()

        return room
    }

    func joinRandomRoom() async throws -> GameRoom {
        // Find a waiting room
        if let waitingRoom = Self.rooms.values.first(where: { $0.status == .waiting && !$0.isFull }) {
            var room = waitingRoom
            _ = room.addPlayer(currentPlayer)
            Self.rooms[room.id] = room
            currentRoom = room
            isConnected = true

            // Start listening for updates
            startListening()

            return room
        } else {
            // No room available, create a new one
            return try await createRoom()
        }
    }

    func joinRoom(roomId: String) async throws -> GameRoom {
        guard var room = Self.rooms[roomId] else {
            throw MultiplayerError.roomNotFound
        }

        guard room.addPlayer(currentPlayer) else {
            throw MultiplayerError.roomFull
        }

        Self.rooms[room.id] = room
        currentRoom = room
        isConnected = true

        startListening()

        return room
    }

    func leaveRoom() {
        stopListening()
        currentRoom = nil
        isConnected = false
    }

    // MARK: - Score Updates

    func updateScore(score: Int, sentenceCount: Int) {
        guard var room = currentRoom else { return }

        // Update the current player's score
        if room.player1?.id == currentPlayer.id {
            room.player1?.score = score
            room.player1?.sentenceCount = sentenceCount
        } else if room.player2?.id == currentPlayer.id {
            room.player2?.score = score
            room.player2?.sentenceCount = sentenceCount
        }

        Self.rooms[room.id] = room
        currentRoom = room
    }

    func endGame() {
        guard var room = currentRoom else { return }
        room.status = .completed
        room.endedAt = Date()
        Self.rooms[room.id] = room
        currentRoom = room
    }

    // MARK: - Real-time Listening

    private func startListening() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.fetchRoomUpdates()
        }
    }

    private func stopListening() {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    private func fetchRoomUpdates() {
        guard let roomId = currentRoom?.id else { return }
        if let updatedRoom = Self.rooms[roomId] {
            currentRoom = updatedRoom
        }
    }

    // MARK: - Helpers

    func getCurrentPlayer() -> Player {
        currentPlayer
    }

    func getOpponent() -> Player? {
        currentRoom?.getOpponent(for: currentPlayer.id)
    }

    enum MultiplayerError: LocalizedError {
        case roomNotFound
        case roomFull
        case connectionFailed

        var errorDescription: String? {
            switch self {
            case .roomNotFound:
                return "Room not found"
            case .roomFull:
                return "Room is full"
            case .connectionFailed:
                return "Failed to connect"
            }
        }
    }
}
