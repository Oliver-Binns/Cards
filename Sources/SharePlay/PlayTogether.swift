import CardsModel
import Foundation
import GroupActivities
import Sevens

struct PlayTogether: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.type = .generic
        metadata.title = game.title
        metadata.subtitle = "Let’s Play! 🃏"
        return metadata
    }

    let game: any Game
    var participantOrder: [UUID] = []
    
    init(game: any Game) {
        self.game = game
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        participantOrder = try values.decode([UUID].self, forKey: .participantOrder)
        
        
        let title = try values.decode(String.self, forKey: .title)
        switch title {
        case "Sevens":
            game = try values.decode(Sevens.self, forKey: .game)
        default:
            preconditionFailure("Unsupported game")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(game.title, forKey: .title)
        try container.encode(game, forKey: .game)
        try container.encode(participantOrder, forKey: .participantOrder)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case game
        case participantOrder
    }
}
