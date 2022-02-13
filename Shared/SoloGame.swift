import Cards
import SwiftUI

struct SoloGame: View {
    @State private var game: Game? = .sevens(.init(players: 4))
    let playerIndex: Int = 0
    
    @State var winner: Int? = nil

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
        }
    }
}
