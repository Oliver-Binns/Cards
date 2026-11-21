import CardsModel
@testable import Hearts
import XCTest

final class HeartsTrickTests: XCTestCase {
    func testTrick() {
        let sut = Hearts(players: 4)
        XCTAssertTrue(sut.trick.isEmpty)
        
        let playerOne = sut.players[0]
        let card = playerOne.hand[0]
        playerOne.play(card: card)
        
        XCTAssertEqual(sut.trick, [card])
    }
}
