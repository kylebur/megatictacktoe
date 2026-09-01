import SwiftUI

public struct SubBoardView: View {
    public let boardIndex: Int
    public let subBoard: SubBoard
    public let isActiveTarget: Bool
    public let isWildcard: Bool
    public let lastMoveCell: Int?
    public let onCellTap: (Int) -> Void

    @State private var pulseGlow: Bool = false

    public init(
        boardIndex: Int,
        subBoard: SubBoard,
        isActiveTarget: Bool,
        isWildcard: Bool = false,
        lastMoveCell: Int? = nil,
        onCellTap: @escaping (Int) -> Void
    ) {
        self.boardIndex = boardIndex
        self.subBoard = subBoard
        self.isActiveTarget = isActiveTarget
        self.isWildcard = isWildcard
        self.lastMoveCell = lastMoveCell
        self.onCellTap = onCellTap
    }

    private var isEffectivelyActive: Bool {
        (!subBoard.isFinished) && (isActiveTarget || isWildcard)
    }

    public var body: some View {
        ZStack {
            // Base background
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(
                    isEffectivelyActive
                        ? MegaTheme.boardBackground
                        : MegaTheme.inactiveBoardBackground
                )

            // Neon glowing border when active
            if isEffectivelyActive {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        isWildcard ? Color.yellow.opacity(0.8) : MegaTheme.activeBoardGlow,
                        lineWidth: isWildcard ? 2 : 2.5
                    )
                    .shadow(
                        color: (isWildcard ? Color.yellow : MegaTheme.activeBoardGlow).opacity(pulseGlow ? 0.8 : 0.4),
                        radius: pulseGlow ? 8 : 4
                    )
                    .animation(
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: pulseGlow
                    )
            } else {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(MegaTheme.cardBorder, lineWidth: 0.8)
            }

            // 3x3 Grid of cells
            VStack(spacing: 3) {
                ForEach(0..<3) { row in
                    HStack(spacing: 3) {
                        ForEach(0..<3) { col in
                            let cellIndex = row * 3 + col
                            CellView(
                                state: subBoard.cells[cellIndex],
                                isLastMove: lastMoveCell == cellIndex,
                                isPlayable: isEffectivelyActive && subBoard.cells[cellIndex] == .empty,
                                action: { onCellTap(cellIndex) }
                            )
                        }
                    }
                }
            }
            .padding(4)

            // Captured / Finished Sub-Board Overlay
            switch subBoard.state {
            case .won(let winner, _):
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.black.opacity(0.72))

                    if winner == .x {
                        XMarkView(lineWidth: 10)
                            .padding(14)
                            .shadow(color: MegaTheme.playerXGlow, radius: 12)
                    } else {
                        OMarkView(lineWidth: 10)
                            .padding(14)
                            .shadow(color: MegaTheme.playerOGlow, radius: 12)
                    }
                }
                .transition(.scale.combined(with: .opacity))

            case .draw:
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.black.opacity(0.65))

                    Text("—")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                .transition(.opacity)

            case .inProgress:
                EmptyView()
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            pulseGlow = true
        }
    }
}
