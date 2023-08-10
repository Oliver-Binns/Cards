import CardsModel
import Combine

public final class Hearts: ObservableObject {
    @Published private(set) var players: [Player]
    var trick: [PlayingCard] {
        players.compactMap(\.selectedCard)
    }

    public init(players: Int) {
        self.players = Deck.hearts(playerCount: players)
            .deal(playerCount: players)
            .map(Player.init)
    }
    
    func isValid(card: PlayingCard) -> Bool {
        false
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        players = try container.decode([Player].self, forKey: .players)
    }
}

extension Hearts: Codable {
    enum CodingKeys: CodingKey {
        case players
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(players, forKey: .players)
    }
}
