import SwiftUI

public struct CellView: View {
    public let state: CellState
    public let isLastMove: Bool
    public let isPlayable: Bool
    public let action: () -> Void

    @State private var isPressed: Bool = false

    public init(
        state: CellState,
        isLastMove: Bool = false,
        isPlayable: Bool = false,
        action: @escaping () -> Void
    ) {
        self.state = state
        self.isLastMove = isLastMove
        self.isPlayable = isPlayable
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(
                        isPlayable
                            ? Color.white.opacity(isPressed ? 0.20 : 0.08)
                            : Color.white.opacity(0.02)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(
                                isLastMove
                                    ? Color.yellow.opacity(0.8)
                                    : (isPlayable ? Color.white.opacity(0.18) : Color.clear),
                                lineWidth: isLastMove ? 1.5 : 0.5
                            )
                    )

                // Marker
                switch state {
                case .x:
                    XMarkView()
                        .transition(.scale.combined(with: .opacity))
                case .o:
                    OMarkView()
                        .transition(.scale.combined(with: .opacity))
                case .empty:
                    if isPlayable {
                        Circle()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(CellButtonStyle(isPressed: $isPressed))
        .disabled(!isPlayable || state != .empty)
    }
}

// MARK: - Mark Renderers
public struct XMarkView: View {
    public var lineWidth: CGFloat = 3.5

    public init(lineWidth: CGFloat = 3.5) {
        self.lineWidth = lineWidth
    }

    public var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let pad = w * 0.22

            Path { path in
                path.move(to: CGPoint(x: pad, y: pad))
                path.addLine(to: CGPoint(x: w - pad, y: h - pad))
                path.move(to: CGPoint(x: w - pad, y: pad))
                path.addLine(to: CGPoint(x: pad, y: h - pad))
            }
            .stroke(
                MegaTheme.playerXGradient,
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: MegaTheme.playerXGlow, radius: 4, x: 0, y: 0)
        }
    }
}

public struct OMarkView: View {
    public var lineWidth: CGFloat = 3.5

    public init(lineWidth: CGFloat = 3.5) {
        self.lineWidth = lineWidth
    }

    public var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let pad = w * 0.22

            Circle()
                .inset(by: pad)
                .stroke(
                    MegaTheme.playerOGradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .shadow(color: MegaTheme.playerOGlow, radius: 4, x: 0, y: 0)
        }
    }
}

public struct CellButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { pressed in
                isPressed = pressed
            }
    }
}
