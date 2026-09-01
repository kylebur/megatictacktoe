import XCTest
@testable import MegaTicTacToeCore

final class MegaTicTacToeCoreTests: XCTestCase {
    func testInitialState() {
        let engine = MegaTicTacToeEngine()
        XCTAssertEqual(engine.currentTurn, .x)
        XCTAssertNil(engine.targetSubBoard)
        XCTAssertEqual(engine.allValidMoves().count, 81)
        XCTAssertFalse(engine.status.isTerminal)
    }

    func testMoveAndSteeringRule() {
        let engine = MegaTicTacToeEngine()

        // X plays in board 4, cell 2 (top right of center board)
        let res1 = engine.makeMove(board: 4, cell: 2)
        XCTAssertEqual(res1, .success(MegaMove(subBoardIndex: 4, cellIndex: 2, player: .x)))
        XCTAssertEqual(engine.currentTurn, .o)
        // Next player O must be steered to board 2
        XCTAssertEqual(engine.targetSubBoard, 2)
        XCTAssertTrue(engine.isValidMove(board: 2, cell: 5))
        XCTAssertFalse(engine.isValidMove(board: 4, cell: 5)) // Cannot play outside target board
    }

    func testSubBoardWin() {
        var cells = Array(repeating: CellState.empty, count: 9)
        cells[0] = .x
        cells[1] = .x
        cells[2] = .x
        let sub = SubBoard(cells: cells)
        XCTAssertEqual(sub.state, .won(winner: .x, line: .row0))
        XCTAssertTrue(sub.isFinished)
    }

    func testWildcardWhenTargetBoardIsWon() {
        var subBoards = Array(repeating: SubBoard(), count: 9)
        // Pre-win board 2 for X
        var wonCells = Array(repeating: CellState.empty, count: 9)
        wonCells[0] = .x
        wonCells[1] = .x
        wonCells[2] = .x
        subBoards[2] = SubBoard(cells: wonCells)

        let engine = MegaTicTacToeEngine(
            macroBoard: MacroBoard(subBoards: subBoards),
            currentTurn: .x,
            targetSubBoard: nil
        )

        // X plays in board 0, cell 2 (which points to board 2, which is already won)
        let res = engine.makeMove(board: 0, cell: 2)
        XCTAssertTrue(res.isSuccess)

        // Next targetSubBoard should be NIL (wildcard free choice) because board 2 is won
        XCTAssertNil(engine.targetSubBoard)
    }

    func testMacroBoardWinDetection() {
        var subBoards = Array(repeating: SubBoard(), count: 9)

        // X wins boards 0, 1, 2 (Top row)
        for b in [0, 1, 2] {
            var cells = Array(repeating: CellState.empty, count: 9)
            cells[0] = .x
            cells[1] = .x
            cells[2] = .x
            subBoards[b] = SubBoard(cells: cells)
        }

        let macro = MacroBoard(subBoards: subBoards)
        XCTAssertEqual(macro.macroWinnerInfo?.winner, .x)
        XCTAssertEqual(macro.macroWinnerInfo?.line, .row0)

        let engine = MegaTicTacToeEngine(macroBoard: macro)
        if case .won(let winner, let line) = engine.status {
            XCTAssertEqual(winner, .x)
            XCTAssertEqual(line, .row0)
        } else {
            XCTFail("Engine should report won status")
        }
    }

    func testURLSerializationRoundtrip() {
        let engine = MegaTicTacToeEngine()
        _ = engine.makeMove(board: 4, cell: 0) // X plays 4,0 -> target is 0
        _ = engine.makeMove(board: 0, cell: 4) // O plays 0,4 -> target is 4

        let session = GameStateSerializer.exportSession(
            from: engine,
            gameId: "test-session-123",
            playerXName: "Alice",
            playerOName: "Bob"
        )

        guard let url = GameStateSerializer.encodeToURL(session) else {
            XCTFail("Failed to encode URL")
            return
        }

        guard let decodedSession = GameStateSerializer.decodeFromURL(url) else {
            XCTFail("Failed to decode URL")
            return
        }

        XCTAssertEqual(decodedSession.gameId, "test-session-123")
        XCTAssertEqual(decodedSession.playerXName, "Alice")
        XCTAssertEqual(decodedSession.playerOName, "Bob")
        XCTAssertEqual(decodedSession.currentTurn, .x)
        XCTAssertEqual(decodedSession.targetSubBoard, 4)

        let restoredEngine = GameStateSerializer.restoreEngine(from: decodedSession)
        XCTAssertEqual(restoredEngine.currentTurn, .x)
        XCTAssertEqual(restoredEngine.targetSubBoard, 4)
        XCTAssertEqual(restoredEngine.macroBoard.subBoards[4].cells[0], .x)
        XCTAssertEqual(restoredEngine.macroBoard.subBoards[0].cells[4], .o)
    }
}

extension Result {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
