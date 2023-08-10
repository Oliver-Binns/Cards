import CardsModel
import CardsScoring

struct HeartsScore: Score {
    func score(forCard card: PlayingCard) -> Int {
        switch card {
        case .suited(_, .hearts):
            return 1
        case .suited(.queen, .spades):
            return 13
        default: return 0
        }
    }
}
