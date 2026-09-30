#!/usr/bin/env bash
# Tags the candidate squares and the compass with accessibility identifiers so
# the UI test can find and drag them. Runs on the CI checkout only; it changes
# nothing visible and is never committed.
set -euo pipefail
cd "$(dirname "$0")/../.."

perl -0pi -e 's/\.frame\(width: CANDIDATE_SIZE, height: CANDIDATE_SIZE\)/.frame(width: CANDIDATE_SIZE, height: CANDIDATE_SIZE)\n        .accessibilityElement()\n        .accessibilityLabel(candidate.name)\n        .accessibilityIdentifier("candidate-\\(candidate.name)")/' Compass/CandidateDot.swift

perl -0pi -e 's/\.cornerRadius\(15\)/.cornerRadius(15)\n                    .accessibilityElement()\n                    .accessibilityIdentifier("compass")/' Compass/Compass.swift

grep -q 'accessibilityIdentifier("candidate-' Compass/CandidateDot.swift
grep -q 'accessibilityIdentifier("compass")' Compass/Compass.swift
git --no-pager diff
