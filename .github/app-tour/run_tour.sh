#!/usr/bin/env bash
# Runs the UI tour once while recording the simulator screen.
#
# Usage: run_tour.sh <out-dir> <light|dark> <paired: 1|0>
#   paired=1  saves every screenshot in light and in dark: the test asks for the
#             switch through <out-dir>/appearance and this script applies it.
#   paired=0  records the video only, in the given appearance.
# Needs UDID set to a booted simulator.
set -uo pipefail
OUT="$1"
MODE="$2"
PAIRED="$3"
mkdir -p "$OUT/screenshots" "$OUT/debug" "$OUT/appearance"

# A fresh install resets TipKit, so every pass starts with the welcome sheet and the tip.
xcrun simctl uninstall "$UDID" dbr.BallotPlay 2> /dev/null || true
xcrun simctl ui "$UDID" appearance "$MODE"

# Apply appearance switches the test requests.
(
  while [ ! -f "$OUT/appearance/stop" ]; do
    if [ -f "$OUT/appearance/request" ]; then
      want=$(cat "$OUT/appearance/request")
      rm -f "$OUT/appearance/request"
      xcrun simctl ui "$UDID" appearance "$want"
      echo "$want" > "$OUT/appearance/ack.tmp" && mv "$OUT/appearance/ack.tmp" "$OUT/appearance/ack"
    fi
    sleep 0.1
  done
) &
WATCH=$!

xcrun simctl io "$UDID" recordVideo --codec=h264 --force "$OUT/tour.mov" 2> "$OUT/debug/record.log" &
REC=$!
# The recorder can take several seconds to start; stamp the moment it does so the video lines up with the timeline.
for _ in $(seq 1 150); do
  grep -q "Recording started" "$OUT/debug/record.log" && break
  sleep 0.2
done
python3 -c 'import time; print(time.time())' > "$OUT/debug/record_start.txt"
sleep 2

SHOTS=1
[ "$PAIRED" = "1" ] || SHOTS=0
TEST_RUNNER_TOUR_DIR="$OUT/screenshots" \
TEST_RUNNER_TOUR_APPEARANCE_DIR="$OUT/appearance" \
TEST_RUNNER_TOUR_PAIRED="$PAIRED" \
TEST_RUNNER_TOUR_SHOTS="$SHOTS" \
  xcodebuild test-without-building \
    -project .github/app-tour/BallotPlayTour.xcodeproj -scheme BallotPlayTour \
    -destination "id=$UDID" -derivedDataPath .github/app-tour/build \
    -resultBundlePath "$OUT/Tour.xcresult"
STATUS=$?

sleep 2
kill -INT "$REC"
wait "$REC"
touch "$OUT/appearance/stop"
wait "$WATCH"
ls -la "$OUT" "$OUT/screenshots"
exit $STATUS
