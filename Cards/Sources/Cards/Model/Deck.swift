public typealias Deck = [PlayingCard]

extension Array where Element == PlayingCard {
    public static var full: Deck {
        noJokers + [.joker(.red), .joker(.black)]
    }
                    
    public static var noJokers: Deck {
        Suit.allCases.flatMap { suit in
            SuitedCard.allCases.map { card in
                PlayingCard.suited(card, suit)
            }
        }
    }
    
    public func deal(playerCount: Int) -> [[PlayingCard]] {
        let leastCount = count / playerCount
        let remainder = count % playerCount
        
        var deck = self
        var dealtCards: [[PlayingCard]] = []
        
        for i in 0..<playerCount {
            let extraCard: Bool = i < remainder
            let dealCount = leastCount + (extraCard ? 1 : 0)
            let playersHand = Array(deck.prefix(dealCount))
            dealtCards.append(playersHand)
            deck.removeFirst(dealCount)
        }
        
        return dealtCards
    }
}
