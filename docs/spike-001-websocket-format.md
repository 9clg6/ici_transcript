# SPIKE-001: voxmlx-serve WebSocket Protocol

**Date:** 2026-03-19
**Status:** Complete
**Source:** https://github.com/T0mSIlver/voxmlx (T0mSIlver fork)

---

## Server Launch Command

```bash
uvx --from "git+https://github.com/T0mSIlver/voxmlx.git[server]" voxmlx-serve \
    --model T0mSIlver/Voxtral-Mini-4B-Realtime-2602-MLX-4bit \
    --port 8000 \
    --host 127.0.0.1 \
    --temp 0.0
```

### CLI Options

| Flag       | Description                      | Default                                       |
|------------|----------------------------------|-----------------------------------------------|
| `--model`  | Model path or HF model ID       | `mlx-community/Voxtral-Mini-4B-Realtime-6bit` |
| `--port`   | Port to listen on                | `8000`                                        |
| `--host`   | Host to bind to                  | `127.0.0.1`                                   |
| `--temp`   | Sampling temperature (0=greedy)  | `0.0`                                         |

### Dependencies

The `[server]` extra installs: `fastapi`, `uvicorn[standard]`.

---

## WebSocket Endpoint

```
ws://127.0.0.1:8000/v1/realtime
```

There is also an HTTP health endpoint:

```
GET http://127.0.0.1:8000/health
→ {"status": "ok"}
```

---

## Audio Format Requirements

| Parameter   | Value                |
|-------------|----------------------|
| Sample rate | **16,000 Hz** (16 kHz) |
| Channels    | Mono (1 channel)     |
| Bit depth   | 16-bit signed integer (PCM16 / Int16) |
| Encoding    | Raw PCM, little-endian |
| Transport   | Base64-encoded in JSON `audio` field |

**Important:** The server expects **16 kHz PCM16**, NOT 24 kHz like the OpenAI Realtime API.

The server decodes base64 → `int16` bytes → `float32` (divides by 32768.0) internally.

---

## Session Lifecycle

### 1. Connect

Client opens a WebSocket connection to `ws://127.0.0.1:8000/v1/realtime`.

### 2. Server sends `session.created`

Immediately upon WebSocket accept, the server sends:

```json
{"type": "session.created"}
```

### 3. (Optional) Client sends `session.update`

The client may send a session update. The server acknowledges it but **does not actually process any configuration** — it's a no-op stub for compatibility:

```json
{"type": "session.update"}
```

Server responds:

```json
{"type": "session.updated"}
```

### 4. Client streams audio via `input_audio_buffer.append`

The client sends audio chunks continuously:

```json
{
  "type": "input_audio_buffer.append",
  "audio": "<base64-encoded PCM16 bytes>"
}
```

- Audio is **16 kHz, mono, 16-bit signed PCM**, base64-encoded.
- Chunks can be any size, but the model processes in units of `SAMPLES_PER_TOKEN = 1280` samples (= 80ms at 16 kHz).
- Smaller chunks are buffered internally until enough data is available.

### 5. Server streams transcription deltas

As tokens are decoded, the server sends incremental deltas:

```json
{
  "type": "response.audio_transcript.delta",
  "delta": "Hello"
}
```

When the model hits an end-of-sequence token (natural sentence boundary), the server sends a completion event with the full accumulated text and resets internal state:

```json
{
  "type": "response.audio_transcript.done",
  "text": "Hello, how are you?"
}
```

**Note:** The completion event uses the `text` field, NOT `transcript`.

### 6. Client commits audio buffer (optional)

The client can send a commit to flush remaining audio with right-padding:

```json
{
  "type": "input_audio_buffer.commit",
  "final": true
}
```

- When `"final": true`, the server flushes all remaining audio (adds right-padding tokens), decodes everything, sends any remaining deltas, then sends a `response.audio_transcript.done` event and resets.
- When `"final": false` or omitted, the commit is a no-op (audio is processed continuously).

### 7. Disconnect

Client closes the WebSocket. Server clears GPU memory cache on disconnect.

---

## Client → Server Messages (Complete)

| Type                          | Fields                         | Description                          |
|-------------------------------|--------------------------------|--------------------------------------|
| `session.update`              | (none required)                | No-op, returns `session.updated`     |
| `input_audio_buffer.append`   | `audio`: base64 string         | Send audio chunk for transcription   |
| `input_audio_buffer.commit`   | `final`: boolean (optional)    | Flush audio buffer if `final: true`  |

## Server → Client Messages (Complete)

| Type                                  | Fields          | Description                              |
|---------------------------------------|-----------------|------------------------------------------|
| `session.created`                     | (none)          | Sent immediately on connect              |
| `session.updated`                     | (none)          | Response to `session.update`             |
| `response.audio_transcript.delta`     | `delta`: string | Incremental transcription token          |
| `response.audio_transcript.done`      | `text`: string  | Complete transcription for an utterance  |
| `error`                               | `message`: string | Error (e.g., invalid JSON)             |

---

## Differences from OpenAI Realtime API

| Feature                          | OpenAI Realtime API                                       | voxmlx-serve                                      |
|----------------------------------|-----------------------------------------------------------|----------------------------------------------------|
| **Audio sample rate**            | 24 kHz                                                    | **16 kHz**                                         |
| **Audio format**                 | `audio/pcm` (24kHz), `audio/pcmu`, `audio/pcma`          | Raw PCM16 (16kHz) only                             |
| **WebSocket URL**                | `wss://api.openai.com/v1/realtime?model=...`              | `ws://localhost:8000/v1/realtime`                  |
| **Authentication**               | Bearer token / ephemeral key                              | None (local server)                                |
| **Session type**                 | `"type": "realtime"` or `"type": "transcription"`         | Not used (transcription only)                      |
| **Session config**               | Rich config (model, voice, VAD, noise reduction, etc.)    | `session.update` is a no-op stub                   |
| **VAD / turn detection**         | Server-side VAD with configurable thresholds              | None — model detects EOS internally via EOS token  |
| **Delta event type**             | `conversation.item.input_audio_transcription.delta`       | `response.audio_transcript.delta`                  |
| **Done event type**              | `conversation.item.input_audio_transcription.completed`   | `response.audio_transcript.done`                   |
| **Done event field**             | `transcript`                                              | `text`                                             |
| **Commit with final**            | Not applicable (VAD handles it)                           | `input_audio_buffer.commit` with `"final": true`   |
| **Response generation**          | Full speech-to-speech with TTS output                     | Transcription-only (text output)                   |
| **Conversation items**           | Full conversation item model with IDs                     | No item IDs, no conversation items                 |
| **Multiple modalities**          | Audio + text + images                                     | Audio input only, text output only                 |
| **Port**                         | N/A (cloud)                                               | Default `8000`                                     |

---

## Key Implementation Notes for IciTranscript

1. **Default URL must be `ws://localhost:8000/v1/realtime`**, not `ws://localhost:8765`.
2. **Audio must be 16 kHz PCM16**, not 24 kHz.
3. **The `text` field** on `response.audio_transcript.done` contains the completed transcription (not `transcript`).
4. **Ready pattern** for detecting server startup should match uvicorn output, e.g., `"Uvicorn running"` or `"Started server process"` (uvicorn logs to stderr).
5. **No authentication** is needed for the local WebSocket connection.
6. The server does **not** support the OpenAI GA event names (`conversation.item.input_audio_transcription.*`). It uses the beta-era `response.audio_transcript.*` naming.
