import Foundation

enum GameMode {
    case solo
    case multiplayer
}

struct GameRoom: Codable, Identifiable {
    let id: String
    var player1: Player?
    var player2: Player?
    var status: RoomStatus
    let createdAt: Date
    var startedAt: Date?
    var endedAt: Date?

    enum RoomStatus: String, Codable {
        case waiting
        case inProgress
        case completed
    }

    var isFull: Bool {
        return player1 != nil && player2 != nil
    }

    mutating func addPlayer(_ player: Player) -> Bool {
        if player1 == nil {
            player1 = player
            return true
        } else if player2 == nil {
            player2 = player
            status = .inProgress
            startedAt = Date()
            return true
        }
        return false
    }

    func getOpponent(for playerId: String) -> Player? {
        if player1?.id == playerId {
            return player2
        } else if player2?.id == playerId {
            return player1
        }
        return nil
    }

    func getWinner() -> Player? {
        guard let p1 = player1, let p2 = player2 else { return nil }
        if p1.score > p2.score {
            return p1
        } else if p2.score > p1.score {
            return p2
        }
        return nil // Tie
    }
}

struct Player: Codable, Identifiable {
    let id: String
    var name: String
    var score: Int
    var sentenceCount: Int
    var isReady: Bool

    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
        self.score = 0
        self.sentenceCount = 0
        self.isReady = false
    }
}
