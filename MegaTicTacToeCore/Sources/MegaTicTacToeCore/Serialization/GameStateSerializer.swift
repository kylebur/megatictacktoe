import Foundation

public struct GameSessionData: Codable, Sendable, Equatable {
    public let gameId: String
    public let playerXName: String
    public let playerOName: String
    public let currentTurn: Player
    public let targetSubBoard: Int? // -1 or nil if wildcard
    public let boardString: String  // 81 characters of '.', 'X', 'O'
    public let lastMoveBoard: Int?
    public let lastMoveCell: Int?
    public let version: Int

    public init(
        gameId: String = UUID().uuidString,
        playerXName: String = "Player X",
        playerOName: String = "Player O",
        currentTurn: Player = .x,
        targetSubBoard: Int? = nil,
        boardString: String,
        lastMoveBoard: Int? = nil,
        lastMoveCell: Int? = nil,
        version: Int = 1
    ) {
        self.gameId = gameId
        self.playerXName = playerXName
        self.playerOName = playerOName
        self.currentTurn = currentTurn
        self.targetSubBoard = targetSubBoard
        self.boardString = boardString
        self.lastMoveBoard = lastMoveBoard
        self.lastMoveCell = lastMoveCell
        self.version = version
    }
}

public enum GameStateSerializer {
    public static let urlScheme = "megagames"
    public static let gamePath = "tictactoe"

    /// Converts a MegaTicTacToeEngine instance into a GameSessionData struct
    public static func exportSession(
        from engine: MegaTicTacToeEngine,
        gameId: String = UUID().uuidString,
        playerXName: String = "Player X",
        playerOName: String = "Player O"
    ) -> GameSessionData {
        var flatCells = ""
        for b in 0..<9 {
            for c in 0..<9 {
                flatCells.append(engine.macroBoard.subBoards[b].cells[c].rawValue)
            }
        }

        let lastMove = engine.moveHistory.last

        return GameSessionData(
            gameId: gameId,
            playerXName: playerXName,
            playerOName: playerOName,
            currentTurn: engine.currentTurn,
            targetSubBoard: engine.targetSubBoard,
            boardString: flatCells,
            lastMoveBoard: lastMove?.subBoardIndex,
            lastMoveCell: lastMove?.cellIndex,
            version: 1
        )
    }

    /// Reconstructs a MegaTicTacToeEngine from a GameSessionData struct
    public static func restoreEngine(from session: GameSessionData) -> MegaTicTacToeEngine {
        var subBoards: [SubBoard] = []
        let chars = Array(session.boardString)

        for b in 0..<9 {
            var cells: [CellState] = []
            for c in 0..<9 {
                let idx = b * 9 + c
                if idx < chars.count {
                    let ch = String(chars[idx])
                    cells.append(CellState(rawValue: ch) ?? .empty)
                } else {
                    cells.append(.empty)
                }
            }
            subBoards.append(SubBoard(cells: cells))
        }

        let macro = MacroBoard(subBoards: subBoards)
        var moves: [MegaMove] = []
        if let lmb = session.lastMoveBoard, let lmc = session.lastMoveCell {
            let lastPlayer = session.currentTurn.opponent
            moves.append(MegaMove(subBoardIndex: lmb, cellIndex: lmc, player: lastPlayer))
        }

        return MegaTicTacToeEngine(
            macroBoard: macro,
            currentTurn: session.currentTurn,
            targetSubBoard: session.targetSubBoard,
            moveHistory: moves
        )
    }

    /// Encodes GameSessionData into an MSMessage URL (e.g. `megagames://tictactoe?data=...`)
    public static func encodeToURL(_ session: GameSessionData) -> URL? {
        guard let jsonData = try? JSONEncoder().encode(session) else { return nil }
        let base64 = jsonData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")

        var components = URLComponents()
        components.scheme = urlScheme
        components.host = gamePath
        components.queryItems = [
            URLQueryItem(name: "d", value: base64),
            URLQueryItem(name: "t", value: session.currentTurn.rawValue),
            URLQueryItem(name: "gid", value: session.gameId)
        ]
        return components.url
    }

    /// Decodes an MSMessage URL into GameSessionData
    public static func decodeFromURL(_ url: URL) -> GameSessionData? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        guard components.scheme == urlScheme && components.host == gamePath else {
            return nil
        }

        guard let base64Param = components.queryItems?.first(where: { $0.name == "d" })?.value else {
            return nil
        }

        // Restore padding and standard base64 characters
        var base64 = base64Param
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 {
            base64.append("=")
        }

        guard let data = Data(base64Encoded: base64) else { return nil }
        return try? JSONDecoder().decode(GameSessionData.self, from: data)
    }
}
