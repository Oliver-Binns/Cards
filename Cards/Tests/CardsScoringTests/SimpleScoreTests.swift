import CardsModel
import CardsScoring
import XCTest

final class SimpleScoreTests: XCTestCase {
    func testScore() {
        let sut = SimpleScore()
        
        SuitedCard.allCases.forEach { cardType in
            XCTAssertEqual(sut.score(forCard: cardType), 1)
        }
    }
}
