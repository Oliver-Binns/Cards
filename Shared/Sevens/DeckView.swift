import Cards
import SwiftUI

struct DeckView: View {
    let deck: Deck
    let style = DefaultStyle()
    
    var body: some View {
        ScrollView {
            ForEach(deck) { card in
                style.front.image(forCard: card)
            }
            .padding()
        }
    }
}
