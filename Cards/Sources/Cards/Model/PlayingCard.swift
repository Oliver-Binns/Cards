public enum PlayingCard: Equatable {
    case suited(SuitedCard, Suit)
    case joker(JokerType)
}

public enum JokerType {
    case red
    case black
}
