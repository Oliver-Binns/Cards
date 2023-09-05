import Foundation
/// A non-local player
///
/// This protocol is used to represent both remote players
/// over SharePlay and automated non-human players
public protocol NonLocalPlayer: AnyObject {
    var id: UUID { get }
    var moves: AsyncStream<PlayingCard?> { get }
}
