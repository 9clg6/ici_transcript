# SPIKE-002: ScreenCaptureKit + AVAudioEngine Parallel Audio Capture

**Status:** VALIDATED  
**Date:** 2026-03-19  
**Author:** Spike Research

---

## 1. Executive Summary

macOS provides two complementary APIs for capturing audio:

| Stream | API | Available Since |
|--------|-----|-----------------|
| Microphone (user voice) | `AVAudioEngine` (AVFAudio) | macOS 10.10+ |
| System audio (remote participants) | `ScreenCaptureKit` (`SCStream`) | macOS 13.0+ |

**Both can run in parallel** without conflict. AVAudioEngine uses the Core Audio HAL input path, while ScreenCaptureKit hooks into the system audio mixer at the OS level. They operate on independent audio paths and do not interfere with each other.

---

## 2. ScreenCaptureKit: Audio-Only Capture

### 2.1 Setup Flow

```
SCShareableContent.getExcludingDesktopWindows(...)
    → SCContentFilter(display:excludingWindows:)
        → SCStreamConfiguration (audio settings)
            → SCStream(filter:configuration:delegate:)
                → stream.addStreamOutput(handler, type: .audio, ...)
                    → stream.startCapture(...)
```

### 2.2 SCStreamConfiguration for Audio-Only

```swift
let config = SCStreamConfiguration()

// Enable audio capture (disabled by default)
config.capturesAudio = true                // macOS 13.0+
config.excludesCurrentProcessAudio = true  // macOS 13.0+ — prevents feedback loop

// Audio format
config.sampleRate = 16000    // Int — direct 16kHz capture, no resampling needed
config.channelCount = 1      // Int — mono

// Minimize video overhead (SCK requires a display filter, cannot be audio-only)
config.width = 2             // Minimum pixel dimensions
config.height = 2
config.minimumFrameInterval = CMTime(value: 1, timescale: 1) // 1 fps cap
```

**Key finding:** `SCStreamConfiguration.sampleRate` and `channelCount` are `Int` properties. Setting `sampleRate = 16000` and `channelCount = 1` causes ScreenCaptureKit to deliver audio samples already at 16 kHz mono — **no manual resampling is needed** for the system audio path.

### 2.3 Content Filter Requirement

ScreenCaptureKit requires a display-based content filter even for audio-only capture. The filter determines the scope of system audio:

```swift
// Captures all system audio from the display (excluding our own process)
let filter = SCContentFilter(display: display, excludingWindows: [])
```

This captures all audio playing through the system mixer (Zoom, Teams, browser, etc.) — exactly what we need for "what others say."

### 2.4 SCStreamOutput — Audio Delivery via CMSampleBuffer

Audio is delivered through the `SCStreamOutput` protocol:

```swift
protocol SCStreamOutput: NSObjectProtocol {
    func stream(_ stream: SCStream,
                didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
                of type: SCStreamOutputType)
}
```

- The `type` parameter is `.audio` for audio frames, `.screen` for video frames
- Audio frames arrive as `CMSampleBuffer` containing PCM data
- The handler queue should be high-priority: `.global(qos: .userInteractive)`

### 2.5 Extracting PCM Data from CMSampleBuffer

```swift
func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
    guard type == .audio else { return }

    // Get the audio block buffer
    guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else { return }

    var lengthAtOffset = 0
    var totalLength = 0
    var dataPointer: UnsafeMutablePointer<Int8>?

    let status = CMBlockBufferGetDataPointer(
        blockBuffer, atOffset: 0,
        lengthAtOffsetOut: &lengthAtOffset,
        totalLengthOut: &totalLength,
        dataPointerOut: &dataPointer
    )
    guard status == kCMBlockBufferNoErr, let ptr = dataPointer else { return }

    // Read format to determine sample size
    let formatDesc = CMSampleBufferGetFormatDescription(sampleBuffer)
    let asbd = CMAudioFormatDescriptionGetStreamBasicDescription(formatDesc!)

    // With config.sampleRate = 16000 and config.channelCount = 1,
    // the data is already Float32 mono 16kHz
    let floatCount = totalLength / MemoryLayout<Float>.size
    let floatPointer = UnsafeRawPointer(ptr).bindMemory(to: Float.self, capacity: floatCount)
    let samples = Array(UnsafeBufferPointer(start: floatPointer, count: floatCount))
}
```

**Important:** When `sampleRate` and `channelCount` are set in the configuration, SCK delivers audio in the requested format. The native format from the system mixer is typically 48 kHz stereo Float32, but SCK resamples internally.

### 2.6 SCStreamDelegate vs SCStreamOutput

- **SCStreamDelegate** — handles stream lifecycle events (errors, stream did stop). Optional.
- **SCStreamOutput** — handles actual audio/video data delivery. Required for receiving data.

Both can be set independently. For error handling, implementing `SCStreamDelegate` is recommended but not required for basic capture.

---

## 3. AVAudioEngine: Microphone Capture

### 3.1 Setup Flow

```swift
let engine = AVAudioEngine()
let inputNode = engine.inputNode
let inputFormat = inputNode.outputFormat(forBus: 0)

// Install tap — receives PCM buffers from the microphone
inputNode.installTap(onBus: 0, bufferSize: 4096, format: inputFormat) { buffer, time in
    // buffer: AVAudioPCMBuffer with mic audio
}

try engine.start()
```

### 3.2 Resampling to 16 kHz Mono Float32

The microphone typically provides 44.1 kHz or 48 kHz stereo. We need AVAudioConverter:

```swift
let targetFormat = AVAudioFormat(
    commonFormat: .pcmFormatFloat32,
    sampleRate: 16000,
    channels: 1,
    interleaved: false
)!

let converter = AVAudioConverter(from: inputFormat, to: targetFormat)

// In the tap callback:
let convertedBuffer = AVAudioPCMBuffer(
    pcmFormat: targetFormat,
    frameCapacity: AVAudioFrameCount(
        Double(buffer.frameLength) * 16000.0 / inputFormat.sampleRate
    ) + 64  // padding for rounding
)!

var inputConsumed = false
converter.convert(to: convertedBuffer, error: &error) { _, outStatus in
    if inputConsumed {
        outStatus.pointee = .noDataNow
        return nil
    }
    inputConsumed = true
    outStatus.pointee = .haveData
    return buffer
}
```

### 3.3 Input Device Selection

```swift
if let deviceID = AudioDeviceID(deviceIdString) {
    var id = deviceID
    AudioUnitSetProperty(
        engine.inputNode.audioUnit!,
        kAudioOutputUnitProperty_CurrentDevice,
        kAudioUnitScope_Global, 0,
        &id, UInt32(MemoryLayout<AudioDeviceID>.size)
    )
}
```

---

## 4. Running Both Captures in Parallel

### 4.1 Architecture

```
┌────────────────────┐     ┌─────────────────────────┐
│   AVAudioEngine    │     │   ScreenCaptureKit       │
│  (Microphone)      │     │  (System Audio)          │
│                    │     │                          │
│  inputNode.tap     │     │  SCStreamOutput          │
│    ↓               │     │    ↓                     │
│  AVAudioConverter  │     │  CMSampleBuffer          │
│  → 16kHz mono      │     │  (already 16kHz mono)    │
│    ↓               │     │    ↓                     │
│  source: "input"   │     │  source: "output"        │
└────────┬───────────┘     └────────┬────────────────┘
         │                          │
         └──────────┬───────────────┘
                    ↓
         FlutterEventChannel
         (AudioChunk events)
                    ↓
              Dart Stream
```

### 4.2 Thread Safety

- AVAudioEngine tap callback runs on an internal audio thread
- SCStreamOutput callback runs on the queue specified in `addStreamOutput(... sampleHandlerQueue:)`
- Both use NSLock for accumulation buffer access
- Events are dispatched to main thread for Flutter EventChannel delivery

### 4.3 Independence

The two capture mechanisms are fully independent:
- AVAudioEngine uses Core Audio HAL (microphone hardware)
- SCStream captures from the system audio mixer (software-level)
- No shared state, no resource contention
- Starting/stopping one does not affect the other

---

## 5. Permission Model

### 5.1 Microphone Access

- Requires `NSMicrophoneUsageDescription` in Info.plist
- Requires `com.apple.security.device.audio-input` entitlement
- macOS shows a system dialog: "X would like to access the microphone"
- If denied: `AVAudioEngine.start()` throws an error
- User can change permission in System Preferences > Privacy & Security > Microphone

### 5.2 Screen Capture / System Audio

- **No entitlement required** for non-sandboxed apps (our current setup: `com.apple.security.app-sandbox = false`)
- macOS 13+: First call to `SCShareableContent.getExcludingDesktopWindows(...)` triggers a system dialog: "X would like to record the contents of your screen"
- This is a **single permission** that covers both screen and audio capture
- If denied: the `SCShareableContent` callback returns an error
- User can change permission in System Preferences > Privacy & Security > Screen Recording
- **Note:** On macOS 15+, Apple added more granular screen recording permissions

### 5.3 Current Entitlements Status

```xml
<!-- DebugProfile.entitlements / Release.entitlements -->
<key>com.apple.security.app-sandbox</key>
<false/>
<key>com.apple.security.device.audio-input</key>
<true/>
```

This is correct. Sandbox is disabled (required for ScreenCaptureKit without additional entitlements), and audio-input entitlement is present for microphone access.

---

## 6. Performance Considerations

### 6.1 CPU Usage

- **AVAudioEngine resampling:** AVAudioConverter uses vDSP/Accelerate internally — very efficient, ~0.1% CPU
- **SCStream at 16 kHz mono:** Minimal overhead since we're requesting low-quality audio and minimum video (2x2 @ 1fps)
- **Total estimated overhead:** < 2% CPU for both captures combined

### 6.2 Memory Usage

- Audio buffers are small: 16 kHz * 4 bytes/sample * 0.1s = 6.4 KB per chunk
- Accumulation buffers grow up to ~6.4 KB before being flushed
- CMSampleBuffers are released after processing (ARC)
- **Total estimated memory:** < 1 MB for the entire audio pipeline

### 6.3 Latency

- AVAudioEngine tap buffer: 4096 frames at source rate ≈ 85ms at 48kHz
- Chunking: 100ms chunks (1600 samples at 16kHz)
- SCStream audio delivery: typically every ~20-50ms
- **End-to-end latency:** ~100-200ms from audio event to Dart chunk delivery

### 6.4 Battery Impact

- Both captures are event-driven (no polling)
- Audio-only capture uses significantly less power than video capture
- Acceptable for a desktop app running during calls

---

## 7. Code Review: Current Implementation

### 7.1 AudioCapturePlugin.swift — Assessment: CORRECT

The current implementation at `apps/app_mobile/macos/Runner/AudioCapturePlugin.swift` is well-structured and follows Apple's recommended patterns.

**ScreenCaptureKit setup (lines 255-314):**
- `SCShareableContent.getExcludingDesktopWindows(true, onScreenWindowsOnly: false)` — correct
- `SCContentFilter(display: display, excludingWindows: [])` — correct for system audio capture
- `config.capturesAudio = true` — correct
- `config.excludesCurrentProcessAudio = true` — correct (prevents feedback)
- `config.sampleRate = Int(16000)` — correct, SCK resamples internally
- `config.channelCount = Int(1)` — correct, mono output
- `config.width = 2; config.height = 2; minimumFrameInterval = 1fps` — correct video minimization
- `addStreamOutput(handler, type: .audio, sampleHandlerQueue: .global(qos: .userInteractive))` — correct

**CMSampleBuffer handling (lines 485-527):**
- Correctly extracts data via `CMBlockBufferGetDataPointer`
- Reads ASBD for bits-per-channel to compute float count
- Accumulates samples and sends in 1600-sample (100ms) chunks
- Thread-safe with NSLock

**AVAudioEngine mic capture (lines 142-251):**
- Correctly creates converter when sample rate differs
- Correctly handles the `convert(to:error:)` callback pattern
- Accumulates and chunks at 1600 samples

**Minor observation:** The `SystemAudioOutputHandler.stream(...)` method at line 504 computes `floatCount` using `mBitsPerChannel` which is correct for robustness, but since we request Float32 at 16kHz mono, `totalLength / 4` would always work. The current code is actually more defensive and correct.

### 7.2 audio_capture_channel.dart — Assessment: CORRECT

The Dart wrapper at `apps/app_mobile/lib/core/platform/audio_capture_channel.dart`:
- Correctly uses `MethodChannel` for commands and `EventChannel` for streaming data
- Properly maps `source` string to `AudioSource` enum
- Handles `Uint8List` and `List<int>` data types from the platform channel
- Includes `timestampMs` in the `AudioChunk`
- Broadcast stream controller allows multiple listeners
- Proper cleanup in `dispose()`

### 7.3 ProcessManagerPlugin.swift — Assessment: CORRECT for current scope

The ProcessManagerPlugin correctly:
- Extends PATH with common tool locations (`/usr/local/bin`, `/opt/homebrew/bin`)
- Handles SIGTERM with 5-second timeout before SIGKILL
- Kills orphan processes before starting

---

## 8. uvx / uv Package Manager

### 8.1 What is uvx?

`uvx` is the tool runner from `uv`, a fast Python package manager by Astral. It runs Python tools in isolated environments without installing them globally (similar to `npx` for Node.js).

### 8.2 Checking if uv/uvx is installed

```bash
# Check if uvx is available
which uvx
# or
uvx --version
```

Common install locations:
- `~/.local/bin/uvx` (default uv installer location)
- `~/.cargo/bin/uvx` (if installed via cargo)
- `/usr/local/bin/uvx` (if installed via Homebrew)
- `/opt/homebrew/bin/uvx` (Homebrew on Apple Silicon)

### 8.3 Auto-installation

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

This installs `uv` and `uvx` to `~/.local/bin/`. The script is safe and well-maintained by Astral.

### 8.4 Recommendation for ProcessManagerPlugin

The current ProcessManagerPlugin receives a `command` path from Dart. The Dart layer should:

1. First check if `uvx` exists in known locations
2. If not found, show a user-friendly dialog with install instructions
3. Alternatively, auto-install with user consent

The Swift plugin already extends PATH to cover most locations. The main risk is that `~/.local/bin` is not in the PATH. This should be added.

---

## 9. Known Limitations

1. **macOS 13+ required** for system audio capture. On macOS 12 and below, only microphone capture works.

2. **SCStream requires a display filter** — there is no API for audio-only streaming without referencing a display. We work around this by setting minimal video dimensions (2x2 pixels).

3. **Screen Recording permission** — the user must grant Screen Recording permission for system audio. This is the same permission used for screen sharing, which can confuse users who only want audio.

4. **No per-app audio selection** — SCStream captures ALL system audio (minus the current process). You cannot selectively capture only Zoom audio, for example. The `excludesCurrentProcessAudio` flag only excludes the IciTranscript app itself.

5. **Audio format from SCK** — while we request 16kHz mono, SCK performs internal resampling. The quality depends on the source audio and SCK's internal resampler.

6. **Sandboxed apps** — if the app is sandboxed, additional entitlements (`com.apple.developer.persistent-content-capture`) may be required. Currently, the app runs without sandbox.

7. **macOS 15 Screen Recording changes** — Apple introduced more restrictive screen recording dialogs in macOS 15 (Sequoia). The system may show periodic re-authorization prompts.

8. **CMSampleBuffer timing** — audio timestamps from SCK and AVAudioEngine use different clock sources. The current implementation uses `Date().timeIntervalSince1970` for consistent timestamping, which is correct.

---

## 10. Conclusion

The current implementation is **validated and correct**. Both ScreenCaptureKit and AVAudioEngine can capture audio in parallel without issues. The architecture properly:

- Separates mic input (AVAudioEngine) from system output (ScreenCaptureKit)
- Resamples mic audio to 16kHz mono Float32 via AVAudioConverter
- Requests 16kHz mono from SCK directly (no manual resampling needed)
- Chunks both streams into 100ms segments (1600 samples)
- Delivers typed events to Dart via Flutter EventChannel
- Handles permissions correctly (no sandbox, audio-input entitlement)
- Minimizes video overhead for audio-only SCK capture

No code changes are required for the audio capture pipeline. The implementation matches Apple's documented APIs and best practices.
