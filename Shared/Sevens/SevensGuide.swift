import SwiftUI

struct SevensGuide: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text("Sevens").font(.largeTitle)
                Text("How to Play").font(.headline).padding(.bottom, 16)
                
                Text("""
                The deck is dealt out amongst all the available players.
                
                ♦️ Each game begins with the seven of diamonds, whoever is dealt this card will start.
                
                Each turn players get chance to add one card to the table. Sevens can be added to the table on any turn. Other cards can be added in descending or ascending order from the seven of the same suit, once it has been played. If you cannot play any cards, you must pass.
                
                🏆 The winner is the player who gets rid of all their cards first.
                """).font(.system(.body, design: .serif))
                Spacer()
            }.padding()
        }
    }
}
