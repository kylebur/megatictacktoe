import SwiftUI

public struct GameHubView: View {
    public let onStartGame: () -> Void
    public let onPassAndPlay: () -> Void

    @State private var showTutorial: Bool = false

    public init(
        onStartGame: @escaping () -> Void,
        onPassAndPlay: @escaping () -> Void = {}
    ) {
        self.onStartGame = onStartGame
        self.onPassAndPlay = onPassAndPlay
    }

    public var body: some View {
        ZStack {
            MegaTheme.bgGradient
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header Branding
                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Text("MEGA")
                            .font(.system(size: 30, weight: .black, design: .rounded))
                            .foregroundStyle(MegaTheme.playerXGradient)

                        Text("TICTACTOE")
                            .font(.system(size: 30, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Text("81-Cell Turn-Based iMessage Game")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 16)

                // Main Game Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ULTIMATE 81 CELLS")
                                .font(.system(size: 10, weight: .black, design: .monospaced))
                                .foregroundColor(MegaTheme.activeBoardGlow)

                            Text("Ready to Play?")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        // Glowing Mini Preview Icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.black.opacity(0.4))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(MegaTheme.playerXGlow, lineWidth: 1.5)
                                )

                            XMarkView(lineWidth: 3)
                                .frame(width: 24, height: 24)
                        }
                    }

                    Text("Every move steers where your friend must play next. Plan ahead, capture sub-boards, and claim 3-in-a-row to win!")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.75))
                        .lineSpacing(3)

                    Divider()
                        .background(Color.white.opacity(0.1))

                    // Action Buttons
                    VStack(spacing: 10) {
                        Button(action: onStartGame) {
                            HStack(spacing: 8) {
                                Image(systemName: "message.fill")
                                Text("Start Match in Chat")
                            }
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(MegaTheme.playerXGradient)
                                    .shadow(color: MegaTheme.playerXGlow, radius: 8)
                            )
                        }

                        HStack(spacing: 10) {
                            Button(action: onPassAndPlay) {
                                HStack(spacing: 6) {
                                    Image(systemName: "person.2.fill")
                                    Text("Pass & Play")
                                }
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 11)
                                .glassCard(cornerRadius: 20)
                            }

                            Button {
                                showTutorial = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "book.fill")
                                    Text("How to Play")
                                }
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(MegaTheme.goldColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 11)
                                .glassCard(cornerRadius: 20)
                            }
                        }
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(red: 0.08, green: 0.11, blue: 0.18).opacity(0.85))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(MegaTheme.cardBorder, lineWidth: 1.2)
                        )
                )
                .padding(.horizontal, 16)

                Spacer()
            }
        }
        .sheet(isPresented: $showTutorial) {
            RulesTutorialView()
        }
    }
}
