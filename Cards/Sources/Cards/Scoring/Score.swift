protocol Score {
    func score(forCard card: PlayingCard) -> Int
    func score(forCard card: SuitedCard) -> Int
}

extension Score {
    func score(forCard card: PlayingCard) -> Int {
        switch card {
        case .suited(let card, _):
            return score(forCard: card)
        case .joker:
            return 0
        }
    }
    
    func score(forCard card: SuitedCard) -> Int {
        assertionFailure("""
        Default implementation, either implement this method
        or override the score(forCard:PlayingCard) method
        so that this does not get called
        """)
        return 0
    }
}
