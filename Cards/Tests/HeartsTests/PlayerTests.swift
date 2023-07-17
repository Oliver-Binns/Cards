@testable import Hearts
import XCTest

final class PlayerTests: XCTestCase {
    func testPickUp() {
        let sut = Player(hand: [])
        
        sut.pickUp(cards: [ ])
        XCTAssertEqual(sut.score, 0)
        
        sut.pickUp(cards: [
            .suited(.ace, .hearts),
            .suited(.queen, .hearts)
        ])
        XCTAssertEqual(sut.score, 2)
        
        sut.pickUp(cards: [
            .suited(.ace, .clubs),
            .suited(.queen, .clubs)
        ])
        XCTAssertEqual(sut.score, 2)
        
        sut.pickUp(cards: [
            .suited(.ace, .spades),
            .suited(.queen, .spades)
        ])
        XCTAssertEqual(sut.score, 15)
    }
    
    func testShootForTheMoon() {
        let sut = Player(hand: [])
        
        sut.pickUp(cards: [
            .suited(.king, .hearts),
            .suited(.queen, .hearts),
            .suited(.jack, .hearts),
            .suited(.ten, .hearts),
            .suited(.nine, .hearts),
            .suited(.eight, .hearts),
            .suited(.seven, .hearts),
            .suited(.six, .hearts),
            .suited(.five, .hearts),
            .suited(.four, .hearts),
            .suited(.three, .hearts),
            .suited(.two, .hearts),
            .suited(.ace, .hearts),
            .suited(.queen, .spades)
        ])
        XCTAssertEqual(sut.score, 26)
        XCTAssertTrue(sut.shotForTheMoon)
    }
}

extension PlayerTests {
    func testPlayCard() {
        let sut = Player(hand: [
            .suited(.five, .diamonds),
            .suited(.jack, .spades)
        ])
        
        sut.play(card: .suited(.five, .diamonds))
        XCTAssertEqual(sut.selectedCard, .suited(.five, .diamonds))
        XCTAssertEqual(sut.hand, [.suited(.jack, .spades)])
        
        sut.play(card: .suited(.jack, .spades))
        XCTAssertEqual(sut.selectedCard, .suited(.jack, .spades))
        XCTAssertEqual(sut.hand, [])
    }
}
