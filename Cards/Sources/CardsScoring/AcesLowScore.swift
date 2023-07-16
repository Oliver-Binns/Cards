import CardsModel

struct AcesLowScore: Score {
    func score(forCard card: SuitedCard) -> Int {
        switch card {
        case .ace: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten, .jack, .queen, .king: return 10
        }
    }
}

