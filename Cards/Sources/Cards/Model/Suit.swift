public enum Suit: String, CaseIterable, Equatable, Codable {
    case spades
    case clubs
    case diamonds
    case hearts
}

extension Suit: Comparable {
    public static func < (lhs: Suit, rhs: Suit) -> Bool {
        lhs.compareValue < rhs.compareValue
    }
    
    private var compareValue: Int {
        switch self {
        case .spades: return 0
        case .hearts: return 1
        case .clubs: return 2
        case .diamonds: return 3
        }
    }
}
