import CardsModel
import Combine

public final class Player: ObservableObject {
    public private(set) var hand: [PlayingCard]
    public private(set) var score: Int
    private let scoringSystem = HeartsScore()
    
    var shotForTheMoon: Bool {
        score == 26
    }
    
    init(hand: [PlayingCard]) {
        self.hand = hand
        self.score = 0
    }
    
    func play(card: PlayingCard) {
        guard let index = hand.firstIndex(of: card) else {
            preconditionFailure("Cannot play a card that is not in your hand")
        }
        hand.remove(at: index)
    }
    
    func pickUp(cards: [PlayingCard]) {
        score = cards
            .map(scoringSystem.score)
            .reduce(score, +)
    }
}
