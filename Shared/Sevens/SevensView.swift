import Cards
import Combine
import SwiftUI

struct SevensView: View {
    let game: Sevens
    let playerIndex: Int
    let didPlay: (PlayingCard?) -> Void
    
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            SevensTableView(table: game.table, namespace: namespace)
            Spacer()
            
            ZStack(alignment: .bottom) {
                HandView(hand: game.hand(forPlayer: playerIndex),
                         namespace: namespace) { card in
                    didPlay(card)
                }
                .disabled(game.currentPlayer != playerIndex)
                
                if game.currentPlayer != playerIndex {
                    HStack(spacing: 8) {
                        ProgressView()
                        Text("Waiting for your turn")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding()
                }
            }
        }
    }
}
