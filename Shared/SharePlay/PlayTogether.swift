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
    var game: Game? = nil
    var players: [UUID]? = nil
    var names: [UUID: String] = [:]
}
