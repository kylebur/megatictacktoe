import Foundation
#if canImport(UIKit)
import UIKit

public enum MessageBubbleRenderer {
    /// Generates a crisp, retina preview image of the current MegaTicTacToe match state for iMessage bubbles
    @MainActor
    public static func renderBubbleImage(
        engine: MegaTicTacToeEngine,
        playerXName: String = "Player X",
        playerOName: String = "Player O",
        size: CGSize = CGSize(width: 600, height: 400)
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let ctx = context.cgContext

            // 1. Background gradient
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bgColors = [
                UIColor(red: 0.04, green: 0.06, blue: 0.10, alpha: 1.0).cgColor,
                UIColor(red: 0.08, green: 0.11, blue: 0.18, alpha: 1.0).cgColor
            ] as CFArray
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: bgColors, locations: [0.0, 1.0]) {
                ctx.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }

            // 2. Render Board on Left/Center
            let boardSize: CGFloat = 340
            let boardOrigin = CGPoint(x: 30, y: (size.height - boardSize) / 2)
            let subSize = boardSize / 3

            for b in 0..<9 {
                let brow = CGFloat(b / 3)
                let bcol = CGFloat(b % 3)
                let subOrigin = CGPoint(
                    x: boardOrigin.x + bcol * subSize,
                    y: boardOrigin.y + brow * subSize
                )
                let subRect = CGRect(origin: subOrigin, size: CGSize(width: subSize, height: subSize)).insetBy(dx: 4, dy: 4)

                let subBoard = engine.macroBoard.subBoards[b]
                let isActive = (engine.targetSubBoard == b || (engine.targetSubBoard == nil && !subBoard.isFinished))

                // Sub-board background
                ctx.saveGState()
                let subPath = UIBezierPath(roundedRect: subRect, cornerRadius: 8)
                if isActive {
                    ctx.setFillColor(UIColor(red: 0.10, green: 0.14, blue: 0.22, alpha: 1.0).cgColor)
                    ctx.setStrokeColor(UIColor(red: 0.0, green: 0.95, blue: 0.8, alpha: 0.9).cgColor)
                    ctx.setLineWidth(2.0)
                } else {
                    ctx.setFillColor(UIColor(red: 0.06, green: 0.08, blue: 0.12, alpha: 0.8).cgColor)
                    ctx.setStrokeColor(UIColor(white: 1.0, alpha: 0.1).cgColor)
                    ctx.setLineWidth(0.8)
                }
                subPath.fill()
                subPath.stroke()
                ctx.restoreGState()

                // If captured, draw big winner mark
                if case .won(let winner, _) = subBoard.state {
                    drawBigMark(winner: winner, in: subRect, context: ctx)
                    continue
                }

                // Draw 9 cells inside sub-board
                let cellSize = subRect.width / 3
                for c in 0..<9 {
                    let crow = CGFloat(c / 3)
                    let ccol = CGFloat(c % 3)
                    let cellRect = CGRect(
                        x: subRect.minX + ccol * cellSize,
                        y: subRect.minY + crow * cellSize,
                        width: cellSize,
                        height: cellSize
                    ).insetBy(dx: 2, dy: 2)

                    let cellState = subBoard.cells[c]
                    if cellState == .x {
                        drawMiniX(in: cellRect, context: ctx)
                    } else if cellState == .o {
                        drawMiniO(in: cellRect, context: ctx)
                    }
                }
            }

            // 3. Right Info Panel
            let panelX: CGFloat = 395
            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 22, weight: .black),
                .foregroundColor: UIColor.white
            ]
            let title = "MEGATICTACTOE"
            (title as NSString).draw(at: CGPoint(x: panelX, y: 55), withAttributes: titleAttrs)

            // Subtitle / Status
            let statusText: String
            let statusColor: UIColor
            switch engine.status {
            case .won(let winner, _):
                statusText = "🏆 \(winner == .x ? playerXName : playerOName) Won!"
                statusColor = UIColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 1.0)
            case .draw:
                statusText = "Match Draw"
                statusColor = UIColor.white
            case .inProgress(let turn, _):
                let name = (turn == .x) ? playerXName : playerOName
                statusText = "\(name)'s Turn (\(turn.rawValue))"
                statusColor = (turn == .x)
                    ? UIColor(red: 0.0, green: 0.95, blue: 1.0, alpha: 1.0)
                    : UIColor(red: 1.0, green: 0.3, blue: 0.5, alpha: 1.0)
            }

            let statusAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: statusColor
            ]
            (statusText as NSString).draw(at: CGPoint(x: panelX, y: 95), withAttributes: statusAttrs)

            // Players summary
            let p1Attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: UIColor(red: 0.0, green: 0.95, blue: 1.0, alpha: 1.0)
            ]
            ("X: \(playerXName)" as NSString).draw(at: CGPoint(x: panelX, y: 160), withAttributes: p1Attrs)

            let p2Attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: UIColor(red: 1.0, green: 0.3, blue: 0.5, alpha: 1.0)
            ]
            ("O: \(playerOName)" as NSString).draw(at: CGPoint(x: panelX, y: 190), withAttributes: p2Attrs)

            // Tap to Play Badge
            let badgeRect = CGRect(x: panelX, y: 280, width: 170, height: 44)
            let badgePath = UIBezierPath(roundedRect: badgeRect, cornerRadius: 22)
            ctx.saveGState()
            ctx.setFillColor(UIColor(red: 0.0, green: 0.95, blue: 1.0, alpha: 1.0).cgColor)
            badgePath.fill()
            ctx.restoreGState()

            let btnAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 15, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            ("TAP TO PLAY ➔" as NSString).draw(at: CGPoint(x: panelX + 22, y: 292), withAttributes: btnAttrs)
        }
    }

    private static func drawBigMark(winner: Player, in rect: CGRect, context: CGContext) {
        let pad = rect.width * 0.2
        let drawRect = rect.insetBy(dx: pad, dy: pad)

        context.saveGState()
        if winner == .x {
            context.setStrokeColor(UIColor(red: 0.0, green: 0.95, blue: 1.0, alpha: 1.0).cgColor)
            context.setLineWidth(6)
            context.setLineCap(.round)
            context.move(to: CGPoint(x: drawRect.minX, y: drawRect.minY))
            context.addLine(to: CGPoint(x: drawRect.maxX, y: drawRect.maxY))
            context.move(to: CGPoint(x: drawRect.maxX, y: drawRect.minY))
            context.addLine(to: CGPoint(x: drawRect.minX, y: drawRect.maxY))
            context.strokePath()
        } else {
            context.setStrokeColor(UIColor(red: 1.0, green: 0.28, blue: 0.45, alpha: 1.0).cgColor)
            context.setLineWidth(6)
            context.strokeEllipse(in: drawRect)
        }
        context.restoreGState()
    }

    private static func drawMiniX(in rect: CGRect, context: CGContext) {
        let pad = rect.width * 0.2
        let drawRect = rect.insetBy(dx: pad, dy: pad)
        context.saveGState()
        context.setStrokeColor(UIColor(red: 0.0, green: 0.95, blue: 1.0, alpha: 1.0).cgColor)
        context.setLineWidth(2.5)
        context.setLineCap(.round)
        context.move(to: CGPoint(x: drawRect.minX, y: drawRect.minY))
        context.addLine(to: CGPoint(x: drawRect.maxX, y: drawRect.maxY))
        context.move(to: CGPoint(x: drawRect.maxX, y: drawRect.minY))
        context.addLine(to: CGPoint(x: drawRect.minX, y: drawRect.maxY))
        context.strokePath()
        context.restoreGState()
    }

    private static func drawMiniO(in rect: CGRect, context: CGContext) {
        let pad = rect.width * 0.2
        let drawRect = rect.insetBy(dx: pad, dy: pad)
        context.saveGState()
        context.setStrokeColor(UIColor(red: 1.0, green: 0.28, blue: 0.45, alpha: 1.0).cgColor)
        context.setLineWidth(2.5)
        context.strokeEllipse(in: drawRect)
        context.restoreGState()
    }
}
#endif
