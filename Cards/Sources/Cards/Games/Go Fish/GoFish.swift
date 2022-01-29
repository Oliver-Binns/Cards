import Combine

public final class GoFish: ObservableObject, Codable {
    @Published private var currentPlayer: Int
    @Published private var deck: [PlayingCard]
    @Published private var hands: [[PlayingCard]]
    
    public init(players: Int) {
        var deck = Deck.noJokers.shuffled()
        
        let numberOfCardsPerPlayer = players == 2 ? 7 : 5
        self.hands = deck.deal(playerCount: players, cardsPerPlayer: numberOfCardsPerPlayer)
        self.deck = deck
        
        self.currentPlayer = 0
    }
    
    enum CodingKeys: CodingKey {
        case deck, hands, currentPlayer
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentPlayer, forKey: .currentPlayer)
        try container.encode(hands, forKey: .hands)
        try container.encode(deck, forKey: .deck)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentPlayer = try container.decode(Int.self, forKey: .currentPlayer)
        hands = try container.decode([[PlayingCard]].self, forKey: .hands)
        deck = try container.decode([PlayingCard].self, forKey: .deck)
    }
}
