import UIKit
import Messages
import SwiftUI
import MegaTicTacToeCore

@objc(MessagesViewController)
public class MessagesViewController: MSMessagesAppViewController {
    private var hostingController: UIViewController?
    private var currentEngine: MegaTicTacToeEngine?

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.04, green: 0.06, blue: 0.10, alpha: 1.0)
    }

    // MARK: - Conversation Handling

    public override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        presentController(for: conversation, with: presentationStyle)
    }

    public override func didResignActive(with conversation: MSConversation) {
        super.didResignActive(with: conversation)
    }

    public override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        super.didReceive(message, conversation: conversation)
        presentController(for: conversation, with: presentationStyle)
    }

    public override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        super.didStartSending(message, conversation: conversation)
    }

    public override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        super.didCancelSending(message, conversation: conversation)
    }

    public override func willTransition(to style: MSMessagesAppPresentationStyle) {
        super.willTransition(to: style)
        guard let conversation = activeConversation else { return }
        presentController(for: conversation, with: style)
    }

    public override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        super.didSelect(message, conversation: conversation)
        requestPresentationStyle(.expanded)
        presentController(for: conversation, with: .expanded)
    }

    // MARK: - UI Presentation & Routing

    private func presentController(for conversation: MSConversation, with style: MSMessagesAppPresentationStyle) {
        // Remove existing hosted controller
        hostingController?.willMove(toParent: nil)
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()

        // Check if there is an active message selected with game payload
        if let message = conversation.selectedMessage, let url = message.url, let session = GameStateSerializer.decodeFromURL(url) {
            let engine = GameStateSerializer.restoreEngine(from: session)
            self.currentEngine = engine

            let gameView = MegaTicTacToeView(
                engine: engine,
                mode: .iMessage(onSendTurn: { [weak self] updatedEngine in
                    self?.sendTurnMessage(engine: updatedEngine, session: session, conversation: conversation)
                }),
                onExit: { [weak self] in
                    self?.requestPresentationStyle(.compact)
                }
            )

            let hosted = UIHostingController(rootView: gameView)
            attachHostingController(hosted)
        } else {
            // New game / Hub View in compact mode
            if style == .compact {
                let compactHub = GameHubView(
                    onStartGame: { [weak self] in
                        guard let self = self else { return }
                        self.requestPresentationStyle(.expanded)
                        self.startNewGame(conversation: conversation)
                    },
                    onPassAndPlay: { [weak self] in
                        guard let self = self else { return }
                        self.requestPresentationStyle(.expanded)
                        self.startPassAndPlay()
                    }
                )
                let hosted = UIHostingController(rootView: compactHub)
                attachHostingController(hosted)
            } else {
                // Expanded mode: Fresh Game
                startNewGame(conversation: conversation)
            }
        }
    }

    private func attachHostingController(_ hosted: UIViewController) {
        addChild(hosted)
        hosted.view.frame = view.bounds
        hosted.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hosted.view.backgroundColor = .clear
        view.addSubview(hosted.view)
        hosted.didMove(toParent: self)
        self.hostingController = hosted
    }

    private func startNewGame(conversation: MSConversation) {
        let engine = MegaTicTacToeEngine()
        self.currentEngine = engine

        let gameView = MegaTicTacToeView(
            engine: engine,
            mode: .iMessage(onSendTurn: { [weak self] updatedEngine in
                let newSession = GameStateSerializer.exportSession(from: updatedEngine)
                self?.sendTurnMessage(engine: updatedEngine, session: newSession, conversation: conversation)
            }),
            onExit: { [weak self] in
                self?.requestPresentationStyle(.compact)
            }
        )

        let hosted = UIHostingController(rootView: gameView)
        attachHostingController(hosted)
    }

    private func startPassAndPlay() {
        let engine = MegaTicTacToeEngine()
        self.currentEngine = engine

        let gameView = MegaTicTacToeView(
            engine: engine,
            mode: .passAndPlay,
            onExit: { [weak self] in
                self?.requestPresentationStyle(.compact)
            }
        )

        let hosted = UIHostingController(rootView: gameView)
        attachHostingController(hosted)
    }

    // MARK: - Turn Sending & Snapshot Generation

    private func sendTurnMessage(
        engine: MegaTicTacToeEngine,
        session: GameSessionData,
        conversation: MSConversation
    ) {
        let updatedSession = GameStateSerializer.exportSession(
            from: engine,
            gameId: session.gameId,
            playerXName: session.playerXName,
            playerOName: session.playerOName
        )

        guard let gameUrl = GameStateSerializer.encodeToURL(updatedSession) else {
            return
        }

        let messageSession = conversation.selectedMessage?.session ?? MSSession()
        let message = MSMessage(session: messageSession)
        message.url = gameUrl

        let layout = MSMessageTemplateLayout()
        layout.image = MessageBubbleRenderer.renderBubbleImage(
            engine: engine,
            playerXName: session.playerXName,
            playerOName: session.playerOName
        )

        switch engine.status {
        case .won(let winner, _):
            layout.caption = "🏆 \(winner == .x ? "Player X" : "Player O") Won the Match!"
            layout.subcaption = "Tap to view final board or start a rematch"
            message.summaryText = "🏆 MegaTicTacToe Match Concluded"
        case .draw:
            layout.caption = "🤝 Match Ended in a Draw!"
            layout.subcaption = "Tap to start a rematch"
            message.summaryText = "🤝 MegaTicTacToe Match Draw"
        case .inProgress(let activePlayer, _):
            let nextPlayerName = (activePlayer == .x) ? session.playerXName : session.playerOName
            layout.caption = "🕹️ \(nextPlayerName)'s Turn (\(activePlayer.rawValue))"
            layout.subcaption = (engine.targetSubBoard == nil) ? "Wildcard! Play on any open board" : "Target: Sub-board #\((engine.targetSubBoard ?? 0) + 1)"
            message.summaryText = "🕹️ Your move in MegaTicTacToe!"
        }

        message.layout = layout

        conversation.insert(message) { [weak self] error in
            if error == nil {
                self?.dismiss()
            }
        }
    }
}
