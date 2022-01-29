import Cards
import Combine
import SwiftUI

struct HandView: View {
    let hand: Hand
    @State private var selectedCard: HandCard?
    
    let style = DefaultStyle()
    
    let namespace: Namespace.ID
    let playCard: (PlayingCard?) -> Void
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack(alignment: .leading) {
                    ForEach(Array(hand
                                    .sorted(by: compareCards(_:_:))
                                    .enumerated()), id: \.element.id) { (index, item) in
                        style.front.image(forCard: item.card)
                            .resizable()
                            .scaledToFit()
                            .overlay(Color.black.blendMode(.multiply).opacity(item.isValid ? 0 : 0.3))
                        .onTapGesture {
                            withAnimation {
                                guard item.isValid else {
                                    selectedCard = nil
                                    return
                                }
                                selectedCard = item
                            }
                        }
                        .padding(.leading, offset(forIndex: index))
                        .rotationEffect(.degrees(angle(forIndex: index)), anchor: .bottom)
                        .offset(x: 0, y: selectedCard == item ? -60 : 0)
                        .matchedGeometryEffect(id: item.card, in: namespace)
                    }
                }
                .padding(40)
                .padding(.top, 60)
            }
            
            if hand.contains(where: { $0.isValid }) {
                Button("Play") {
                    guard let selectedCard = selectedCard else {
                        return
                    }
                    withAnimation {
                        playCard(selectedCard.card)
                        self.selectedCard = nil
                    }
                }
                .tint(.blue)
                .disabled(selectedCard == nil)
                .buttonStyle(.borderedProminent)
            } else {
                Button("Pass") {
                    playCard(nil)
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.vertical)
    }
    
    func angle(forIndex index: Int) -> CGFloat {
        guard hand.count > 1 else {
            return 0
        }
        return CGFloat(index) * 30.0 / CGFloat(hand.count - 1) - 15
    }
    
    func offset(forIndex index: Int) -> CGFloat {
        CGFloat(index) * 10
    }
    
    private func compareCards(_ lhs: HandCard, _ rhs: HandCard) -> Bool {
        compareCards(lhs.card, rhs.card)
    }
    
    private func compareCards(_ lhs: PlayingCard, _ rhs: PlayingCard) -> Bool {
        switch (lhs, rhs) {
        case (.joker, .joker):
            return true
        case (.suited, .joker):
            return true
        case (.joker, .suited):
            return false
        case (.suited(let lhsValue, let lhsSuit), .suited(let rhsValue, let rhsSuit)):
            guard lhsSuit == rhsSuit else {
                return lhsSuit < rhsSuit
            }
            switch AcesLowTrumpChecker().compare(lhsValue, rhsValue) {
            case .lower:
                return true
            default:
                return false
            }
        }
    }
}
