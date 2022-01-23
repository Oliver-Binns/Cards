enum ComparisonResult {
    case higher(Int)
    case equal
    case lower(Int)
}

protocol TrumpChecker {
    func compare(_ lhs: SuitedCard, _ rhs: SuitedCard) -> ComparisonResult
}

struct AcesLowTrumpChecker: TrumpChecker {
    func compare(_ lhs: SuitedCard, _ rhs: SuitedCard) -> ComparisonResult {
        return .equal
    }
}
