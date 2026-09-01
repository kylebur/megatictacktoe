import Foundation
#if canImport(UIKit)
import UIKit
import AudioToolbox

@MainActor
public enum HapticsManager {
    public static func playCellTap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    public static func playSubBoardWin() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred(intensity: 1.0)
    }

    public static func playMatchWin() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }

    public static func playInvalid() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}

public enum SoundManager {
    public static func playMoveSound() {
        // System pop / tap sound
        AudioServicesPlaySystemSound(1104)
    }

    public static func playSubBoardWinSound() {
        // Crisp chime / bell sound
        AudioServicesPlaySystemSound(1025)
    }

    public static func playMatchWinSound() {
        // Fanfare / victory sound
        AudioServicesPlaySystemSound(1026)
    }
}
#else
public enum HapticsManager {
    public static func playCellTap() {}
    public static func playSubBoardWin() {}
    public static func playMatchWin() {}
    public static func playInvalid() {}
}

public enum SoundManager {
    public static func playMoveSound() {}
    public static func playSubBoardWinSound() {}
    public static func playMatchWinSound() {}
}
#endif
