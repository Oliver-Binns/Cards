@testable import Hearts
import XCTest

final class HeartsInitialisationTests: XCTestCase {
    func testCreateHandsFourPlayers() {
        let sut = Hearts(players: 4)
        XCTAssertEqual(sut.hands.count, 4)
        sut.hands.forEach {
            XCTAssertEqual($0.count, 13)
        }
    }
    
    func testCreateHandsThreePlayers() {
        let sut = Hearts(players: 3)
        XCTAssertEqual(sut.hands.count, 3)
        sut.hands.forEach {
            XCTAssertEqual($0.count, 17)
        }
    }
    
    func testCreateHandsFivePlayers() {
        let sut = Hearts(players: 5)
        XCTAssertEqual(sut.hands.count, 5)
        sut.hands.forEach {
            XCTAssertEqual($0.count, 10)
        }
    }
    
    func testCreateHandsSixPlayers() {
        let sut = Hearts(players: 6)
        XCTAssertEqual(sut.hands.count, 6)
        sut.hands.forEach {
            XCTAssertEqual($0.count, 8)
        }
    }
}
