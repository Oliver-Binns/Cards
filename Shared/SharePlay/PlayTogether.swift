import Cards
import GroupActivities

struct PlayTogether: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.type = .generic
        metadata.title = title
        return metadata
    }
    
    let title: String
    let cards: Deck
}
