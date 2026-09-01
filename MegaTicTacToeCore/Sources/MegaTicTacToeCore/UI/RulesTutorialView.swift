import SwiftUI

public struct RulesTutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Int = 0

    public init() {}

    private let steps: [(title: String, subtitle: String, icon: String, description: String)] = [
        (
            title: "The 9x9 Mega Grid",
            subtitle: "9 Small Boards in 1 Giant Board",
            icon: "square.grid.3x3.fill",
            description: "The game consists of 9 smaller Tic-Tac-Toe boards arranged inside a large 3x3 macro board, totaling 81 cells."
        ),
        (
            title: "The Steering Rule",
            subtitle: "Your Move Dictates Their Target",
            icon: "location.north.line.fill",
            description: "Wherever you play within a small 3x3 board sends your opponent to that corresponding board on the macro grid! (e.g., top-right cell -> top-right board)."
        ),
        (
            title: "Capturing Sub-Boards",
            subtitle: "3-in-a-Row Claims the Board",
            icon: "crown.fill",
            description: "Get 3-in-a-row within any small board to capture it. It will be stamped with your giant glowing X or O."
        ),
        (
            title: "Wildcard Free Choice",
            subtitle: "Strategic Escape",
            icon: "sparkles",
            description: "If your opponent sends you to a sub-board that has already been won or is completely full, you get a WILDCARD and can play on ANY available board!"
        ),
        (
            title: "Winning the Match",
            subtitle: "The Ultimate Goal",
            icon: "trophy.fill",
            description: "Win 3 captured sub-boards in a row (horizontal, vertical, or diagonal) on the large macro board to claim victory!"
        )
    ]

    public var body: some View {
        ZStack {
            MegaTheme.bgGradient
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Top bar
                HStack {
                    Text("How to Play")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)

                // Step content card
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { idx in
                        let step = steps[idx]
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(MegaTheme.playerXGradient.opacity(0.15))
                                    .frame(width: 90, height: 90)

                                Image(systemName: step.icon)
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundStyle(MegaTheme.playerXGradient)
                            }
                            .padding(.top, 20)

                            VStack(spacing: 6) {
                                Text("Step \(idx + 1) of \(steps.count)")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(MegaTheme.activeBoardGlow)

                                Text(step.title)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)

                                Text(step.subtitle)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(MegaTheme.goldColor)
                            }

                            Text(step.description)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.85))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 24)

                            Spacer()
                        }
                        .glassCard(cornerRadius: 24)
                        .padding(.horizontal, 16)
                        .tag(idx)
                    }
                }
                #if os(iOS)
                .tabViewStyle(.page(indexDisplayMode: .always))
                #else
                .tabViewStyle(.automatic)
                #endif

                // Bottom navigation button
                Button {
                    if currentStep < steps.count - 1 {
                        withAnimation { currentStep += 1 }
                    } else {
                        dismiss()
                    }
                } label: {
                    Text(currentStep < steps.count - 1 ? "Next Step" : "Got It, Let's Play!")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(MegaTheme.playerXGradient)
                        )
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 20)
            }
        }
    }
}
