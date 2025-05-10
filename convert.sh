#!/bin/bash

INPUT="$1"

if [ -z "$INPUT" ]; then
  echo "Usage: ./convert.sh your_movie.mkv"
  exit 1
fi

# Show stream info
echo "=== Stream info for $INPUT ==="
ffmpeg -i "$INPUT" 2>&1 | grep -E "Stream #[0-9]+:[0-9]+.*(Audio|Subtitle)"

echo
read -p "Enter the stream index for the audio you want (e.g. 0:2): " AUDIO_STREAM
read -p "Do you want to extract subtitles? (y/n): " SUBS_CHOICE

if [ "$SUBS_CHOICE" = "y" ]; then
  read -p "Enter the stream index for the subtitles (e.g. 0:3): " SUBS_STREAM
fi

echo
echo "Select output resolution:"
echo "1) Original quality"
echo "2) 1080p (recommended for Smart TVs)"
echo "3) 720p (better for older TVs or slow connections)"
read -p "Choice (1/2/3): " RES_CHOICE

SCALE_FILTER=""
BITRATE=""

case "$RES_CHOICE" in
  2)
    SCALE_FILTER="-vf scale=1920:-2"
    BITRATE="-b:v 2500k"
    ;;
  3)
    SCALE_FILTER="-vf scale=1280:-2"
    BITRATE="-b:v 1500k"
    ;;
  *)
    echo "➡️  Keeping original resolution"
    ;;
esac

echo
echo "🎬 Transcoding and optimizing for streaming..."

ffmpeg -i "$INPUT" \
  -map 0:v:0 -map "$AUDIO_STREAM" \
  -c:v libx264 $SCALE_FILTER $BITRATE \
  -preset fast \
  -c:a aac -b:a 192k \
  -movflags +faststart \
  media/output.mp4

if [ "$SUBS_CHOICE" = "y" ]; then
  echo
  echo "📝 Extracting subtitle stream $SUBS_STREAM..."
  ffmpeg -i "$INPUT" -map "$SUBS_STREAM" media/subs.srt
  ffmpeg -i media/subs.srt media/subs.vtt
  echo "✅ Subtitles saved to media/subs.vtt"
fi

echo
echo "✅ Done! Final output: media/output.mp4"