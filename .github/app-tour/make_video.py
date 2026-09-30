"""Turns a raw simctl recording into an upright MP4 trimmed to the tour.

Usage: make_video.py <pass-dir> <out.mp4> [--cut-dark]

--cut-dark drops the moments where the test switched to dark mode for a paired
screenshot, leaving a clean light-mode video. Chapter start times in the final
video are written next to it as <out>-chapters.json.
"""
import json
import os
import subprocess
import sys

pass_dir, out = sys.argv[1], sys.argv[2]
cut_dark = "--cut-dark" in sys.argv[3:]
ffmpeg = os.environ.get("FFMPEG", "ffmpeg")

record_start = float(open(os.path.join(pass_dir, "debug", "record_start.txt")).read())
events = []
for line in open(os.path.join(pass_dir, "debug", "timeline.tsv")):
    stamp, name = line.rstrip("\n").split("\t", 1)
    events.append((float(stamp) - record_start, name))

# simctl stamps are close but not exact: the app's first frame lands just after the launch mark.
start = next(t for t, n in events if n == "launch") + 0.4
end = next(t for t, n in events if n == "end") + 0.8

cuts = []
if cut_dark:
    opened = None
    for t, n in events:
        if n == "appearance dark":
            opened = t
        elif n == "light again" and opened is not None:
            cuts.append((opened, t))
            opened = None


def video_time(t):
    """Where source time t ends up in the trimmed, cut video."""
    removed = sum(min(b, t) - a for a, b in cuts if a < t)
    return max(0.0, t - start - removed)


keep = f"between(t,{start:.2f},{end:.2f})"
if cuts:
    keep += "*not(" + "+".join(f"between(t,{a:.2f},{b:.2f})" for a, b in cuts) + ")"
# fps first: the recording has a variable frame rate, and select needs evenly spaced frames.
vf = f"fps=30,select='{keep}',setpts=N/30/TB,transpose=2,scale=trunc(iw/4)*2:-2,format=yuv420p"
subprocess.run(
    [ffmpeg, "-hide_banner", "-y", "-loglevel", "error", "-i", os.path.join(pass_dir, "tour.mov"),
     "-vf", vf, "-r", "30", "-c:v", "libx264", "-preset", "slow", "-crf", "22", "-tune", "stillimage",
     "-movflags", "+faststart", "-an", out],
    check=True,
)

chapters = {n.split(" ", 1)[1]: round(video_time(t), 1) for t, n in events if n.startswith("chapter ")}
chapters["welcome"] = 0.0
chapters["duration"] = round(video_time(end), 1)
with open(os.path.splitext(out)[0] + "-chapters.json", "w") as f:
    json.dump(chapters, f, indent=2)
print(out, chapters)
