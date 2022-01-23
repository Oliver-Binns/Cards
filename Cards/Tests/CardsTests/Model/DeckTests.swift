import XCTest
@testable import Cards

final class DeckTests: XCTestCase {
    func testStandardDecks() {
        XCTAssertEqual(Deck.noJokers.count, 52)
        XCTAssertEqual(Deck.full.count, 54)
    }
    
    func testDealWithEqualNumber() {
        let hands: [[PlayingCard]] = [
            [.suited(.seven, .clubs)],
            [.suited(.jack, .diamonds)],
            [.suited(.five, .hearts)]
        ]
        
        XCTAssertEqual(hands.flatMap { $0 }.deal(playerCount: 3), hands)
    }
    
    func testDealWithUnequalNumber() {
        let hands: [[PlayingCard]] = [
            [.suited(.seven, .clubs), .joker(.red)],
            [.suited(.jack, .diamonds), .suited(.seven, .spades)],
            [.suited(.five, .hearts)]
        ]
        
        XCTAssertEqual(hands.flatMap { $0 }.deal(playerCount: 3), hands)
    }
    
    func testDealWholeDeckWithEqualNumber() {
        XCTAssertEqual(Deck.noJokers.deal(playerCount: 4).map(\.count),
                       [13, 13, 13, 13])
    }
    
    func testDealWholeDeckWithUnequalNumber() {
        XCTAssertEqual(Deck.noJokers.deal(playerCount: 3).map(\.count),
                       [18, 17, 17])
    }
}
