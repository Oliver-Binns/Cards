import CardsModel
import Combine

public final class Hearts: ObservableObject {
    @Published private(set) var hands: [[PlayingCard]]

    public init(players: Int) {
        hands = Deck.hearts(playerCount: players)
            .deal(playerCount: players)
    }
    
    func isValid(card: PlayingCard) -> Bool {
        false
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hands = try container.decode([[PlayingCard]].self, forKey: .hands)
    }
}

extension Hearts: Codable {
    enum CodingKeys: CodingKey {
        case hands
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hands, forKey: .hands)
    }
}
