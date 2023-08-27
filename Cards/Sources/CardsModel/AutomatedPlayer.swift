/// A non-local player
///
/// This protocol is used to represent both remote players
/// over SharePlay and automated non-human players
public protocol NonLocalPlayer: AnyObject {
    var moves: AsyncStream<PlayingCard?> { get }
}
