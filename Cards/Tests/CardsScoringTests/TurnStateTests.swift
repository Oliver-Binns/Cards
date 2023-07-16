@testable import CardsScoring
import XCTest

final class TurnStateTests: XCTestCase {
    func testInitialPlayerIsZero() {
        XCTAssertEqual(TurnState(playerCount: 2).currentPlayer, 0)
    }
    
    func testAdvanceToNextPlayer() {
        var turnState = TurnState(playerCount: 2)
        turnState.next()
        XCTAssertEqual(turnState.currentPlayer, 1)
    }
    
    func testAdvanceResetsToZero() {
        var turnState = TurnState(playerCount: 2)
        turnState.next()
        turnState.next()
        XCTAssertEqual(turnState.currentPlayer, 0)
    }
}
