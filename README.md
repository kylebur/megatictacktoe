# MegaTicTacToe for iOS & iMessage

A native iOS and iMessage game featuring **Ultimate 81-Cell Tic-Tac-Toe** (a 3×3 master grid of 9 individual Tic-Tac-Toe boards).

Played natively within Apple Messages chats or offline against a built-in smart AI bot.

---

## 🌐 Public Pages (GitHub Pages)

These URLs are configured for App Store Connect submission and public user access:

- **Marketing Page**: [https://kylebur.github.io/megatictacktoe/](https://kylebur.github.io/megatictacktoe/)  
  *(Alternative direct link: [https://kylebur.github.io/megatictacktoe/marketing.html](https://kylebur.github.io/megatictacktoe/marketing.html))*

- **Support & Help Center**: [https://kylebur.github.io/megatictacktoe/support.html](https://kylebur.github.io/megatictacktoe/support.html)  
  *Support Contact: [kyle.burchesky@mac.com](mailto:kyle.burchesky@mac.com)*

- **Privacy Policy**: [https://kylebur.github.io/megatictacktoe/privacy.html](https://kylebur.github.io/megatictacktoe/privacy.html)  
  *(Alternative direct link: [https://kylebur.github.io/megatictacktoe/PrivacyPolicy.html](https://kylebur.github.io/megatictacktoe/PrivacyPolicy.html))*

---

## 🎮 How To Play (Ultimate Tic-Tac-Toe Rules)

1. **The Grid**: The board consists of a 3×3 grid of 9 smaller Tic-Tac-Toe mini-boards (81 cells in total).
2. **Move Direction**: The square chosen inside any mini-board determines which mini-board the next player must play in.
3. **Claiming Boards**: Win three cells in a row inside a mini-board to claim that entire board.
4. **Free Choice**: If sent to a mini-board that is already won or completely full, the player may place their mark in any open cell anywhere on the board.
5. **Winning the Match**: Align three claimed mini-boards in a row (horizontally, vertically, or diagonally) on the master grid to win!

---

## 🛠️ Project Structure

- `MegaTicTacToe.xcodeproj`: Main Xcode project configuring the iOS App and Messages Extension.
- `MegaTicTacToe/`: Host application container for iOS (`com.megatictactoe.MegaTicTacToe`).
- `MegaTicTacToeMessagesExtension/`: iMessage Extension (`MSMessagesAppViewController`) for turn-based gameplay (`com.megatictactoe.MegaTicTacToe.MessagesExtension`).
- `MegaTicTacToeCore/`: Shared Swift Package containing:
  - Game state models and serialization
  - Strategic rule engine and validation
  - MegaAI offline engine with tactical heuristics
  - Glassmorphic SwiftUI design system and haptic feedback
- `docs/`: Web landing, marketing, support, and privacy pages served via GitHub Pages.

---

## 🚀 Building & Running

### Requirements
- macOS Sonoma or later
- Xcode 16 or later
- iOS 16.0+ deployment target

### Running in Simulator
1. Open `MegaTicTacToe.xcodeproj` in Xcode:
   ```bash
   open MegaTicTacToe.xcodeproj
   ```
2. Select the `MegaTicTacToeMessagesExtension` scheme and an iOS Simulator (e.g. iPhone 16 Pro).
3. Press **Run (Cmd + R)**. Xcode will launch the Messages app with MegaTicTacToe embedded.

---

## 📄 License & Privacy
- **Developer**: Kyle Burchesky
- **Support**: `kyle.burchesky@mac.com`
- **Privacy**: Zero ads, zero tracking, zero telemetry.
