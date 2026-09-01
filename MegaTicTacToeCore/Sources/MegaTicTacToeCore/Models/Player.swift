import Foundation

public enum Player: String, Codable, CaseIterable, Sendable {
    case x = "X"
    case o = "O"

    public var opponent: Player {
        switch self {
        case .x: return .o
        case .o: return .x
        }
    }

    public var displayName: String {
        switch self {
        case .x: return "Player X"
        case .o: return "Player O"
        }
    }
}

public enum WinLine: String, Codable, Sendable, Equatable {
    case row0 = "row0"
    case row1 = "row1"
    case row2 = "row2"
    case col0 = "col0"
    case col1 = "col1"
    case col2 = "col2"
    case diagMain = "diagMain"   // (0,0), (1,1), (2,2) -> indices 0, 4, 8
    case diagAnti = "diagAnti"   // (0,2), (1,1), (2,0) -> indices 2, 4, 6

    public var indices: [Int] {
        switch self {
        case .row0: return [0, 1, 2]
        case .row1: return [3, 4, 5]
        case .row2: return [6, 7, 8]
        case .col0: return [0, 3, 6]
        case .col1: return [1, 4, 7]
        case .col2: return [2, 5, 8]
        case .diagMain: return [0, 4, 8]
        case .diagAnti: return [2, 4, 6]
        }
    }
}
