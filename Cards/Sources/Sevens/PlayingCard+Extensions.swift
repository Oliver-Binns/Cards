import CardsModel

extension PlayingCard {
    var isSeven: Bool {
        switch self {
        case .suited(.seven, _): return true
        default: return false
        }
    }
}
