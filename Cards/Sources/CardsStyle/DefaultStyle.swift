import CardsModel

public struct DefaultStyle: CardStyle {
    public var front: FrontStyle = DefaultFront()
    public var back: BackStyle = DefaultBack()
    
    public init() { }
}

public struct DefaultFront: FrontStyle {
    public func imageName(forCard card: PlayingCard) -> String {
        switch card {
        case .joker(.red):
            return "Red Joker"
        case .joker(.black):
            return "Black Joker"
        case .suited(let card, let suit):
            return "\(card.rawValue.capitalized) \(suit.rawValue.capitalized)"
        }
    }
}

public struct DefaultBack: BackStyle {
    public var imageName: String { "Red Reverse" }
}
