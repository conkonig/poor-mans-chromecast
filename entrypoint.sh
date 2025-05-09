#!/bin/sh

cd /usr/share/nginx/html

# Generate video list
VIDEOS=$(find . -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" \) | sed 's|^./||')

VIDEO_OPTIONS=""
for V in $VIDEOS; do
  MIME=$(file --mime-type -b "$V")
  VIDEO_OPTIONS="$VIDEO_OPTIONS<option value=\"$V\" data-mime=\"$MIME\">$V</option>\n"
  LAST_VIDEO="$V"
  LAST_MIME="$MIME"
done

SUB=""
if [ -f subs.vtt ]; then
  SUB='<track src="subs.vtt" kind="subtitles" srclang="en" label="English" default>'
fi

sed \
  -e "s|{{OPTIONS}}|$VIDEO_OPTIONS|g" \
  -e "s|{{DEFAULT_VIDEO}}|$LAST_VIDEO|g" \
  -e "s|{{DEFAULT_MIMETYPE}}|$LAST_MIME|g" \
  -e "s|{{SUBTITLE_TAG}}|$SUB|g" \
  /template.html > index.html

exec nginx -g 'daemon off;'
