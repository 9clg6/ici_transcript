
![IciTranscript](https://github.com/user-attachments/assets/0bf3385c-9a50-47c3-9bdb-bf5ae8d7bda6)

# IciTranscript

**Real-time voice transcription for macOS — 100% local, zero cloud.**

IciTranscript captures your microphone and system audio simultaneously, transcribes everything in real time using on-device MLX models, and optionally generates an AI summary — all without sending a single byte to the cloud.

---

## Features

- **Real-time transcription** — see your words appear as you speak, powered by [voxmlx](https://github.com/T0mSIlver/voxmlx) and Apple Silicon MLX
- **Dual audio capture** — microphone + system audio (meetings, videos, calls) captured and mixed simultaneously
- **Session history** — every transcription is automatically saved and instantly visible in the sidebar
- **AI summaries** — get a concise summary of any session using a local [Mistral](https://mistral.ai) model — Ollama and the model are downloaded automatically on first use, no setup required
- **Export** — copy transcript to clipboard or export as Markdown / plain text
- **100% local & private** — your audio never leaves your Mac; no accounts, no subscriptions, no telemetry
- **Keyboard shortcuts** — start/stop recording from anywhere on your system
- **Clean, native macOS UI** — built with Flutter, feels at home on macOS 13+

---

## Minimum Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| macOS | 13 Ventura | 14 Sonoma or later |
| Chip | Apple M1 | Apple M2 / M3 |
| RAM | 8 GB | 16 GB |
| Disk | 5 GB free | 10 GB free |

> **Why Apple Silicon?** The transcription engine uses MLX, Apple's machine learning framework optimised for the M-series neural engine. Intel Macs are not supported.

### AI Summaries

Enable the summary toggle before stopping a session. On first use, the app automatically:

1. Downloads the Ollama runtime (~50 MB)
2. Pulls the Mistral model (~4 GB) — **one-time download, progress shown in the app**

After that, summaries are generated entirely on your Mac with no internet connection required. Everything is stored in `~/Library/Application Support/IciTranscript/`.

---

## Installation

1. **Download** the DMG from [GitHub Releases](../../releases)
2. **Drag** IciTranscript into your Applications folder
3. **Right-click › Open** on first launch (Gatekeeper warning — the app is ad-hoc signed)
4. Grant **Microphone** and **Screen Recording** permissions when prompted

`uv` (the Python package manager used to run the transcription server) is installed automatically on first launch.

---

## Development

### Prerequisites

- Flutter SDK 3.x
- Xcode 15+
- `uv` — [astral.sh/uv](https://astral.sh/uv)

### Getting started

```bash
# Install Flutter dependencies
cd apps/app_mobile && flutter pub get

# Run in debug mode
flutter run -d macos

# Run tests
flutter test

# Analyse
flutter analyze

# Build release
make build

# Create DMG
make dmg
```

### Project structure

```
apps/app_mobile/       — Flutter macOS application
packages/
  core_domain/         — Entities, use cases, repository interfaces
  core_data/           — Repository implementations, Drift SQLite database
  core_foundation/     — Logger, config, shared utilities
  core_presentation/   — Shared widgets
```

### Architecture

IciTranscript follows a layered clean architecture:

- **Presentation** — Flutter widgets + Riverpod ViewModels (Freezed state)
- **Application** — LiveTranscriptionService orchestrating audio capture, WebSocket, and DB
- **Domain** — Pure Dart use cases and entities
- **Data** — Drift SQLite + platform channels (Swift) for audio + process management

The transcription server (`voxmlx-serve`) runs as a child process launched by the app via `uvx`. It listens on `ws://localhost:8000` and streams transcript segments back in real time.

---

## Privacy

IciTranscript is designed with privacy as a core principle:

- All audio processing happens **on your device**
- No data is sent to any external server
- No analytics, no crash reporting, no telemetry
- Session data is stored locally in `~/Library/Application Support/IciTranscript/`

---

## License

MIT
