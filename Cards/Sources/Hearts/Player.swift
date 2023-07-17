import CardsModel
import Combine

public final class Player: ObservableObject {
    @Published
    public private(set) var hand: [PlayingCard]
    
    @Published
    public private(set) var selectedCard: PlayingCard?
    
    @Published
    public private(set) var score: Int
    private let scoringSystem = HeartsScore()
    
    var shotForTheMoon: Bool {
        score == 26
    }
    
    init(hand: [PlayingCard]) {
        self.hand = hand
        self.score = 0
    }
    
    func play(card: PlayingCard) {
        guard let index = hand.firstIndex(of: card) else {
            preconditionFailure("Cannot play a card that is not in your hand")
        }
        hand.remove(at: index)
        selectedCard = card
    }
    
    func pickUp(cards: [PlayingCard]) {
        selectedCard = nil
        score = cards
            .map(scoringSystem.score)
            .reduce(score, +)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hand = try container.decode([PlayingCard].self, forKey: .hand)
        score = try container.decode(Int.self, forKey: .score)
    }
}

extension Player: Codable {
    enum CodingKeys: CodingKey {
        case hand
        case score
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hand, forKey: .hand)
        try container.encode(score, forKey: .score)
    }
}
