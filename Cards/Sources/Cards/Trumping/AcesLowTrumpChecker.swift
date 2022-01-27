public struct AcesLowTrumpChecker: TrumpChecker {
    public init() { }
    
    public func compare(_ lhs: SuitedCard, _ rhs: SuitedCard) -> ComparisonResult {
        let scoreChecker = AcesLowTrumpScore()
        let difference = scoreChecker.score(forCard: rhs) -
            scoreChecker.score(forCard: lhs)
        
        switch difference {
        case .min..<0:
            return .higher(-difference)
        case .zero:
            return .equal
        default:
            return .lower(difference)
        }
    }
}

struct AcesLowTrumpScore: Score {
    func score(forCard card: SuitedCard) -> Int {
        switch card {
        case .king:
            return 13
        case .queen:
            return 12
        case .jack:
            return 11
        default:
            return AcesLowScore().score(forCard: card)
        }
    }
}
