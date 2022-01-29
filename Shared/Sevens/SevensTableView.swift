import Cards
import SwiftUI

struct SevensTableView: View {
    let table: [Suit: Sevens.Run]
    let namespace: Namespace.ID
    let style = DefaultStyle()
    
    var body: some View {
        HStack {
            ForEach(0..<Suit.allCases.count) { suitIndex in
                ZStack(alignment: .top) {
                    ForEach(0..<SuitedCard.allCases.count) { valueIndex in
                        VStack {
                            if table[suit(at: suitIndex)]?
                                .cards.contains(value(at: valueIndex)) ?? false {
                                style.front
                                    .image(forCard: card(value: valueIndex, suit: suitIndex))
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.top, 16 * CGFloat(valueIndex))
                                    .matchedGeometryEffect(id: card(value: valueIndex, suit: suitIndex),
                                                           in: namespace)
                                    .transition(.move(edge: .top))
                            } else {
                                style.back.image
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0)
                                    .padding(.top, 16 * CGFloat(valueIndex))
                            }
                        }
                    }
                }
            }
        }.padding(.horizontal)
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
