import CardsModel
import CardsScoring

extension Sevens {
    public struct Run: Codable, Equatable {
        private(set) public var cards: [SuitedCard] = []
        private var trumpChecker: AcesLowTrumpChecker { AcesLowTrumpChecker() }
        
        func canAddCard(card: SuitedCard) -> Bool {
            guard let lowestCard = cards.first,
                  let highestCard = cards.last else {
                      // no cards entered already, only seven is valid!
                      return card == .seven
                  }
            return trumpChecker.compare(card, lowestCard) == .lower(1) ||
                trumpChecker.compare(card, highestCard) == .higher(1)
        }
        
        mutating func add(card: SuitedCard) {
            guard canAddCard(card: card) else {
                assertionFailure("Invalid move attempted")
                return
            }
            switch trumpChecker.compare(card, .seven) {
            case .lower: // insert at start
                cards.insert(card, at: 0)
            case .equal, .higher: // append to end
                cards.append(card)
            }
        }
    }
}
