@testable import Hearts
import XCTest

final class HeartsInitialisationTests: XCTestCase {
    func testCreateHandsFourPlayers() {
        let sut = Hearts(players: 4)
        XCTAssertEqual(sut.players.count, 4)
        sut.players.map(\.hand).forEach {
            XCTAssertEqual($0.count, 13)
        }
    }
    
    func testCreateHandsThreePlayers() {
        let sut = Hearts(players: 3)
        XCTAssertEqual(sut.players.count, 3)
        sut.players.map(\.hand).forEach {
            XCTAssertEqual($0.count, 17)
        }
    }
    
    func testCreateHandsFivePlayers() {
        let sut = Hearts(players: 5)
        XCTAssertEqual(sut.players.count, 5)
        sut.players.map(\.hand).forEach {
            XCTAssertEqual($0.count, 10)
        }
    }
    
    func testCreateHandsSixPlayers() {
        let sut = Hearts(players: 6)
        XCTAssertEqual(sut.players.count, 6)
        sut.players.map(\.hand).forEach {
            XCTAssertEqual($0.count, 8)
        }
    }
}
