import Foundation
import GroupActivities

extension GroupSession: Hashable {
    public static func == (lhs: GroupSession<ActivityType>, rhs: GroupSession<ActivityType>) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
