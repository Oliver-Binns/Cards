import CardsModel
@testable import Hearts
import XCTest

final class PlayingCardTests: XCTestCase {
    func testIsHeart() {
        SuitedCard.allCases.forEach { type in
            XCTAssertFalse(PlayingCard.suited(type, .clubs).isHeart)
            XCTAssertFalse(PlayingCard.suited(type, .diamonds).isHeart)
            XCTAssertFalse(PlayingCard.suited(type, .spades).isHeart)
            XCTAssertTrue(PlayingCard.suited(type, .hearts).isHeart)
        }
    }
}
