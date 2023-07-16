import CardsModel

/// SimpleScore
///
/// A simple scoring system that results in every card being worth the same value of 1.
///
public struct SimpleScore: Score {
    public init() { }
    
    public func score(forCard card: SuitedCard) -> Int {
        1
    }
}
