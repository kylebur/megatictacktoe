import Foundation

public enum EngineError: Error, LocalizedError, Equatable {
    case gameAlreadyFinished
    case invalidBoardIndex(Int)
    case invalidCellIndex(Int)
    case wrongTargetBoard(expected: Int, actual: Int)
    case subBoardAlreadyFinished(Int)
    case cellNotEmpty(board: Int, cell: Int)

    public var errorDescription: String? {
        switch self {
        case .gameAlreadyFinished:
            return "The match has already concluded."
        case .invalidBoardIndex(let b):
            return "Invalid board index: \(b). Must be 0...8."
        case .invalidCellIndex(let c):
            return "Invalid cell index: \(c). Must be 0...8."
        case .wrongTargetBoard(let expected, let actual):
            return "You must play in sub-board #\(expected + 1), but attempted board #\(actual + 1)."
        case .subBoardAlreadyFinished(let b):
            return "Sub-board #\(b + 1) has already been won or tied."
        case .cellNotEmpty(let b, let c):
            return "Cell (\(c + 1)) in board (\(b + 1)) is already occupied."
        }
    }
}

public final class MegaTicTacToeEngine: ObservableObject, @unchecked Sendable {
    @Published public private(set) var macroBoard: MacroBoard
    @Published public private(set) var currentTurn: Player
    @Published public private(set) var targetSubBoard: Int?
    @Published public private(set) var moveHistory: [MegaMove]
    @Published public private(set) var status: GameStatus

    public init(
        macroBoard: MacroBoard = MacroBoard(),
        currentTurn: Player = .x,
        targetSubBoard: Int? = nil,
        moveHistory: [MegaMove] = []
    ) {
        self.macroBoard = macroBoard
        self.currentTurn = currentTurn
        self.targetSubBoard = targetSubBoard
        self.moveHistory = moveHistory
        self.status = .inProgress(activePlayer: currentTurn, targetBoard: targetSubBoard)
        recomputeStatus()
    }

    public func reset() {
        self.macroBoard = MacroBoard()
        self.currentTurn = .x
        self.targetSubBoard = nil
        self.moveHistory = []
        self.status = .inProgress(activePlayer: .x, targetBoard: nil)
    }

    public func isValidMove(board: Int, cell: Int) -> Bool {
        guard !status.isTerminal else { return false }
        guard (0..<9).contains(board), (0..<9).contains(cell) else { return false }

        // Must respect targetSubBoard if specified
        if let target = targetSubBoard {
            if board != target { return false }
        }

        // Sub-board cannot be already won or drawn
        let sub = macroBoard.subBoards[board]
        if sub.isFinished { return false }

        // Cell must be empty
        return sub.cells[cell] == .empty
    }

    public func allValidMoves() -> [(board: Int, cell: Int)] {
        guard !status.isTerminal else { return [] }
        var valid: [(board: Int, cell: Int)] = []

        let boardsToCheck: [Int]
        if let target = targetSubBoard, !macroBoard.subBoards[target].isFinished {
            boardsToCheck = [target]
        } else {
            boardsToCheck = (0..<9).filter { !macroBoard.subBoards[$0].isFinished }
        }

        for b in boardsToCheck {
            for c in 0..<9 {
                if macroBoard.subBoards[b].cells[c] == .empty {
                    valid.append((board: b, cell: c))
                }
            }
        }
        return valid
    }

    @discardableResult
    public func makeMove(board: Int, cell: Int) -> Result<MegaMove, EngineError> {
        guard !status.isTerminal else {
            return .failure(.gameAlreadyFinished)
        }
        guard (0..<9).contains(board) else {
            return .failure(.invalidBoardIndex(board))
        }
        guard (0..<9).contains(cell) else {
            return .failure(.invalidCellIndex(cell))
        }

        if let target = targetSubBoard, target != board {
            return .failure(.wrongTargetBoard(expected: target, actual: board))
        }

        let subBoard = macroBoard.subBoards[board]
        if subBoard.isFinished {
            return .failure(.subBoardAlreadyFinished(board))
        }

        if subBoard.cells[cell] != .empty {
            return .failure(.cellNotEmpty(board: board, cell: cell))
        }

        // Apply move
        let player = currentTurn
        var updatedSubBoards = macroBoard.subBoards
        var updatedCells = subBoard.cells
        updatedCells[cell] = (player == .x) ? .x : .o
        updatedSubBoards[board] = SubBoard(cells: updatedCells)
        self.macroBoard = MacroBoard(subBoards: updatedSubBoards)

        let move = MegaMove(subBoardIndex: board, cellIndex: cell, player: player)
        self.moveHistory.append(move)

        // Determine next target board
        let nextTarget = cell
        let destinationSubBoard = macroBoard.subBoards[nextTarget]

        // If the destination sub-board is already finished (won or draw), player gets wildcard (nil)
        if destinationSubBoard.isFinished {
            self.targetSubBoard = nil
        } else {
            self.targetSubBoard = nextTarget
        }

        self.currentTurn = player.opponent
        recomputeStatus()

        return .success(move)
    }

    @discardableResult
    public func undoLastMove() -> Bool {
        guard !moveHistory.isEmpty else { return false }
        moveHistory.removeLast()

        // Replay moves from beginning
        let savedMoves = moveHistory
        reset()
        for m in savedMoves {
            _ = makeMove(board: m.subBoardIndex, cell: m.cellIndex)
        }
        return true
    }

    private func recomputeStatus() {
        if let winnerInfo = macroBoard.macroWinnerInfo {
            self.status = .won(winner: winnerInfo.winner, line: winnerInfo.line)
            return
        }

        if allValidMoves().isEmpty {
            self.status = .draw
            return
        }

        self.status = .inProgress(activePlayer: currentTurn, targetBoard: targetSubBoard)
    }
}
