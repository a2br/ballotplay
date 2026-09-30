# App tour

The `App tour` workflow (`.github/workflows/app-tour.yml`) takes screenshots and a
screen recording of BallotPlay on a macOS runner.

1. It generates an Xcode project from `project.yml` using the app's own sources
   (XcodeGen), with an extra UI-test target (`TourUITests.swift`).
2. `instrument.sh` adds accessibility identifiers to the candidate squares and
   the compass so the test can drag them. It only runs on the CI checkout.
3. It boots an iPad simulator in landscape and runs the UI test twice
   (`run_tour.sh`), recording the screen with `simctl io recordVideo` each time:
   - **Light pass.** The test goes through all five chapters and saves a
     screenshot at each step. After each one it asks the runner to switch the
     simulator to dark mode, saves the same screen as `NN-name-dark.png`, and
     switches back. Light and dark screenshots show the same election.
   - **Dark pass.** The same tour in dark mode, for the dark recording. The
     candidates are random on every launch, so they differ from the light pass.
4. `make_video.py` rotates each recording upright, trims it to the tour and
   cuts the dark switches out of the light one. It also writes chapter start
   times next to each video.
5. Everything is uploaded as the `ballotplay-tour` artifact (full-resolution
   PNGs and raw `.mov` recordings). Compressed copies are committed to `media/`
   on the same branch: JPEG screenshots, `tour.mp4` (light) and `tour-dark.mp4`.

This folder starts with a dot, so Swift Playgrounds and SwiftPM ignore it. The
app package builds exactly as before.

The simulator is set by `TOUR_DEVICE` in the workflow (currently
"iPad Air 11-inch (M3)").

To run it again, push a change under `.github/app-tour/`, or re-run the latest
`App tour` run from the Actions tab.
