# App tour

The `App tour` workflow (`.github/workflows/app-tour.yml`) takes screenshots and a
screen recording of BallotPlay on a macOS runner.

1. It generates an Xcode project from `project.yml` using the app's own sources
   (XcodeGen), with an extra UI-test target (`TourUITests.swift`).
2. `instrument.sh` adds accessibility identifiers to the candidate squares and
   the compass so the test can drag them. It only runs on the CI checkout.
3. It boots an iPad simulator in landscape, records the screen with
   `simctl io recordVideo`, and runs the UI test. The test goes through all five
   chapters and saves a screenshot at each step.
4. The full-resolution screenshots, the raw `.mov` recording and a timeline of
   each step are uploaded as the `ballotplay-tour` artifact. Compressed copies
   (JPEG screenshots and an MP4) are committed to `media/` on the same branch.

This folder starts with a dot, so Swift Playgrounds and SwiftPM ignore it. The
app package builds exactly as before.

The simulator is set by `TOUR_DEVICE` in the workflow (currently
"iPad Air 11-inch (M3)").

To run it again, push a change under `.github/app-tour/`, or re-run the latest
`App tour` run from the Actions tab.
