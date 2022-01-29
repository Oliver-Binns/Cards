import Cards
import Foundation
import GroupActivities

struct PlayTogether: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.type = .generic
        metadata.title = title
        return metadata
    }

    let title: String
    var game: Game?
    var players: [UUID]?
    var names: [UUID: String] = [:]
}
