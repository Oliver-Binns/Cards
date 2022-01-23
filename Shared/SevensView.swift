import Cards
import SwiftUI

struct SevensView: View {
    @Binding var game: Sevens
    
    var body: some View {
        DeckView(deck: game.hands[0])
    }
}
