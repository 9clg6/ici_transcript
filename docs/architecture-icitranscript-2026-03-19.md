# Architecture Technique — IciTranscript

**Date:** 2026-03-19
**Auteur:** Clement
**Statut:** DRAFT
**Refs:** PRD, Product Brief, ARCHITECTURE.md (conventions Flutter)

---

## 1. Vue d'ensemble

### 1.1 Diagramme systeme

```
┌──────────────────────────────────────────────────────────────────────┐
│                      macOS (Apple Silicon)                           │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │              IciTranscript (Flutter macOS app)                   │ │
│  │                                                                  │ │
│  │  ┌──────────┐  ┌───────────┐  ┌──────────┐  ┌───────────────┐  │ │
│  │  │ UI Layer │  │  Domain   │  │  Data    │  │  Foundation   │  │ │
│  │  │ (Flutter)│  │  (Entities│  │  (Repos, │  │  (Interfaces, │  │ │
│  │  │ Screens, │──│  UseCases,│──│  Sources,│  │   Config,     │  │ │
│  │  │ ViewMods)│  │  Services)│  │  Mappers)│  │   Logging)    │  │ │
│  │  └────┬─────┘  └─────┬────┘  └────┬─────┘  └───────────────┘  │ │
│  │       │               │            │                             │ │
│  │       │        ┌──────┴────────────┴──────────┐                  │ │
│  │       │        │    Platform Channels (Swift)  │                  │ │
│  │       │        │  ┌─────────────┐ ┌──────────┐│                  │ │
│  │       │        │  │AudioCapture │ │ Process  ││                  │ │
│  │       │        │  │  Service    │ │ Manager  ││                  │ │
│  │       │        │  │ (SCK + CoreAudio) │ │(voxmlx)  ││                  │ │
│  │       │        │  └──────┬──────┘ └────┬─────┘│                  │ │
│  │       │        └─────────┼─────────────┼──────┘                  │ │
│  └───────┼──────────────────┼─────────────┼─────────────────────────┘ │
│          │                  │             │                           │
│          │    ┌─────────────┘             │                           │
│          │    │                           │                           │
│  ┌───────┴────┴────┐         ┌───────────┴───────────┐               │
│  │ScreenCaptureKit │         │    voxmlx-serve        │               │
│  │  (macOS 13+)    │         │  (Voxtral MLX 4-bit)  │               │
│  │  Native system  │         │  WebSocket server      │               │
│  │  audio capture  │         │  OpenAI Realtime API   │               │
│  │  Zero install   │         │  localhost:8765        │               │
│  └─────────────────┘         └───────────────────────┘               │
│                                                                      │
│  ┌─────────────────┐                                                 │
│  │    SQLite        │  Historique sessions, transcriptions, resumes   │
│  │    (local DB)    │                                                 │
│  └─────────────────┘                                                 │
└──────────────────────────────────────────────────────────────────────┘
```

### 1.2 Principes architecturaux

| Principe | Application |
|----------|------------|
| **100% local** | Zero appel reseau sortant. Tout est localhost. |
| **Clean Architecture** | Domain ne connait pas Data. Inversion de dependances via Riverpod. |
| **Feature-first** | Chaque feature (transcription, historique, settings) est isolee. |
| **Platform Channels pour le natif** | Audio capture (CoreAudio) et process management (voxmlx-serve) via Swift. |
| **Immutabilite** | Toutes les donnees sont immutables (Freezed). |

---

## 2. Composants et responsabilites

### 2.1 Composant : AudioCaptureService (Swift - Platform Channel)

**Responsabilite :** Capturer l'audio micro (input) et l'audio systeme (output via BlackHole) en parallele.

**Pourquoi Swift natif ?** Flutter n'a pas d'API pour la capture audio sur macOS. ScreenCaptureKit (macOS 13+) est l'API native Apple pour capturer l'audio systeme sans driver tiers. Combine avec AVAudioEngine pour le micro, c'est la solution zero-friction.

**Interface Dart (MethodChannel) :**
```dart
abstract interface class AudioCaptureService {
  /// Demarre la capture audio des 2 flux.
  Future<void> startCapture({
    required String inputDeviceId,   // ID du micro
    required String outputDeviceId,  // ID de BlackHole
  });

  /// Arrete la capture audio.
  Future<void> stopCapture();

  /// Stream des chunks audio bruts (PCM float32, 16kHz).
  /// Chaque event contient : source (input|output) + data (Uint8List).
  Stream<AudioChunk> audioStream;

  /// Liste les peripheriques audio disponibles.
  Future<List<AudioDevice>> listDevices();

  /// Detecte si BlackHole est installe.
  Future<bool> isBlackHoleInstalled();
}
```

**Implementation Swift (cote natif) :**
- Utilise `AVAudioEngine` pour capturer 2 input nodes en parallele
- Micro : device par defaut ou selectionne
- Systeme : BlackHole 2ch (qui recoit l'audio systeme via Multi-Output Device macOS)
- Resample a 16kHz mono (format attendu par Voxtral)
- Envoie les chunks via `FlutterEventChannel` vers Dart

**Capture audio systeme via ScreenCaptureKit :**
- ScreenCaptureKit (macOS 13+) capture l'audio systeme nativement
- Pas besoin de driver tiers (BlackHole), pas de Multi-Output Device
- L'utilisateur accorde une permission systeme au premier lancement (dialogue natif macOS)
- Zero configuration manuelle requise

**Decision :** ScreenCaptureKit pour l'audio systeme + AVAudioEngine pour le micro. Zero friction utilisateur.

### 2.2 Composant : TranscriptionService (WebSocket client)

**Responsabilite :** Se connecter au serveur voxmlx-serve et envoyer l'audio pour transcription en streaming.

**Protocole :** WebSocket compatible OpenAI Realtime API.

**Flux de donnees :**
```
AudioCaptureService (Swift)
  → Stream<AudioChunk> via EventChannel
    → TranscriptionService (Dart)
      → Encode audio en base64
      → Envoie via WebSocket à ws://localhost:8765
        → voxmlx-serve transcrit avec Voxtral MLX
          → Renvoie les segments transcrits en JSON
            → TranscriptionService parse et emet des TranscriptSegment
              → ViewModel met a jour le state
                → UI affiche les sous-titres
```

**Interface :**
```dart
abstract interface class TranscriptionDataSource {
  /// Se connecte au serveur WebSocket.
  Future<void> connect({String url = 'ws://localhost:8765'});

  /// Envoie un chunk audio au serveur.
  void sendAudio(AudioChunk chunk);

  /// Stream des segments transcrits.
  Stream<TranscriptSegment> transcriptionStream;

  /// Deconnecte du serveur.
  Future<void> disconnect();

  /// Etat de la connexion.
  Stream<ConnectionState> connectionState;
}
```

**Messages WebSocket (OpenAI Realtime API format) :**

Client → Serveur :
```json
{
  "type": "input_audio_buffer.append",
  "audio": "<base64 encoded PCM audio>"
}
```

Serveur → Client :
```json
{
  "type": "response.audio_transcript.delta",
  "delta": "bonjour tout le monde"
}
```

### 2.3 Composant : ProcessManagerService (Swift - Platform Channel)

**Responsabilite :** Lancer, surveiller et arreter le processus voxmlx-serve.

**Pourquoi Swift natif ?** La gestion de processus enfants est plus fiable via `Process` de Foundation (Swift) que via `dart:io Process` sur macOS, notamment pour la gestion des signaux et du cleanup.

**Interface Dart :**
```dart
abstract interface class ProcessManagerService {
  /// Lance le serveur voxmlx-serve.
  Future<void> startServer({String? modelPath});

  /// Arrete le serveur.
  Future<void> stopServer();

  /// Etat du serveur.
  Stream<ServerState> serverState; // starting, ready, error, stopped

  /// Logs du serveur (stdout/stderr).
  Stream<String> serverLogs;

  /// Verifie si uvx est installe.
  Future<bool> isUvxAvailable();
}
```

**Commande lancee :**
```bash
uvx --from "git+https://github.com/T0mSIlver/voxmlx.git[server]" \
  voxmlx-serve --model T0mSIlver/Voxtral-Mini-4B-Realtime-2602-MLX-4bit
```

**Detection "serveur pret" :**
- Parse stdout pour un message de type "Server listening on ws://..."
- Ou tente une connexion WebSocket en polling (toutes les 500ms, timeout 60s)

**Gestion du lifecycle :**
- `startServer()` : lance le processus, attend le signal "pret"
- `stopServer()` : envoie SIGTERM, attend 5s, SIGKILL si necessaire
- Si l'app crash : le processus orphelin continue. Au prochain lancement, detecter et kill les processus voxmlx existants.

### 2.4 Composant : SessionRepository (SQLite)

**Responsabilite :** Persister les sessions de transcription dans une base SQLite locale.

**Schema :**

```sql
CREATE TABLE sessions (
  id TEXT PRIMARY KEY,          -- UUID
  title TEXT NOT NULL,           -- Titre editable (defaut: "Session YYYY-MM-DD HH:mm")
  created_at TEXT NOT NULL,      -- ISO 8601
  updated_at TEXT NOT NULL,      -- ISO 8601
  duration_seconds INTEGER,      -- Duree totale en secondes
  status TEXT NOT NULL            -- active, completed, error
);

CREATE TABLE transcript_segments (
  id TEXT PRIMARY KEY,           -- UUID
  session_id TEXT NOT NULL,      -- FK → sessions.id
  source TEXT NOT NULL,          -- 'input' (micro) ou 'output' (systeme)
  text TEXT NOT NULL,            -- Texte transcrit
  timestamp_ms INTEGER NOT NULL, -- Offset en ms depuis le debut de la session
  created_at TEXT NOT NULL,      -- ISO 8601
  FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE
);

CREATE TABLE summaries (
  id TEXT PRIMARY KEY,           -- UUID
  session_id TEXT NOT NULL,      -- FK → sessions.id (UNIQUE)
  content TEXT NOT NULL,          -- Resume en texte
  model TEXT NOT NULL,            -- Nom du modele utilise
  created_at TEXT NOT NULL,      -- ISO 8601
  FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE
);

-- Index pour la recherche
CREATE INDEX idx_segments_session ON transcript_segments(session_id);
CREATE INDEX idx_segments_text ON transcript_segments(text);
CREATE INDEX idx_sessions_created ON sessions(created_at DESC);
```

**Package Dart :** `drift` (SQLite type-safe pour Dart/Flutter)

**Sauvegarde incrementale :** Chaque `TranscriptSegment` est insere en base au fur et a mesure de la reception. Si l'app crash, seuls les derniers segments non flushed sont perdus.

---

## 3. Mapping sur l'architecture Flutter (ARCHITECTURE.md)

### 3.1 Domain Layer (`packages/core_domain/`)

```
domain/
├── entities/
│   ├── session.entity.dart              # SessionEntity
│   ├── transcript_segment.entity.dart    # TranscriptSegmentEntity
│   ├── audio_device.entity.dart          # AudioDeviceEntity
│   └── summary.entity.dart              # SummaryEntity (post-MVP)
├── enum/
│   ├── audio_source.enum.dart            # AudioSource { input, output }
│   ├── session_status.enum.dart          # SessionStatus { active, completed, error }
│   ├── server_state.enum.dart            # ServerState { starting, ready, error, stopped }
│   └── connection_state.enum.dart        # ConnectionState { connecting, connected, disconnected, error }
├── repositories/
│   ├── session.repository.dart           # Interface CRUD sessions
│   ├── transcript.repository.dart        # Interface CRUD segments
│   └── audio.repository.dart             # Interface capture audio
├── usecases/
│   ├── start_session.use_case.dart
│   ├── stop_session.use_case.dart
│   ├── get_sessions.use_case.dart
│   ├── get_session_detail.use_case.dart
│   ├── delete_session.use_case.dart
│   ├── update_session_title.use_case.dart
│   ├── search_sessions.use_case.dart     # post-MVP
│   └── generate_summary.use_case.dart    # post-MVP
├── services/
│   ├── transcription.service.dart        # Orchestre session + capture + transcription
│   └── session_history.service.dart      # Orchestre historique + recherche
└── params/
    ├── start_session.param.dart
    └── search_sessions.param.dart        # post-MVP
```

### 3.2 Data Layer (`packages/core_data/`)

```
core_data/lib/
├── datasources/
│   ├── local/
│   │   ├── session.local.data_source.dart          # Interface
│   │   ├── impl/
│   │   │   └── session.local.data_source.impl.dart # Drift/SQLite
│   │   ├── transcript.local.data_source.dart
│   │   └── impl/
│   │       └── transcript.local.data_source.impl.dart
│   └── remote/
│       ├── transcription.remote.data_source.dart    # Interface (WebSocket)
│       └── impl/
│           └── transcription.remote.data_source.impl.dart  # WebSocket client
├── model/
│   ├── local/
│   │   ├── session.local.model.dart
│   │   └── transcript_segment.local.model.dart
│   └── remote/
│       └── transcript_event.remote.model.dart       # JSON du WebSocket
├── mappers/
│   ├── session.mapper.dart
│   ├── transcript_segment.mapper.dart
│   └── transcript_event.mapper.dart
├── repositories/
│   ├── session.repository.impl.dart
│   ├── transcript.repository.impl.dart
│   └── audio.repository.impl.dart
└── clients/
    └── websocket_client.dart                        # Client WebSocket configurable
```

### 3.3 App Layer (`apps/app_mobile/lib/`)

```
lib/
├── application/services/
│   └── live_transcription.service.dart   # Orchestre tout : process, audio, WS, persistence
├── core/providers/
│   ├── data/
│   │   ├── datasource/
│   │   │   ├── session.local.data_source.provider.dart
│   │   │   ├── transcript.local.data_source.provider.dart
│   │   │   └── transcription.remote.data_source.provider.dart
│   │   └── endpoint/
│   │       └── database.provider.dart    # Drift database singleton
│   ├── core/
│   │   ├── repositories/
│   │   │   ├── session.repository.provider.dart
│   │   │   ├── transcript.repository.provider.dart
│   │   │   └── audio.repository.provider.dart
│   │   └── usecases/
│   │       ├── start_session.use_case.provider.dart
│   │       ├── stop_session.use_case.provider.dart
│   │       └── ...
│   ├── services/
│   │   ├── live_transcription.service.provider.dart
│   │   ├── process_manager.service.provider.dart
│   │   └── audio_capture.service.provider.dart
│   └── platform/
│       ├── audio_capture.channel.dart     # MethodChannel/EventChannel vers Swift
│       └── process_manager.channel.dart   # MethodChannel vers Swift
├── features/
│   ├── transcription/
│   │   └── presentation/screens/
│   │       └── live/
│   │           ├── live_transcription.screen.dart
│   │           ├── live_transcription.view_model.dart
│   │           ├── live_transcription.state.dart
│   │           └── widgets/
│   │               ├── transcript_line.widget.dart
│   │               ├── session_controls.widget.dart
│   │               ├── audio_level_indicator.widget.dart
│   │               └── server_status.widget.dart
│   ├── history/
│   │   └── presentation/screens/
│   │       ├── list/
│   │       │   ├── session_list.screen.dart
│   │       │   ├── session_list.view_model.dart
│   │       │   ├── session_list.state.dart
│   │       │   └── widgets/
│   │       │       └── session_card.widget.dart
│   │       └── detail/
│   │           ├── session_detail.screen.dart
│   │           ├── session_detail.view_model.dart
│   │           └── session_detail.state.dart
│   ├── settings/
│   │   └── presentation/screens/
│   │       └── settings/
│   │           ├── settings.screen.dart
│   │           ├── settings.view_model.dart
│   │           └── settings.state.dart
│   ├── onboarding/
│   │   └── presentation/screens/
│   │       └── setup/
│   │           ├── blackhole_setup.screen.dart
│   │           └── uvx_setup.screen.dart
│   └── shared/
│       └── presentation/widgets/
│           └── ...
├── foundation/
│   ├── routing/
│   │   └── app_router.dart
│   └── utils/
│       └── ...
└── main.dart
```

---

## 4. Flux de donnees detaille

### 4.1 Demarrage d'une session (FR-001, FR-002, FR-003, FR-004)

```
1. User clique "Start"
   │
2. LiveTranscriptionViewModel.startSession()
   │
3. ProcessManagerService.startServer()
   │  → Lance `uvx ... voxmlx-serve ...` (Swift Process)
   │  → Emet ServerState.starting
   │  → Parse stdout, attend "Server listening..."
   │  → Emet ServerState.ready
   │
4. AudioCaptureService.startCapture(inputDevice, outputDevice)
   │  → Demarre 2 AVAudioEngine input taps (Swift CoreAudio)
   │  → Emet AudioChunk sur EventChannel
   │
5. TranscriptionDataSource.connect(ws://localhost:8765)
   │  → Ouvre WebSocket
   │  → Emet ConnectionState.connected
   │
6. SessionRepository.createSession(...)
   │  → INSERT INTO sessions
   │
7. Boucle streaming :
   │  AudioChunk recu (EventChannel)
   │    → TranscriptionDataSource.sendAudio(chunk)
   │      → WebSocket: {"type":"input_audio_buffer.append","audio":"<b64>"}
   │    → voxmlx-serve transcrit
   │      → WebSocket: {"type":"response.audio_transcript.delta","delta":"..."}
   │        → TranscriptionDataSource.transcriptionStream emet TranscriptSegment
   │          → TranscriptRepository.saveSegment(segment)
   │            → INSERT INTO transcript_segments
   │          → LiveTranscriptionViewModel met a jour state
   │            → UI affiche la nouvelle ligne
```

### 4.2 Arret d'une session (FR-004)

```
1. User clique "Stop"
   │
2. LiveTranscriptionViewModel.stopSession()
   │
3. AudioCaptureService.stopCapture()
   │  → Arrete les taps CoreAudio
   │
4. TranscriptionDataSource.disconnect()
   │  → Ferme le WebSocket proprement
   │
5. ProcessManagerService.stopServer()
   │  → SIGTERM sur le processus voxmlx-serve
   │  → Attend 5s, SIGKILL si besoin
   │
6. SessionRepository.updateSession(id, status: completed, duration: ...)
   │  → UPDATE sessions SET status = 'completed'
   │
7. UI retourne a l'ecran principal avec la session dans l'historique
```

---

## 5. Decisions architecturales (ADRs)

### ADR-001 : WebSocket pour la communication avec voxmlx-serve

**Contexte :** voxmlx-serve (fork T0mSIlver) expose une API WebSocket compatible OpenAI Realtime API.

**Decision :** Utiliser WebSocket natif pour la communication bidirectionnelle.

**Justification :**
- Le serveur est deja concu pour ca (pas de choix a faire)
- WebSocket est ideal pour le streaming bidirectionnel audio/texte
- Faible latence par rapport a HTTP polling
- Le format OpenAI Realtime API est bien documente

**Consequence :** Dependance au format de message specifique du fork. Si le fork evolue, le format peut changer. Mitigation : abstraire le protocole derriere une interface.

### ADR-002 : Swift Platform Channels pour la capture audio

**Contexte :** Flutter n'offre pas d'API pour capturer l'audio systeme sur macOS. Les plugins existants sont limites.

**Decision :** Implementer la capture audio en Swift via Platform Channels (MethodChannel + EventChannel).

**Justification :**
- CoreAudio/AVAudioEngine est la seule API fiable pour la capture multi-device sur macOS
- Les EventChannels permettent le streaming de chunks audio vers Dart de facon asynchrone
- Le code Swift reste isole et testable independamment

**Consequence :** Plus de code natif a maintenir. Le debugging est plus complexe (2 langages). Mitigation : interface claire, logs structure, tests unitaires cote Swift.

### ADR-003 : Swift Platform Channel pour le process management

**Contexte :** `dart:io Process` fonctionne mais la gestion des signaux (SIGTERM, SIGKILL) et la detection de processus orphelins est plus robuste en Swift.

**Decision :** Gerer le lifecycle de voxmlx-serve en Swift via Platform Channel.

**Alternative consideree :** `dart:io Process` directement. Acceptable pour le MVP. Si des problemes de fiabilite apparaissent, migrer vers Swift.

**Decision finale :** Commencer avec `dart:io Process` pour le MVP (plus simple). Migrer vers Swift si necessaire.

### ADR-004 : Drift (SQLite) pour la persistance

**Contexte :** Besoin de stocker des sessions, segments et resumes avec recherche full-text.

**Decision :** Utiliser Drift (ex-Moor), un wrapper SQLite type-safe pour Dart.

**Justification :**
- SQLite est local, leger, fiable
- Drift offre une API type-safe avec code generation
- Support FTS5 pour la recherche full-text (post-MVP)
- Pas de dependance serveur

**Alternative consideree :** Isar (NoSQL). Rejete car la recherche full-text est moins mature.

### ADR-005 : ScreenCaptureKit pour la capture audio systeme

**Contexte :** Il faut capturer l'audio sortant du systeme (ce que les interlocuteurs disent dans un call).

**Decision :** Utiliser ScreenCaptureKit (macOS 13+), l'API native Apple pour la capture d'ecran et d'audio systeme.

**Justification :**
- API native Apple, pas de driver tiers a installer
- Zero friction : juste une permission systeme a accorder (dialogue natif)
- Performant et bien maintenu par Apple
- Utilise par des apps reconnues (OBS, CleanShot X)

**Alternative rejetee :** BlackHole (driver kernel). Necessite une installation manuelle via Homebrew + configuration Multi-Output Device dans Audio MIDI Setup. Friction trop importante pour l'utilisateur.

**Consequence :** macOS 13 Ventura minimum requis (deja notre cible NFR-004.1).

---

## 6. Couverture des exigences

### 6.1 Exigences fonctionnelles

| FR | Composant(s) | Comment |
|----|-------------|---------|
| FR-001 (Serveur ML) | ProcessManagerService | Lance/arrete/surveille voxmlx-serve via dart:io Process (MVP) |
| FR-002 (Capture audio) | AudioCaptureService (Swift) | ScreenCaptureKit (audio systeme) + AVAudioEngine (micro), EventChannel vers Dart |
| FR-003 (Transcription RT) | TranscriptionDataSource | WebSocket vers voxmlx-serve, streaming segments |
| FR-004 (Controle session) | LiveTranscriptionViewModel | Start/Stop/Pause, timer, raccourcis clavier |
| FR-005 (Historique) | SessionRepository + Drift | SQLite local, CRUD sessions et segments |
| FR-006 (Interface macOS) | Features transcription + history + NavigationShell | Sidebar + zone principale, menubar via `macos_ui` ou `tray_manager` |
| FR-007 (Recherche) | Drift FTS5 | Post-MVP : index full-text sur transcript_segments.text |
| FR-008 (Resume) | SummaryService + modele Mistral MLX | Post-MVP : 2e processus MLX pour le LLM |
| FR-009 (Export) | ExportService | Formatter les segments en .md ou .txt |

### 6.2 Exigences non-fonctionnelles

| NFR | Strategie |
|-----|-----------|
| NFR-001.1 (Latence < 3s) | WebSocket streaming, pas de buffering cote app, audio chunks petits (100ms) |
| NFR-001.2 (CPU < 30%) | Code Dart leger, pas de re-encoding audio, Swift natif pour le capture |
| NFR-001.3 (RAM < 200Mo) | Drift lazy loading, pas de cache de gros objets en memoire |
| NFR-001.4 (Demarrage < 3s) | App Flutter leger, le serveur ML demarre apres le UI |
| NFR-001.5 (Serveur ML < 30s) | Afficher un progress pendant le chargement du modele |
| NFR-002.1 (Zero reseau) | Tout est localhost. Verifiable : aucune permission reseau dans entitlements sauf localhost |
| NFR-002.2 (Stockage local) | SQLite dans Application Support, pas de iCloud sync |
| NFR-002.3 (Pas de telemetrie) | Aucun SDK analytics. Verifiable dans le code. |
| NFR-003.1 (Stabilite 2h+) | Sauvegarde incrementale, gestion memoire MLX (cap 4GB dans le fork) |
| NFR-003.2 (Recovery serveur) | Polling heartbeat, relance automatique proposee |
| NFR-003.3 (Sauvegarde incr.) | INSERT segment des reception, pas de batch |
| NFR-004.1 (macOS 13+) | Minimum deployment target dans Xcode |
| NFR-004.2 (Apple Silicon M1+) | MLX requis, pas de fallback Intel |
| NFR-004.3 (16Go RAM) | Documente dans le README, pas de verification runtime |
| NFR-005.1 (Clean arch) | Respecte ARCHITECTURE.md integralement |
| NFR-005.2 (GPL-3.0) | Licence dans le repo, compatible BlackHole |
| NFR-005.3 (Documentation) | README, ARCHITECTURE.md, ce document |

---

## 7. Stack technique detaillee

| Couche | Technologie | Version | Justification |
|--------|-------------|---------|---------------|
| UI Framework | Flutter | 3.x stable | Cross-platform potentiel, bon support macOS desktop |
| State Management | Riverpod 3.0 + riverpod_annotation | ^2.6 | Compile-safe, code-gen, auto-dispose |
| Immutabilite | Freezed | ^3.0 | Code-gen pour copyWith, equality, sealed classes |
| Navigation | AutoRoute | ^9.2 | Type-safe, guards, code-gen |
| Base de donnees | Drift (SQLite) | ^2.x | Type-safe, FTS5, local |
| WebSocket | web_socket_channel | ^3.x | Client WebSocket standard Dart |
| Serialisation | json_annotation + json_serializable | ^4.9 / ^6.9 | Standard Dart |
| Audio (natif) | AVAudioEngine (CoreAudio) | macOS SDK | Seule option pour multi-device capture |
| Process (natif) | dart:io Process (MVP) | Dart SDK | Simple, suffisant pour le MVP |
| ML Transcription | voxmlx-serve (Voxtral MLX 4-bit) | Fork T0mSIlver | WebSocket, OpenAI Realtime API |
| Audio Routing | BlackHole 2ch | v0.6.1 | Zero latency, standard macOS |
| Localisation | easy_localization | ^3.0 | Simple, JSON-based |
| Menubar | tray_manager ou system_tray | latest | Integration menubar macOS |

---

## 8. Securite et confidentialite

### 8.1 Entitlements macOS

```xml
<!-- macos/Runner/Release.entitlements -->
<key>com.apple.security.app-sandbox</key>
<false/>  <!-- Necessaire pour lancer des processus externes (uvx) -->

<key>com.apple.security.device.audio-input</key>
<true/>   <!-- Acces au micro -->

<key>com.apple.security.files.user-selected.read-write</key>
<true/>   <!-- Export de fichiers -->
```

**Note :** Le sandboxing est desactive car l'app doit :
1. Lancer un processus externe (uvx/voxmlx-serve)
2. Acceder a ScreenCaptureKit pour la capture audio systeme
3. Acceder a CoreAudio pour la capture multi-device

Pour la distribution (DMG, pas Mac App Store), c'est acceptable.

### 8.2 Donnees sensibles

| Donnee | Stockage | Protection |
|--------|----------|------------|
| Audio brut | Jamais persiste | Transient en memoire uniquement |
| Transcriptions | SQLite local | Chiffrement possible via SQLCipher (post-MVP) |
| Configuration | UserDefaults | Pas de donnees sensibles |

---

## 9. Risques techniques et mitigations

| Risque | Probabilite | Impact | Mitigation |
|--------|-------------|--------|------------|
| AVAudioEngine ne peut pas capturer 2 devices | Faible | Critique | Tester en spike. Fallback : 2 instances AVAudioEngine separees |
| voxmlx-serve WebSocket API change | Moyen | Haut | Interface abstraite. Le format est base sur OpenAI Realtime (standard) |
| Latence > 3s sur M1/M2 (ancien hardware) | Moyen | Haut | Tester sur differentes machines. Configurer la taille des chunks |
| voxmlx-serve leak memoire (> 4GB) | Faible | Moyen | Le fork T0mSIlver cap deja a 4GB. Monitoring usage memoire |
| Flutter macOS instabilite | Faible | Moyen | Flutter desktop est stable depuis 3.x. Pas de features experimentales |
| ScreenCaptureKit API change | Faible | Haut | API Apple stable. Surveiller les deprecated notices dans les release notes Xcode |

---

## 10. Investigations techniques pre-Sprint 1

| # | Question | Methode | Bloquant ? |
|---|----------|---------|------------|
| 1 | voxmlx-serve : quel est le format exact des messages WebSocket ? | Lancer le serveur, connecter un client WS, logger les messages | Oui |
| 2 | AVAudioEngine : peut-on capturer 2 input devices en parallele ? | Spike Swift (1/2 journee) | Oui |
| 3 | Comment configurer ScreenCaptureKit pour capturer l'audio systeme ? | Documentation Apple SCK, sample code | Non |
| 4 | Quelle latence reelle sur un M3/M5 ? | Benchmark end-to-end avec le spike | Non |
| 5 | Drift : comment configurer FTS5 pour la recherche ? | Documentation Drift | Non (post-MVP) |

---

*Ce document est la reference architecturale du projet. Toute deviation doit etre documentee ici avec justification.*
