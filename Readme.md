# 🖥 Lazy Cinema - Film Streaming Server

This project is a minimal Docker-based web server for serving local film files (`.mp4`, `.mkv`, `.webm`) through a clean, styled HTML interface — including subtitle support and a Smart TV–friendly layout. It also provides a conversion script to handle MKV files with selectable audio and subtitle tracks.

## 🚀 Features

- Dockerized with Nginx + Traefik
- Tailwind UI for large-screen (TV) viewing
- File picker for multiple videos
- Subtitle support via `.vtt`
- `convert.sh` tool for converting `.mkv` → `.mp4` and extracting subtitles
- Simple HTML5 video player with custom buttons for Play/Pause + Fullscreen


<pre>
## 📂 File Structure

<code>
movies/
├── docker-compose.yml         # Docker and Traefik setup
├── Dockerfile                 # Builds the Nginx-based image
├── entrypoint.sh              # Generates index.html dynamically
├── template.html              # Tailwind-powered frontend
├── convert.sh                 # Film converter and subtitle extractor
└── media/                     # Folder for movie files
    ├── output.mp4             # Converted movie file
    └── subs.vtt               # Optional subtitles
</code>
</pre>


## 🛠 Usage

### 1. Convert a film (with audio/subtitle selection)
```bash
chmod +x convert.sh
./convert.sh your_film.mkv
```

### 2. Start the server
```bash
docker compose up --build -d
```

### 3. Watch the film
point your url eg: https://film.connorstansfield.com

### 💬 Notes
	•	Browsers don’t support .mkv well, so convert to .mp4 or .webm.
	•	subs.vtt is the only subtitle format supported for web playback.
	•	Place all video files and subtitles in the media/ directory.

### 📥 Dependencies
	•	ffmpeg (for conversion)
	•	Docker & Docker Compose
	•	Traefik running on your server


