import Cards
import SwiftUI

struct DeckView: View {
    let deck: Deck
    let style = DefaultStyle()
    
    var body: some View {
        ScrollView {
            ForEach(0..<deck.count) { index in
                style.front.image(forCard: deck[index])
            }
            .padding()
        }
    }
}
