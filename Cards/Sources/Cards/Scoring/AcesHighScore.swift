struct AcesHighScore: Score {
    func score(forCard card: SuitedCard) -> Int {
        switch card {
        case .ace: return 11
        default: return AcesLowScore().score(forCard: card)
        }
    }
}
