public struct Sevens: Codable, Equatable {
    private var turn: TurnState!
    private var hands: [[PlayingCard]]
    
    public private(set) var table: [Suit: Run]
    
    var scores: [Int] {
        hands.map {
            $0.map(SimpleScore().score).reduce(0, +)
        }
    }
    
    public var currentPlayer: Int {
        turn.currentPlayer
    }
    
    public init(players: Int) {
        hands = Deck.noJokers.shuffled().deal(playerCount: players)
        table = Suit.allCases.reduce(into: [:], { $0[$1] = Run() })
        
        let startingPlayer = hands.firstIndex { $0.contains(where: isValid(card:)) } ?? 0
        turn = TurnState(playerCount: players, startPlayer: startingPlayer)
    }
    
    public func hand(forPlayer player: Int) -> Hand {
        hands[player].map { .init(isValid: isValid(card: $0), card: $0) }
    }
    
    private func isValid(card: PlayingCard) -> Bool {
        switch card {
        case .suited(.seven, .diamonds):
            return true
        case .suited(let value, let suit):
            return table.filter(\.value.cards.isEmpty).count != 4 &&
                table[suit]?.canAddCard(card: value) ?? false
        case .joker:
            assertionFailure("Jokers shouldn't be present while playing Sevens.")
            return false
        }
    }
    
    public mutating func play(card: PlayingCard?) {
        if let card = card,
           case .suited(let value, let suit) = card,
           isValid(card: card) {
            
            table[suit]?.add(card: value)
            if let index = hands[turn.currentPlayer].firstIndex(of: card) {
                hands[turn.currentPlayer].remove(at: index)
            }
        }
        turn.next()
    }
}

extension PlayingCard {
    var isSeven: Bool {
        switch self {
        case .suited(.seven, _): return true
        default: return false
        }
    }
}
