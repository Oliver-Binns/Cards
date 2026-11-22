//
//  AppStoreScreenshotGenerationTests.swift
//  Tests iOS
//

import XCTest

/// Captures App Store screenshots into `fastlane/screenshots/en-GB` so that
/// `fastlane ios release` can upload them with `deliver`.
///
/// Only runs when `GENERATE_SCREENSHOTS` is set in the test runner's
/// environment (xcodebuild forwards `TEST_RUNNER_GENERATE_SCREENSHOTS`),
/// so regular test runs are unaffected.
final class AppStoreScreenshotGenerationTests: XCTestCase {
    private static let screenshotDirectory = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("fastlane/screenshots/en-GB", isDirectory: true)

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try XCTSkipUnless(
            ProcessInfo.processInfo.environment["GENERATE_SCREENSHOTS"] != nil,
            "Set TEST_RUNNER_GENERATE_SCREENSHOTS to generate App Store screenshots"
        )
        continueAfterFailure = false

        XCUIDevice.shared.orientation = .portrait
        app = XCUIApplication()
        app.launch()
    }

    func testGenerateScreenshots() throws {
        XCTAssertTrue(app.buttons["Play Solo"].waitForExistence(timeout: 10))
        try capture("1-MainMenu")

        app.buttons["Play Solo"].tap()
        XCTAssertTrue(app.navigationBars["Sevens"].waitForExistence(timeout: 10))
        // Play a few rounds so there are cards on the table.
        for _ in 0..<6 {
            playTurn()
        }
        waitForTurn()
        try capture("2-Sevens")

        app.buttons["How to Play"].tap()
        XCTAssertTrue(app.staticTexts["How to Play"].waitForExistence(timeout: 10))
        try capture("3-HowToPlay")
    }

    /// Waits until the computer players have finished and it is our turn.
    private func waitForTurn() {
        _ = app.staticTexts["Waiting for your turn"].waitForNonExistence(timeout: 20)
    }

    private func playTurn() {
        waitForTurn()

        let pass = app.buttons["Pass"]
        if pass.exists {
            pass.tap()
            return
        }

        let play = app.buttons["Play"]
        let playableCards = app.buttons.matching(identifier: "playable-card").allElementsBoundByIndex
        // Cards in the hand overlap, so tap near the leading edge where each
        // card is visible, and stop as soon as one has been selected.
        for card in playableCards.reversed() where !play.isEnabled {
            card.coordinate(withNormalizedOffset: CGVector(dx: 0.15, dy: 0.5)).tap()
        }
        if play.isEnabled {
            play.tap()
        }
    }

    private func capture(_ name: String) throws {
        // Give animations and transitions time to settle.
        Thread.sleep(forTimeInterval: 1)

        let family = UIDevice.current.userInterfaceIdiom == .pad ? "ipad" : "iphone"
        let directory = Self.screenshotDirectory
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        let screenshot = XCUIScreen.main.screenshot()
        try screenshot.pngRepresentation.write(
            to: directory.appendingPathComponent("\(family)-\(name).png"),
            options: .atomic
        )

        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "\(family)-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
