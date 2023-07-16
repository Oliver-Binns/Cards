import Cards
import SwiftUI

struct SevensTableView: View {
    let table: [Suit: Sevens.Run]
    let namespace: Namespace.ID
    let style = DefaultStyle()
    
    var body: some View {
        HStack {
            ForEach(Suit.allCases, id: \.self) { suit in
                ZStack(alignment: .top) {
                    ForEach(Array(SuitedCard.allCases.enumerated()), id: \.offset) { (index, card) in
                        GeometryReader { geo in
                            VStack {
                                if table[suit]?
                                    .cards.contains(card) ?? false {
                                    style.front
                                        .image(forCard: .suited(card, suit))
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.top, geo.size.width * 0.20 * CGFloat(index))
                                        .matchedGeometryEffect(id: PlayingCard.suited(card, suit), in: namespace)
                                        .transition(.move(edge: .top))
                                } else {
                                    style.back.image
                                        .resizable()
                                        .scaledToFit()
                                        .opacity(0)
                                        .padding(.top, geo.size.width * 0.20 * CGFloat(index))
                                }
                            }.shadow(radius: 4)
                        }
                    }
                }
            }
        }.padding(.horizontal)
    }
}
