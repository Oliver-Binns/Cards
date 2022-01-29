import Cards
import SwiftUI

struct SoloGame: View {
    @State private var game: Game = .sevens(.init(players: 1))

    var body: some View {
        GameView(game: $game, playerIndex: 0) { _ in }
    }
}
