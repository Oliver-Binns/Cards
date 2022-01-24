public typealias Hand = [HandCard]

public struct HandCard: Identifiable, Equatable {
    public var id: String {
        switch card {
        case .suited(let value, let suit):
            return "\(value)-\(suit)"
        case .joker(let type):
            return "\(type.hashValue)"
        }
    }
    
    public let isValid: Bool
    public let card: PlayingCard
}
