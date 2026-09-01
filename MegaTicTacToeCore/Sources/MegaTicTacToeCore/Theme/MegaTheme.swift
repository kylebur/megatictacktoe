import SwiftUI

public enum MegaTheme {
    // MARK: - Color Palette
    public static let bgGradient = LinearGradient(
        colors: [
            Color(red: 0.04, green: 0.06, blue: 0.10),
            Color(red: 0.08, green: 0.11, blue: 0.18),
            Color(red: 0.05, green: 0.07, blue: 0.12)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let boardBackground = Color(red: 0.10, green: 0.13, blue: 0.20).opacity(0.85)
    public static let inactiveBoardBackground = Color(red: 0.06, green: 0.08, blue: 0.13).opacity(0.6)
    public static let activeBoardGlow = Color(red: 0.0, green: 0.95, blue: 0.8)
    public static let gridLineColor = Color.white.opacity(0.12)
    public static let activeGridLineColor = Color(red: 0.0, green: 0.95, blue: 0.8).opacity(0.4)

    // Player X (Cyan / Electric Blue)
    public static let playerXGradient = LinearGradient(
        colors: [
            Color(red: 0.0, green: 0.95, blue: 1.0),
            Color(red: 0.0, green: 0.6, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    public static let playerXColor = Color(red: 0.0, green: 0.88, blue: 1.0)
    public static let playerXGlow = Color(red: 0.0, green: 0.88, blue: 1.0).opacity(0.6)

    // Player O (Neon Coral / Flamingo)
    public static let playerOGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.25, blue: 0.5),
            Color(red: 1.0, green: 0.55, blue: 0.2)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    public static let playerOColor = Color(red: 1.0, green: 0.28, blue: 0.45)
    public static let playerOGlow = Color(red: 1.0, green: 0.28, blue: 0.45).opacity(0.6)

    // Gold / Win Accents
    public static let goldGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.85, blue: 0.2),
            Color(red: 1.0, green: 0.6, blue: 0.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    public static let goldColor = Color(red: 1.0, green: 0.82, blue: 0.1)

    // Glass Card
    public static let cardBackground = Color.white.opacity(0.06)
    public static let cardBorder = Color.white.opacity(0.12)

    public static func playerColor(for player: Player) -> Color {
        switch player {
        case .x: return playerXColor
        case .o: return playerOColor
        }
    }

    public static func playerGradient(for player: Player) -> LinearGradient {
        switch player {
        case .x: return playerXGradient
        case .o: return playerOGradient
        }
    }

    public static func playerGlow(for player: Player) -> Color {
        switch player {
        case .x: return playerXGlow
        case .o: return playerOGlow
        }
    }
}

// MARK: - View Modifiers
public struct GlassCardModifier: ViewModifier {
    public var cornerRadius: CGFloat = 16

    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(MegaTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(MegaTheme.cardBorder, lineWidth: 1)
                    )
            )
    }
}

public extension View {
    func glassCard(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
}
