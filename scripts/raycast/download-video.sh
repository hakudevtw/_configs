#!/bin/bash

# Raycast Script Command: download the best video (up to 4K) into ~/Downloads.
# Usage: run "Download Video" in Raycast, paste the URL into the argument field, press Enter.

# @raycast.schemaVersion 1
# @raycast.title Download Video
# @raycast.mode compact
# @raycast.packageName Media
# @raycast.icon ⬇️
# @raycast.argument1 { "type": "text", "placeholder": "Video URL" }

# Raycast runs scripts with a minimal PATH, so add Homebrew's.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

url="$1"
case "$url" in
  http*) ;;
  *) echo "Not a URL"; exit 1 ;;
esac

# Fetching the title confirms the URL works and shows what is being downloaded.
title="$(yt-dlp --no-playlist --print title "$url" 2>/dev/null)" || { echo "Could not read the video"; exit 1; }

notify() { osascript -e "display notification \"$1\" with title \"yt-dlp\""; }

# Download in the background so Raycast returns immediately; notify when done.
(
  yt-dlp --no-playlist -f "bv*[height<=2160]+ba" --merge-output-format mkv \
    -o "$HOME/Downloads/%(title)s.%(ext)s" "$url" \
    && notify "Download finished" \
    || notify "Download failed"
) >/dev/null 2>&1 &

echo "Downloading: $title"
