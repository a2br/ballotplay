"""Turns a raw simctl recording into an upright MP4 trimmed to the tour.

Usage: make_video.py <pass-dir> <out.mp4> [--cut-dark]

--cut-dark drops the moments where the test switched to dark mode for a paired
screenshot, leaving a clean light-mode video: first by the switch times in the
timeline, then by brightness, since the recorder's clock can run a little off
the timeline. Chapter start times in the final video are written next to it as
<out>-chapters.json.
"""
import json
import os
import re
import subprocess
import sys
import tempfile

FFMPEG = os.environ.get("FFMPEG", "ffmpeg")
FPS = 30
ENCODE = ["-r", str(FPS), "-c:v", "libx264", "-preset", "slow", "-crf", "22", "-tune", "stillimage",
          "-movflags", "+faststart", "-an"]


def ffmpeg(*args):
    subprocess.run([FFMPEG, "-hide_banner", "-y", "-loglevel", "error", *args], check=True)


def drop(intervals, t):
    """Time t after removing the given (start, end) intervals before it."""
    return t - sum(min(b, t) - a for a, b in intervals if a < t)


def select_expr(keep, cuts):
    expr = keep
    if cuts:
        expr += "*not(" + "+".join(f"between(t,{a:.3f},{b:.3f})" for a, b in cuts) + ")"
    return f"select='{expr}',setpts=N/{FPS}/TB"


def dark_runs(video, threshold=110, before=0.1, after=0.45):
    """(start, end) spans of dark frames in a light video, widened to cover the fade back to light."""
    with tempfile.NamedTemporaryFile("r", suffix=".txt") as log:
        ffmpeg("-i", video, "-vf", f"scale=64:-2,signalstats,metadata=mode=print:key=lavfi.signalstats.YAVG:file={log.name}",
               "-f", "null", "-")
        frames = re.findall(r"pts_time:([\d.]+)\s+lavfi\.signalstats\.YAVG=([\d.]+)", open(log.name).read())
    runs = []
    for t, luma in ((float(t), float(y)) for t, y in frames):
        if luma >= threshold:
            continue
        if runs and t - runs[-1][1] <= after + 1 / FPS:
            runs[-1][1] = t
        else:
            runs.append([t, t])
    return [(max(0.0, a - before), b + 1 / FPS + after) for a, b in runs]


def main():
    pass_dir, out = sys.argv[1], sys.argv[2]
    cut_dark = "--cut-dark" in sys.argv[3:]

    record_start = float(open(os.path.join(pass_dir, "debug", "record_start.txt")).read())
    events = []
    for line in open(os.path.join(pass_dir, "debug", "timeline.tsv")):
        stamp, name = line.rstrip("\n").split("\t", 1)
        events.append((float(stamp) - record_start, name))

    # simctl stamps are close but not exact: the app's first frame lands just after the launch mark.
    start = next(t for t, n in events if n == "launch") + 0.4
    end = next(t for t, n in events if n == "end") + 0.8

    switches = []
    if cut_dark:
        opened = None
        for t, n in events:
            if n == "appearance dark":
                opened = t
            elif n == "light again" and opened is not None:
                switches.append((opened, t))
                opened = None

    def first_pass_time(t):
        return max(0.0, drop(switches, t) - drop(switches, start))

    # fps first: the recording has a variable frame rate, and select needs evenly spaced frames.
    upright = f"transpose=2,scale=trunc(iw/4)*2:-2,format=yuv420p"
    keep = f"between(t,{start:.3f},{end:.3f})"
    leftovers = []
    if cut_dark:
        with tempfile.TemporaryDirectory() as tmp:
            first = os.path.join(tmp, "first.mp4")
            ffmpeg("-i", os.path.join(pass_dir, "tour.mov"), "-vf", f"fps={FPS},{select_expr(keep, switches)},{upright}",
                   *ENCODE, first)
            leftovers = dark_runs(first)
            ffmpeg("-i", first, "-vf", f"fps={FPS},{select_expr('1', leftovers)}", *ENCODE, out)
    else:
        ffmpeg("-i", os.path.join(pass_dir, "tour.mov"), "-vf", f"fps={FPS},{select_expr(keep, [])},{upright}",
               *ENCODE, out)

    def video_time(t):
        return round(max(0.0, drop(leftovers, first_pass_time(t))), 1)

    chapters = {n.split(" ", 1)[1]: video_time(t) for t, n in events if n.startswith("chapter ")}
    chapters["welcome"] = 0.0
    chapters["duration"] = video_time(end)
    with open(os.path.splitext(out)[0] + "-chapters.json", "w") as f:
        json.dump(chapters, f, indent=2)
    print(out, chapters, f"{len(switches)} switches cut by time, {len(leftovers)} leftover dark runs cut by brightness")


if __name__ == "__main__":
    main()
