import Cards
import Combine
import SwiftUI

struct SevensView: View {
    @Binding var game: Sevens
    @Binding var playerIndex: Int
    let didPlay: (PlayingCard?) -> Void
    
    var body: some View {
        ZStack {
            VStack {
                SevensTableView(table: game.table)
                Spacer()
                HandView(hand: game.hand(forPlayer: playerIndex)) { card in
                    didPlay(card)
                }
                .disabled(game.currentPlayer != playerIndex)
            }
            if game.currentPlayer != playerIndex {
                Text("Waiting for your turn!")
                    .font(.largeTitle)
                    .foregroundColor(.purple)
            }
        }
        
    }
}
