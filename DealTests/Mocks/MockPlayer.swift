import CardsModel
import Foundation

final class MockPlayer: NonLocalPlayer {
    let id: UUID = UUID()
    let moves: AsyncStream<PlayingCard?> = {
        AsyncStream { continuation in
            continuation.yield(.joker(.red))
        }
    }()
}
