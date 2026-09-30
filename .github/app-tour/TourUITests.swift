import UIKit
import XCTest

/// Walks through every chapter of BallotPlay on an iPad in landscape, saving a
/// screenshot at each step. The workflow records the simulator screen meanwhile.
@MainActor
final class TourUITests: XCTestCase {
    private var app: XCUIApplication!
    private var shotIndex = 0

    private lazy var outputDir: URL? = {
        guard let dir = ProcessInfo.processInfo.environment["TOUR_DIR"], !dir.isEmpty else { return nil }
        let url = URL(fileURLWithPath: dir, isDirectory: true)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }()

    private lazy var debugDir: URL? = {
        guard let dir = outputDir?.deletingLastPathComponent().appendingPathComponent("debug") else { return nil }
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    // MARK: - The tour

    func testTour() {
        continueAfterFailure = true
        XCUIDevice.shared.orientation = .landscapeLeft
        app = XCUIApplication()
        app.launch()
        XCUIDevice.shared.orientation = .landscapeLeft
        mark("launch")

        // Welcome sheet
        let welcome = app.staticTexts["Welcome to BallotPlay!"]
        XCTAssertTrue(welcome.waitForExistence(timeout: 20), "welcome sheet")
        pause(2)
        snap("welcome-sheet")
        dumpTree("welcome")
        app.buttons["I'm ready!"].tap()

        // Chapter 1: Plurality
        chapter("plurality")
        XCTAssertTrue(compass.waitForExistence(timeout: 10), "compass")
        pause(1.5)
        snap("plurality-start")
        dumpTree("plurality")
        dismissTip()

        let ids = candidateIDs()
        XCTAssertGreaterThanOrEqual(ids.count, 3, "candidates: \(ids)")
        if ids.count >= 3 {
            arrange([(ids[0], (-0.55, 0.45)), (ids[1], (0.55, 0.45)), (ids[2], (0.0, -0.55))])
            snap("plurality-three-way")
            drag(ids[2], to: (0.0, -0.05), velocity: 200)
            snap("plurality-candidate-moved")
        }

        toggleLeaderboard()
        snap("plurality-absolute-counts")
        toggleLeaderboard()

        stepCandidates(+2)
        snap("plurality-five-candidates")
        stepCandidates(-2)
        pause(1)

        scrollGuideDown()
        snap("plurality-text")
        tapGuideButton("Next")

        // Chapter 2: Spoiler Effect
        waitForTitle("Spoiler Effect")
        chapter("spoiler")
        scrollGuideUp()
        snap("spoiler-start")
        dumpTree("spoiler")
        if let challenger = candidateNear((1, -1)) {
            drag(challenger, to: (0.6, 0.0), velocity: 120)
            snap("spoiler-halfway")
            drag(challenger, to: (0.4, 0.2), velocity: 100)
        }
        waitForText("the most criticized flaw")
        snap("spoiler-effect")
        scrollGuideDown()
        snap("spoiler-explained")
        tapGuideButton("Next")

        // Chapter 3: Instant Runoff
        waitForTitle("An Alternative: Instant Runoff")
        chapter("irv")
        scrollGuideUp()
        snap("irv-start")
        dumpTree("irv")
        stepCandidates(+1)
        let irvIDs = candidateIDs()
        if irvIDs.count >= 4 {
            // Round 1 leader loses: the candidate who starts 3rd wins after transfers.
            arrange([
                (irvIDs[0], (-0.6, 0.5)),
                (irvIDs[1], (-0.6, -0.4)),
                (irvIDs[2], (0.5, -0.3)),
                (irvIDs[3], (-0.15, 0.1)),
            ])
        }
        snap("irv-round-1")
        tapCompassRound("Next")
        snap("irv-round-2")
        tapCompassRound("Next")
        snap("irv-round-3")
        scrollGuideDown()
        snap("irv-text")
        tapGuideButton("How so")

        // Chapter 4: Center Squeeze
        waitForTitle("Center Squeeze")
        chapter("center-squeeze")
        scrollGuideUp()
        snap("center-squeeze-start")
        if let loser = candidateNear((0.35, 0.35)) {
            drag(loser, to: (0.9, 0.9), velocity: 120)
        }
        waitForText("Center Squeeze.")
        snap("center-squeeze-done")
        scrollGuideDown()
        snap("center-squeeze-explained")
        tapGuideButton("Next")

        // Chapter 5: Approval Voting
        waitForTitle("An Outlier: Approval Voting")
        chapter("approval")
        scrollGuideUp()
        snap("approval-start")
        dumpTree("approval")
        slideTolerance(to: 0.12)
        snap("approval-low-tolerance")
        slideTolerance(to: 0.8)
        snap("approval-high-tolerance")
        slideTolerance(to: 0.45)
        if let centrist = candidateNear((-0.15, 0.1)) {
            drag(centrist, to: (0.15, 0.35), velocity: 200)
        }
        snap("approval-candidate-moved")
        scrollGuideDown()
        snap("approval-text")
        tapGuideButton("So, what")
        waitForText("Advocacy for alternative voting")
        snap("whats-next-sheet")
        dismissSheet()

        // Chapter menu
        chapter("menu")
        openChapterMenu()
        snap("chapter-menu")
        let first = app.buttons["The Usual: Plurality"]
        if first.waitForExistence(timeout: 3) {
            first.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
        waitForTitle("The Usual: Plurality")
        scrollGuideUp()
        snap("back-to-plurality")
        mark("end")
    }

    // MARK: - Capture

    private func pause(_ seconds: TimeInterval = 1.2) {
        Thread.sleep(forTimeInterval: seconds)
    }

    private func snap(_ name: String, settle: TimeInterval = 1.0) {
        pause(settle)
        shotIndex += 1
        let fileName = String(format: "%02d-%@", shotIndex, name)
        mark("shot \(fileName)")
        let image = XCUIScreen.main.screenshot().image
        // Redraw so the PNG pixels carry the landscape orientation.
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        let upright = UIGraphicsImageRenderer(size: image.size, format: format).image { _ in
            image.draw(at: .zero)
        }
        if let dir = outputDir, let png = upright.pngData() {
            do {
                try png.write(to: dir.appendingPathComponent(fileName + ".png"))
                return
            } catch {
                print("Could not write \(fileName): \(error)")
            }
        }
        let attachment = XCTAttachment(image: upright)
        attachment.name = fileName
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func chapter(_ name: String) {
        mark("chapter \(name)")
    }

    /// Appends a wall-clock timestamp so the video can be cut per chapter.
    private func mark(_ event: String) {
        guard let dir = debugDir else { return }
        let line = String(format: "%.3f\t%@\n", Date().timeIntervalSince1970, event)
        let url = dir.appendingPathComponent("timeline.tsv")
        if let handle = try? FileHandle(forWritingTo: url) {
            handle.seekToEndOfFile()
            handle.write(line.data(using: .utf8)!)
            try? handle.close()
        } else {
            try? line.write(to: url, atomically: true, encoding: .utf8)
        }
    }

    private func dumpTree(_ name: String) {
        guard let dir = debugDir else { return }
        try? app.debugDescription.write(to: dir.appendingPathComponent(name + ".txt"), atomically: true, encoding: .utf8)
    }

    // MARK: - Compass

    private var compass: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "compass").firstMatch
    }

    private func candidateIDs() -> [String] {
        let query = app.descendants(matching: .any).matching(NSPredicate(format: "identifier BEGINSWITH 'candidate-'"))
        var seen: [String] = []
        for element in query.allElementsBoundByIndex where !seen.contains(element.identifier) {
            seen.append(element.identifier)
        }
        return seen
    }

    private func candidate(_ id: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: id).firstMatch
    }

    /// Screen point for an opinion, mirroring `mindToSpace` in Election.swift.
    private func point(for opinion: (Double, Double)) -> CGPoint {
        let frame = compass.frame
        let half = (frame.width - 40) / 2
        return CGPoint(x: frame.midX + opinion.0 * half, y: frame.midY - opinion.1 * half)
    }

    private func candidateNear(_ opinion: (Double, Double)) -> String? {
        let target = point(for: opinion)
        return candidateIDs().min { a, b in
            distance(candidate(a).frame, target) < distance(candidate(b).frame, target)
        }
    }

    private func distance(_ frame: CGRect, _ p: CGPoint) -> CGFloat {
        hypot(frame.midX - p.x, frame.midY - p.y)
    }

    private func drag(_ id: String, to opinion: (Double, Double), velocity: CGFloat = 300) {
        let element = candidate(id)
        guard element.waitForExistence(timeout: 5) else {
            XCTFail("missing \(id)")
            return
        }
        let from = element.frame
        let target = point(for: opinion)
        let start = element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let end = start.withOffset(CGVector(dx: target.x - from.midX, dy: target.y - from.midY))
        start.press(forDuration: 0.15, thenDragTo: end, withVelocity: XCUIGestureVelocity(velocity), thenHoldForDuration: 0.4)
        pause(0.8)
    }

    /// Moves candidates one by one, never dropping one on top of a candidate that still has to move.
    private func arrange(_ moves: [(String, (Double, Double))]) {
        var pending = moves
        var attempts = 0
        while !pending.isEmpty && attempts < 12 {
            attempts += 1
            let free = pending.firstIndex { move in
                let target = point(for: move.1)
                return !pending.contains { other in
                    other.0 != move.0 && candidate(other.0).frame.insetBy(dx: -10, dy: -10).contains(target)
                }
            }
            if let index = free {
                let move = pending.remove(at: index)
                drag(move.0, to: move.1)
            } else {
                drag(pending[0].0, to: (0.9, -0.9))
            }
        }
    }

    private func dismissTip() {
        for label in ["Close", "Dismiss", "xmark"] {
            let button = app.buttons[label]
            if button.waitForExistence(timeout: 2) {
                button.tap()
                pause(1)
                return
            }
        }
    }

    private func tapCompassRound(_ label: String) {
        let left = compass.frame.minX
        let button = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", label)).allElementsBoundByIndex
            .first { $0.frame.midX > left && $0.isEnabled }
        if let button { button.tap() } else { XCTFail("no compass \(label) button") }
        pause(1.5)
    }

    // MARK: - Guide pane

    private var guide: XCUIElement { app.scrollViews.firstMatch }

    private func scrollGuideDown() {
        guide.swipeUp(velocity: .slow)
        pause(0.8)
        guide.swipeUp(velocity: .slow)
        pause(0.8)
    }

    private func scrollGuideUp() {
        guide.swipeDown(velocity: .fast)
        pause(0.5)
        guide.swipeDown(velocity: .fast)
        pause(0.8)
    }

    /// Taps the lowest matching button in the guide pane (the page's own call to action).
    private func tapGuideButton(_ prefix: String) {
        let right = compass.exists ? compass.frame.minX : app.windows.firstMatch.frame.midX
        let buttons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", prefix)).allElementsBoundByIndex
            .filter { $0.frame.midX < right }
        guard let button = buttons.max(by: { $0.frame.minY < $1.frame.minY }) else {
            XCTFail("no \(prefix) button")
            return
        }
        button.tap()
        pause(1.5)
    }

    private func toggleLeaderboard() {
        let header = app.staticTexts["Candidate"].firstMatch
        guard header.waitForExistence(timeout: 3) else { return }
        // Tap the empty space right of the header: that is the leaderboard background.
        header.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).withOffset(CGVector(dx: 160, dy: 0)).tap()
        pause(1)
    }

    private func stepCandidates(_ delta: Int) {
        let stepper = app.steppers.firstMatch
        guard stepper.waitForExistence(timeout: 3) else { return }
        let named = app.buttons[delta > 0 ? "Increment" : "Decrement"]
        let button = named.exists ? named : stepper.buttons.element(boundBy: delta > 0 ? 1 : 0)
        for _ in 0..<abs(delta) {
            button.tap()
            pause(1)
        }
    }

    private var toleranceNow: CGFloat = 0.49

    private func slideTolerance(to position: CGFloat) {
        let slider = app.sliders.firstMatch
        guard slider.waitForExistence(timeout: 3) else { return }
        let before = slider.value as? String
        // Account for the thumb inset at both ends of the track.
        let width = max(slider.frame.width, 1)
        let inset = 14 / width
        func offset(_ p: CGFloat) -> CGVector { CGVector(dx: inset + p * (1 - 2 * inset), dy: 0.5) }
        let start = slider.coordinate(withNormalizedOffset: offset(toleranceNow))
        let end = slider.coordinate(withNormalizedOffset: offset(position))
        start.press(forDuration: 0.2, thenDragTo: end, withVelocity: XCUIGestureVelocity(150), thenHoldForDuration: 0.3)
        if (slider.value as? String) == before {
            slider.adjust(toNormalizedSliderPosition: position)
        }
        toleranceNow = position
        pause(1)
    }

    private func dismissSheet() {
        let body = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Advocacy for alternative voting'")).firstMatch
        let title = app.staticTexts["So, what's next?"].firstMatch
        if title.exists {
            let start = title.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            // Stay on screen even on an 11-inch iPad (820 pt tall in landscape).
            let room = max(200, app.windows.firstMatch.frame.maxY - title.frame.midY - 20)
            start.press(forDuration: 0.1, thenDragTo: start.withOffset(CGVector(dx: 0, dy: min(500, room))), withVelocity: .fast, thenHoldForDuration: 0)
        }
        if !body.waitForNonExistence(timeout: 4) {
            app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.03, dy: 0.5)).tap()
            _ = body.waitForNonExistence(timeout: 4)
        }
        pause(1.5)
    }

    private func openChapterMenu() {
        let bar = app.navigationBars.firstMatch
        let candidates = ["List", "list.bullet", "Bulleted list"].map { bar.buttons[$0] }
        let button = candidates.first { $0.exists } ?? bar.buttons.element(boundBy: 0)
        // Coordinate taps skip the hittability check that trips on toolbar menus.
        let menuItem = app.buttons["Spoiler Effect"]
        for _ in 0..<3 where !menuItem.exists {
            button.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
            _ = menuItem.waitForExistence(timeout: 3)
        }
        pause(1.5)
    }

    // MARK: - Waiting

    private func waitForTitle(_ title: String) {
        XCTAssertTrue(app.staticTexts[title].firstMatch.waitForExistence(timeout: 10), "title \(title)")
        pause(1)
    }

    private func waitForText(_ fragment: String) {
        let text = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", fragment)).firstMatch
        XCTAssertTrue(text.waitForExistence(timeout: 8), "text \(fragment)")
    }
}
