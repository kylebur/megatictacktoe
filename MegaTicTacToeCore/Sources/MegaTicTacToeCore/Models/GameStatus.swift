import Foundation

public struct MegaMove: Codable, Sendable, Equatable {
    public let subBoardIndex: Int  // 0...8
    public let cellIndex: Int      // 0...8
    public let player: Player
    public let timestamp: Date

    public init(subBoardIndex: Int, cellIndex: Int, player: Player, timestamp: Date = Date()) {
        self.subBoardIndex = subBoardIndex
        self.cellIndex = cellIndex
        self.player = player
        self.timestamp = timestamp
    }

    public static func == (lhs: MegaMove, rhs: MegaMove) -> Bool {
        lhs.subBoardIndex == rhs.subBoardIndex &&
        lhs.cellIndex == rhs.cellIndex &&
        lhs.player == rhs.player
    }
}

public enum GameStatus: Codable, Sendable, Equatable {
    /// In progress. `targetBoard` is the sub-board the active player must play in.
    /// If `nil`, the player has a free choice / wildcard move anywhere.
    case inProgress(activePlayer: Player, targetBoard: Int?)
    case won(winner: Player, line: WinLine)
    case draw

    public var isTerminal: Bool {
        switch self {
        case .inProgress: return false
        case .won, .draw: return true
        }
    }

    public var activePlayer: Player? {
        switch self {
        case .inProgress(let player, _): return player
        case .won, .draw: return nil
        }
    }

    public var targetBoard: Int? {
        switch self {
        case .inProgress(_, let target): return target
        case .won, .draw: return nil
        }
    }
}
