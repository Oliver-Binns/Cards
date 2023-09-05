import Foundation

public protocol Game: Codable, ObservableObject {
    var title: String { get }
    
    var winner: Int? { get }
    var players: Int { get }
    
    init(players: Int)
    func play(card: PlayingCard?)
    
    func autoPlayer(index: Int) -> NonLocalPlayer
}
