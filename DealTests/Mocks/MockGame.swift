import CardsModel

final class MockGame: Game {
    var title: String = "Mock Game"
    var winner: Int?
    var players: Int
    
    private(set) var didPlay: [PlayingCard?] = []
    
    init(players: Int) {
        self.players = players
    }
    
    func play(card: PlayingCard?) {
        didPlay.append(card)
    }
    
    func autoPlayer(index: Int) -> NonLocalPlayer {
        MockPlayer()
    }
}
