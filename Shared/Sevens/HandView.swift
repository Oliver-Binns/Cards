import CardsModel
import CardsScoring
import CardsStyle
import Combine
import SwiftUI

struct HandView: View {
    let hand: Hand
    let isDisabled: Bool
    @State private var selectedCard: HandCard?
    
    let style = DefaultStyle()
    
    let namespace: Namespace.ID
    let playCard: (PlayingCard?) -> Void
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .leading) {
                        ForEach(Array(hand
                                        .sorted(by: compareCards(_:_:))
                                        .enumerated()), id: \.element.id) { (index, item) in
                            Button {
                                withAnimation {
                                    guard item.isValid else {
                                        selectedCard = nil
                                        return
                                    }
                                    selectedCard = item
                                }
                            } label: {
                                ZStack {
                                    style.front.image(forCard: item.card)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 4)
                                    
                                    style.blank
                                        .resizable()
                                        .scaledToFit()
                                        .colorInvert()
                                        .opacity(item.isValid ? 0 : 0.5)
                                }
                            }
                            .buttonStyle(.borderless)
                            .rotationEffect(.degrees(angle(forIndex: index)), anchor: anchorPoint(forIndex: index))
                            .padding(.leading, CGFloat(index) * geo.size.height * 0.07)
                            .offset(x: 0, y: selectedCard == item ? -geo.size.height / 4 : 0)
                            .matchedGeometryEffect(id: item.card, in: namespace)
                        }
                    }
                    .disabled(isDisabled)
                    .padding(geo.size.height / 8)
                    .padding(.top, geo.size.height / 3)
                }
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
    
    func anchorPoint(forIndex index: Int) -> UnitPoint {
        angle(forIndex: index) < 0 ? .bottomTrailing : .bottomLeading
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

#if DEBUG
struct HandViewPreview: PreviewProvider {
    @Namespace private static var namespace
    
    static var previews: some View {
        HandView(hand: [
            .init(isValid: false, card: .joker(.red)),
            .init(isValid: true, card: .suited(.ace, .spades)),
            .init(isValid: true, card: .suited(.king, .diamonds)),
            .init(isValid: false, card: .joker(.black)),
            
        ],
                 isDisabled: false,
                 namespace: namespace,
                 playCard: { _ in })
    }
}
#endif
