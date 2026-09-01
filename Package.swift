// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MegaTicTacToeCore",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "MegaTicTacToeCore",
            targets: ["MegaTicTacToeCore"]
        ),
    ],
    targets: [
        .target(
            name: "MegaTicTacToeCore",
            dependencies: [],
            path: "MegaTicTacToeCore/Sources/MegaTicTacToeCore"
        ),
        .testTarget(
            name: "MegaTicTacToeCoreTests",
            dependencies: ["MegaTicTacToeCore"],
            path: "MegaTicTacToeCore/Tests/MegaTicTacToeCoreTests"
        ),
    ]
)
