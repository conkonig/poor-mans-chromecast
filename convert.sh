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
echo "🎬 Converting video with audio stream $AUDIO_STREAM..."
ffmpeg -i "$INPUT" -map 0:v:0 -map "$AUDIO_STREAM" -c:v copy -c:a aac -b:a 192k temp_output.mp4

echo "⚡ Optimizing for fast start playback..."
ffmpeg -i temp_output.mp4 -movflags +faststart -c copy media/output.mp4
rm temp_output.mp4

if [ "$SUBS_CHOICE" = "y" ]; then
  echo
  echo "📝 Extracting subtitle stream $SUBS_STREAM..."
  ffmpeg -i "$INPUT" -map "$SUBS_STREAM" media/subs.srt
  ffmpeg -i media/subs.srt media/subs.vtt
  echo "✅ Subtitles saved to media/subs.vtt"
fi

echo
echo "✅ Done! Output saved as media/output.mp4"