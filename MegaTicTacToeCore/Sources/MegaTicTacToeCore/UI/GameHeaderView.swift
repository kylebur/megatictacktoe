import SwiftUI

public struct GameHeaderView: View {
    @ObservedObject public var engine: MegaTicTacToeEngine
    public let playerXTitle: String
    public let playerOTitle: String

    public init(
        engine: MegaTicTacToeEngine,
        playerXTitle: String = "Player X",
        playerOTitle: String = "Player O"
    ) {
        self.engine = engine
        self.playerXTitle = playerXTitle
        self.playerOTitle = playerOTitle
    }

    public var body: some View {
        VStack(spacing: 12) {
            // Player vs Player Cards
            HStack(spacing: 16) {
                PlayerCard(
                    player: .x,
                    name: playerXTitle,
                    isActive: engine.currentTurn == .x && !engine.status.isTerminal
                )

                Text("VS")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundColor(.white.opacity(0.4))

                PlayerCard(
                    player: .o,
                    name: playerOTitle,
                    isActive: engine.currentTurn == .o && !engine.status.isTerminal
                )
            }

            // Target Directive Banner
            TargetDirectiveBanner(engine: engine)
        }
        .padding(.horizontal)
    }
}

public struct PlayerCard: View {
    public let player: Player
    public let name: String
    public let isActive: Bool

    public var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(MegaTheme.playerColor(for: player).opacity(0.2))
                    .frame(width: 34, height: 34)

                if player == .x {
                    XMarkView(lineWidth: 2.5)
                        .frame(width: 16, height: 16)
                } else {
                    OMarkView(lineWidth: 2.5)
                        .frame(width: 16, height: 16)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(player.rawValue)
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundColor(MegaTheme.playerColor(for: player))
            }

            Spacer()

            if isActive {
                Circle()
                    .fill(MegaTheme.playerColor(for: player))
                    .frame(width: 8, height: 8)
                    .shadow(color: MegaTheme.playerGlow(for: player), radius: 4)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isActive ? Color.white.opacity(0.12) : Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(
                            isActive ? MegaTheme.playerColor(for: player).opacity(0.8) : Color.white.opacity(0.08),
                            lineWidth: isActive ? 1.5 : 1
                        )
                )
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
    }
}

public struct TargetDirectiveBanner: View {
    @ObservedObject public var engine: MegaTicTacToeEngine

    private var targetText: String {
        switch engine.status {
        case .won(let winner, _):
            return "🎉 \(winner == .x ? "Player X" : "Player O") Wins the Match!"
        case .draw:
            return "🤝 Match Draw!"
        case .inProgress(let activePlayer, let target):
            if let target = target {
                let positionName = boardPositionName(for: target)
                return "\(activePlayer.rawValue)'s Turn • Target: \(positionName)"
            } else {
                return "✨ Wildcard Turn! Play on ANY open board"
            }
        }
    }

    private func boardPositionName(for index: Int) -> String {
        switch index {
        case 0: return "Top Left"
        case 1: return "Top Center"
        case 2: return "Top Right"
        case 3: return "Middle Left"
        case 4: return "Center"
        case 5: return "Middle Right"
        case 6: return "Bottom Left"
        case 7: return "Bottom Center"
        case 8: return "Bottom Right"
        default: return "#\(index + 1)"
        }
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: engine.targetSubBoard == nil ? "sparkles" : "scope")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(engine.targetSubBoard == nil ? .yellow : MegaTheme.activeBoardGlow)

            Text(targetText)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.4))
                .overlay(
                    Capsule()
                        .stroke(
                            engine.targetSubBoard == nil ? Color.yellow.opacity(0.6) : MegaTheme.activeBoardGlow.opacity(0.5),
                            lineWidth: 1
                        )
                )
        )
        .animation(.easeInOut(duration: 0.25), value: targetText)
    }
}
