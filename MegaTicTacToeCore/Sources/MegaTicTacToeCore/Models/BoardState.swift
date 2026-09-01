import Foundation

public enum CellState: String, Codable, Sendable, Equatable {
    case empty = "."
    case x = "X"
    case o = "O"

    public var player: Player? {
        switch self {
        case .x: return .x
        case .o: return .o
        case .empty: return nil
        }
    }
}

public enum SubBoardState: Codable, Sendable, Equatable {
    case inProgress
    case won(winner: Player, line: WinLine)
    case draw

    public var winner: Player? {
        if case .won(let player, _) = self {
            return player
        }
        return nil
    }

    public var isFinished: Bool {
        switch self {
        case .inProgress: return false
        case .won, .draw: return true
        }
    }
}

public struct SubBoard: Codable, Sendable, Equatable {
    public var cells: [CellState] // Length 9

    public init(cells: [CellState] = Array(repeating: .empty, count: 9)) {
        precondition(cells.count == 9, "SubBoard must contain exactly 9 cells")
        self.cells = cells
    }

    public var state: SubBoardState {
        // Check for 3-in-a-row lines
        let winLines: [WinLine] = [
            .row0, .row1, .row2,
            .col0, .col1, .col2,
            .diagMain, .diagAnti
        ]

        for line in winLines {
            let idxs = line.indices
            let first = cells[idxs[0]]
            if first != .empty && first == cells[idxs[1]] && first == cells[idxs[2]] {
                if let p = first.player {
                    return .won(winner: p, line: line)
                }
            }
        }

        // If no winner, check if board is full (draw)
        if isFull {
            return .draw
        }

        return .inProgress
    }

    public var isFull: Bool {
        return !cells.contains(.empty)
    }

    public var isFinished: Bool {
        return state.isFinished
    }
}

public struct MacroBoard: Codable, Sendable, Equatable {
    public var subBoards: [SubBoard] // Length 9

    public init(subBoards: [SubBoard] = Array(repeating: SubBoard(), count: 9)) {
        precondition(subBoards.count == 9, "MacroBoard must contain exactly 9 sub-boards")
        self.subBoards = subBoards
    }

    public var macroWinnerInfo: (winner: Player, line: WinLine)? {
        let winLines: [WinLine] = [
            .row0, .row1, .row2,
            .col0, .col1, .col2,
            .diagMain, .diagAnti
        ]

        for line in winLines {
            let idxs = line.indices
            let w0 = subBoards[idxs[0]].state.winner
            let w1 = subBoards[idxs[1]].state.winner
            let w2 = subBoards[idxs[2]].state.winner

            if let w0 = w0, w0 == w1 && w0 == w2 {
                return (winner: w0, line: line)
            }
        }
        return nil
    }

    public var isFullOrComplete: Bool {
        return subBoards.allSatisfy { $0.isFinished }
    }
}
