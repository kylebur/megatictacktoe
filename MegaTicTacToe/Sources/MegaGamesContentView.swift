import SwiftUI
import MegaGamesCore

struct MegaGamesContentView: View {
    @State private var activeGameMode: GameMode? = nil

    var body: some View {
        ZStack {
            MegaTheme.bgGradient
                .ignoresSafeArea()

            if let mode = activeGameMode {
                MegaTicTacToeView(
                    mode: mode,
                    onExit: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            activeGameMode = nil
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
            } else {
                GameHubView(
                    isInMessagesExtension: false,
                    onSelectMegaTicTacToe: { mode in
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            activeGameMode = mode
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
    }
}
