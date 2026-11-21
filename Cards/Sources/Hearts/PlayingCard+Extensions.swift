import CardsModel

extension PlayingCard {
    var isHeart: Bool {
        switch self {
        case .suited(_, .hearts): return true
        default: return false
        }
    }
}
