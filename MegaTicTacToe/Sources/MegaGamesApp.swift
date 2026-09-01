import SwiftUI
import MegaGamesCore

@main
struct MegaGamesApp: App {
    var body: some Scene {
        WindowGroup {
            MegaGamesContentView()
                .preferredColorScheme(.dark)
        }
    }
}
