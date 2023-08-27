import CardsModel
import Foundation
import GroupActivities

final class RemotePlayer: NonLocalPlayer {
    private let id: UUID
    private let messenger: GroupSessionMessenger
    
    init<Activity: GroupActivity>(id: UUID,
                                         session: GroupSession<Activity>) {
        self.id = id
        self.messenger = GroupSessionMessenger(session: session)
    }
    
    var moves: AsyncStream<PlayingCard?> {
        AsyncStream {
            var iterator = self.messenger
                .messages(of: PlayingCard?.self)
                .filter { $0.1.source.id == self.id }
                .map { $0.0 }
                .makeAsyncIterator()
            return await iterator.next()
        }
    }
}
