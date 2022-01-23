import Cards
import SwiftUI

struct ContentView: View {
    let style = DefaultStyle()
    let deck = Deck.full.shuffled()
    
    var body: some View {
        ScrollView {
            ForEach(0..<deck.count) { index in
                style.front.image(forCard: deck[index])
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
