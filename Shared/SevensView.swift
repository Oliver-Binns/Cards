import Cards
import Combine
import SwiftUI

struct SevensView: View {
    @Binding var game: Sevens
    
    var body: some View {
        VStack {
            Spacer()
            HandView(hand: game.hand(forPlayer: 0)) { card in
                game.play(card: card)
            }
        }
    }
}
