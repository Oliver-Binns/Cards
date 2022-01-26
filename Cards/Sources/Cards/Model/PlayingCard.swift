public enum PlayingCard: Equatable, Hashable, Codable {
    case suited(SuitedCard, Suit)
    case joker(JokerType)
}

public enum JokerType: Codable {
    case red
    case black
}
