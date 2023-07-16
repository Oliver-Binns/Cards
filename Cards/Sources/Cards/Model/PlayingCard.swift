public enum PlayingCard: Equatable, Hashable, Codable {
    case suited(SuitedCard, Suit)
    case joker(JokerType)
}

extension PlayingCard: Identifiable {
    public var id: Int {
        hashValue
    }
}

public enum JokerType: Codable {
    case red
    case black
}
