import Cards
import SwiftUI

struct SevensTableView: View {
    let table: [Suit: Sevens.Run]
    let style = DefaultStyle()
    
    var body: some View {
        HStack {
            ForEach(0..<Suit.allCases.count) { suitIndex in
                ZStack {
                    ForEach(0..<SuitedCard.allCases.count) { valueIndex in
                        style.front
                            .image(forCard: card(value: valueIndex, suit: suitIndex))
                            .resizable()
                            .scaledToFit()
                            .opacity(table[suit(at: suitIndex)]?
                                        .cards.contains(value(at: valueIndex)) ?? false ? 1 : 0)
                            .padding(.top, 32 * CGFloat(valueIndex))
                    }
                }
            }
        }.padding()
    }
    
    func suit(at index: Int) -> Suit {
        Suit.allCases[index]
    }
                                   
   func value(at index: Int) -> SuitedCard {
        SuitedCard.allCases[index]
    }
    
    func card(value: Int, suit: Int) -> PlayingCard {
        .suited(self.value(at: value), self.suit(at: suit))
    }
}
