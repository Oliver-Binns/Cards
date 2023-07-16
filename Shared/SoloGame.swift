import Cards
import Sevens
import SwiftUI

struct SoloGame: View {
    let playerIndex: Int = 0
    @State var winner: Int? = nil
    @State private var game: Game?

    var body: some View {
        GameView(game: $game,
                 playerIndex: playerIndex,
                 computerPlayer: SevensPlayer.chooseCard) { winner in
            self.winner = winner
        }.overlay {
            VStack {
                if let winner = winner {
                    if winner == playerIndex {
                        WinnerView()
                    } else {
                        LoserView()
                    }
                } else {
                    EmptyView()
                }
            }.onTapGesture {
                withAnimation {
                    self.winner = nil
                    self.game = .sevens(.init(players: 4))
                }
            }
        }.onAppear {
            game = .sevens(.init(players: 4))
        }
    }
}
