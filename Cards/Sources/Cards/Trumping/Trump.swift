public enum ComparisonResult: Equatable {
    case higher(Int)
    case equal
    case lower(Int)
}

protocol TrumpChecker {
    func compare(_ lhs: SuitedCard, _ rhs: SuitedCard) -> ComparisonResult
}

