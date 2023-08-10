import CardsModel
import CardsScoring
import Combine

public final class Sevens: ObservableObject {
    @Published private var turn: TurnState!
    @Published private var hands: [[PlayingCard]]
    @Published public private(set) var table: [Suit: Run]
    
    public var winner: Int? {
        hands.firstIndex(where: \.isEmpty)
    }
    
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
    
    public func play(card: PlayingCard?) {
        if winner == nil,
           let card = card,
           case .suited(let value, let suit) = card,
           isValid(card: card) {
            
            table[suit]?.add(card: value)
            if let index = hands[turn.currentPlayer].firstIndex(of: card) {
                hands[turn.currentPlayer].remove(at: index)
            }
        }
        turn.next()
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        turn = try container.decode(TurnState.self, forKey: .turn)
        hands = try container.decode([[PlayingCard]].self, forKey: .hands)
        table = try container.decode([Suit: Run].self, forKey: .table)
    }
}

extension Sevens: Codable {
    enum CodingKeys: CodingKey {
        case turn, hands, table
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(turn, forKey: .turn)
        try container.encode(hands, forKey: .hands)
        try container.encode(table, forKey: .table)
    }
}
