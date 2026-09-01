import SwiftUI

public struct MegaBoardView: View {
    @ObservedObject public var engine: MegaTicTacToeEngine
    public let onCellTap: (Int, Int) -> Void

    public init(
        engine: MegaTicTacToeEngine,
        onCellTap: @escaping (Int, Int) -> Void
    ) {
        self.engine = engine
        self.onCellTap = onCellTap
    }

    public var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let isWildcard = engine.targetSubBoard == nil && !engine.status.isTerminal
            let lastMove = engine.moveHistory.last

            ZStack {
                // Macro 3x3 Grid
                VStack(spacing: 8) {
                    ForEach(0..<3) { macroRow in
                        HStack(spacing: 8) {
                            ForEach(0..<3) { macroCol in
                                let boardIndex = macroRow * 3 + macroCol
                                let subBoard = engine.macroBoard.subBoards[boardIndex]
                                let isActive = (engine.targetSubBoard == boardIndex)
                                let lastMoveCell = (lastMove?.subBoardIndex == boardIndex) ? lastMove?.cellIndex : nil

                                SubBoardView(
                                    boardIndex: boardIndex,
                                    subBoard: subBoard,
                                    isActiveTarget: isActive,
                                    isWildcard: isWildcard,
                                    lastMoveCell: lastMoveCell,
                                    onCellTap: { cellIndex in
                                        onCellTap(boardIndex, cellIndex)
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.black.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(MegaTheme.cardBorder, lineWidth: 1.5)
                        )
                )

                // Match Winner Strikethrough / Overlay Line
                if case .won(_, let line) = engine.status {
                    WinLineOverlay(line: line, size: size)
                }
            }
            .frame(width: size, height: size)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

public struct WinLineOverlay: View {
    public let line: WinLine
    public let size: CGFloat

    public var body: some View {
        Canvas { context, canvasSize in
            let step = canvasSize.width / 3
            let half = step / 2

            var start = CGPoint.zero
            var end = CGPoint.zero

            switch line {
            case .row0:
                start = CGPoint(x: 20, y: half)
                end = CGPoint(x: canvasSize.width - 20, y: half)
            case .row1:
                start = CGPoint(x: 20, y: half + step)
                end = CGPoint(x: canvasSize.width - 20, y: half + step)
            case .row2:
                start = CGPoint(x: 20, y: half + step * 2)
                end = CGPoint(x: canvasSize.width - 20, y: half + step * 2)
            case .col0:
                start = CGPoint(x: half, y: 20)
                end = CGPoint(x: half, y: canvasSize.height - 20)
            case .col1:
                start = CGPoint(x: half + step, y: 20)
                end = CGPoint(x: half + step, y: canvasSize.height - 20)
            case .col2:
                start = CGPoint(x: half + step * 2, y: 20)
                end = CGPoint(x: half + step * 2, y: canvasSize.height - 20)
            case .diagMain:
                start = CGPoint(x: 24, y: 24)
                end = CGPoint(x: canvasSize.width - 24, y: canvasSize.height - 24)
            case .diagAnti:
                start = CGPoint(x: canvasSize.width - 24, y: 24)
                end = CGPoint(x: 24, y: canvasSize.height - 24)
            }

            var path = Path()
            path.move(to: start)
            path.addLine(to: end)

            context.stroke(
                path,
                with: .color(MegaTheme.goldColor),
                style: StrokeStyle(lineWidth: 10, lineCap: .round)
            )
        }
        .allowsHitTesting(false)
        .transition(.opacity)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: line)
    }
}
