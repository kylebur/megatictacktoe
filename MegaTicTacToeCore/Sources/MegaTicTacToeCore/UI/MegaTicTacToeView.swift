import SwiftUI

public enum GameMode: Equatable {
    case iMessage(onSendTurn: (_ engine: MegaTicTacToeEngine) -> Void)
    case passAndPlay

    public static func == (lhs: GameMode, rhs: GameMode) -> Bool {
        switch (lhs, rhs) {
        case (.passAndPlay, .passAndPlay): return true
        case (.iMessage, .iMessage): return true
        default: return false
        }
    }
}

public struct MegaTicTacToeView: View {
    @StateObject public var engine: MegaTicTacToeEngine
    public let mode: GameMode
    public var onExit: (() -> Void)?

    @State private var showTutorial: Bool = false
    @State private var hasPendingMoveToSend: Bool = false

    public init(
        engine: MegaTicTacToeEngine = MegaTicTacToeEngine(),
        mode: GameMode = .passAndPlay,
        onExit: (() -> Void)? = nil
    ) {
        _engine = StateObject(wrappedValue: engine)
        self.mode = mode
        self.onExit = onExit
    }

    public var body: some View {
        ZStack {
            MegaTheme.bgGradient
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Top Navigation / Controls
                HStack {
                    if let onExit = onExit {
                        Button {
                            onExit()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                        }
                    }

                    Spacer()

                    Button {
                        showTutorial = true
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    if case .passAndPlay = mode {
                        Button {
                            withAnimation { engine.reset() }
                        } label: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                // Header & Turn Info
                GameHeaderView(
                    engine: engine,
                    playerXTitle: "Player X",
                    playerOTitle: "Player O"
                )

                // Main Game Board
                MegaBoardView(engine: engine) { boardIndex, cellIndex in
                    handleCellTap(board: boardIndex, cell: cellIndex)
                }
                .padding(.horizontal, 12)

                // Bottom Action Bar
                bottomActionBar
                    .padding(.horizontal)
                    .padding(.bottom, 12)
            }

            // Confetti on win
            if case .won = engine.status {
                ConfettiView()
            }
        }
        .sheet(isPresented: $showTutorial) {
            RulesTutorialView()
        }
    }

    @ViewBuilder
    private var bottomActionBar: some View {
        switch mode {
        case .iMessage(let onSendTurn):
            if hasPendingMoveToSend || engine.status.isTerminal {
                Button {
                    onSendTurn(engine)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "paperplane.fill")
                        Text(engine.status.isTerminal ? "Send Game Result" : "Send Move")
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(MegaTheme.playerXGradient)
                            .shadow(color: MegaTheme.playerXGlow, radius: 10)
                    )
                }
                .transition(.scale.combined(with: .opacity))
            } else {
                Text("Tap any highlighted cell to make your move")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.vertical, 10)
            }

        case .passAndPlay:
            HStack {
                if !engine.moveHistory.isEmpty && !engine.status.isTerminal {
                    Button {
                        _ = engine.undoLastMove()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.uturn.backward")
                            Text("Undo Move")
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .glassCard(cornerRadius: 20)
                    }
                }

                Spacer()

                if engine.status.isTerminal {
                    Button {
                        withAnimation { engine.reset() }
                    } label: {
                        Text("New Match")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(MegaTheme.goldGradient))
                    }
                }
            }
            .frame(height: 44)
        }
    }

    private func handleCellTap(board: Int, cell: Int) {
        let prevFinishedCount = engine.macroBoard.subBoards.filter { $0.isFinished }.count
        let result = engine.makeMove(board: board, cell: cell)

        switch result {
        case .success:
            HapticsManager.playCellTap()
            SoundManager.playMoveSound()

            let newFinishedCount = engine.macroBoard.subBoards.filter { $0.isFinished }.count
            if newFinishedCount > prevFinishedCount {
                HapticsManager.playSubBoardWin()
                SoundManager.playSubBoardWinSound()
            }

            if case .won = engine.status {
                HapticsManager.playMatchWin()
                SoundManager.playMatchWinSound()
            }

            if case .iMessage = mode {
                hasPendingMoveToSend = true
            }

        case .failure:
            HapticsManager.playInvalid()
        }
    }
}
