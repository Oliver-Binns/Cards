import CardsModel
@testable import Sevens
import XCTest

final class PlayingCardTests: XCTestCase {
    func testIsSeven() {
        XCTAssertTrue(PlayingCard.suited(.seven, .clubs).isSeven)
        XCTAssertTrue(PlayingCard.suited(.seven, .diamonds).isSeven)
        XCTAssertTrue(PlayingCard.suited(.seven, .hearts).isSeven)
        XCTAssertTrue(PlayingCard.suited(.seven, .spades).isSeven)
        
        XCTAssertFalse(PlayingCard.suited(.king, .clubs).isSeven)
        XCTAssertFalse(PlayingCard.suited(.nine, .clubs).isSeven)
        XCTAssertFalse(PlayingCard.suited(.eight, .clubs).isSeven)
        XCTAssertFalse(PlayingCard.suited(.six, .clubs).isSeven)
        XCTAssertFalse(PlayingCard.suited(.five, .clubs).isSeven)
        XCTAssertFalse(PlayingCard.suited(.ace, .clubs).isSeven)
    }
}
