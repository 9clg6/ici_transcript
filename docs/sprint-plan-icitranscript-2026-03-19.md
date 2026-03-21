# Sprint Plan — IciTranscript MVP

**Date:** 2026-03-19
**Capacite:** 1 developpeur (Clement), ~6h productives/jour
**Sprint duration:** 1 semaine chacun
**Velocity estimee:** ~25-30 points/sprint (solo dev)
**Refs:** PRD, Architecture

---

## Spikes prealables (Jour 1, avant Sprint 1)

> Ces investigations sont bloquantes. Elles doivent etre faites AVANT de coder les stories.

### SPIKE-001 : Format WebSocket voxmlx-serve

**Duree estimee :** 2h
**Objectif :** Documenter le format exact des messages WebSocket de voxmlx-serve

**Actions :**
1. Lancer `uvx --from "git+https://github.com/T0mSIlver/voxmlx.git[server]" voxmlx-serve --model T0mSIlver/Voxtral-Mini-4B-Realtime-2602-MLX-4bit`
2. Connecter un client WebSocket (websocat ou script Python)
3. Envoyer un chunk audio et logger la reponse
4. Documenter : format d'entree, format de sortie, handshake, heartbeat
5. Mesurer la latence

**Sortie :** Document `docs/spike-001-websocket-format.md`

### SPIKE-002 : ScreenCaptureKit + AVAudioEngine capture

**Duree estimee :** 3h
**Objectif :** Valider qu'on peut capturer l'audio systeme via ScreenCaptureKit et le micro via AVAudioEngine en parallele

**Actions :**
1. Creer un projet Swift minimal
2. Configurer ScreenCaptureKit pour capturer l'audio systeme (SCStream avec SCStreamConfiguration.capturesAudio)
3. Configurer AVAudioEngine pour capturer le micro
4. Capturer des chunks PCM depuis les 2 en parallele
5. Mesurer la latence et la consommation CPU

**Sortie :** Document `docs/spike-002-sck-audio-capture.md` + code du spike

---

## Sprint 1 — "Ca transcrit" (Semaine 1)

**Goal :** A la fin du sprint, l'app lance le serveur ML, capture l'audio, et affiche la transcription en temps reel dans une fenetre basique.

**Points totaux :** 28

### Stories

---

#### STORY-001 : Lancement automatique de voxmlx-serve

**Epic:** E1 - Serveur ML
**Priorite:** P0 (Must Have)
**Points:** 5

**User Story :**
En tant qu'utilisateur, je veux que l'app lance automatiquement le serveur de transcription quand je demarre une session, pour ne pas avoir a le faire manuellement.

**Acceptance Criteria :**
- [ ] L'app lance voxmlx-serve via `dart:io Process` avec la commande documentee
- [ ] L'app detecte quand le serveur est pret (parse stdout ou polling WS)
- [ ] L'app arrete le serveur proprement (SIGTERM) quand la session s'arrete ou l'app se ferme
- [ ] Si `uvx` n'est pas installe, un message d'erreur clair est affiche

**Technical Notes :**
- Utiliser `Process.start()` de dart:io
- Parser stdout pour detecter "Server listening on..."
- Fallback : polling WebSocket toutes les 500ms, timeout 60s
- Cleanup dans `dispose()` ou via `ProcessSignal` handler

**Dependencies :** SPIKE-001

---

#### STORY-002 : Indicateur d'etat du serveur ML

**Epic:** E1 - Serveur ML
**Priorite:** P0
**Points:** 3

**User Story :**
En tant qu'utilisateur, je veux voir l'etat du serveur ML (demarrage/pret/erreur/arrete), pour savoir quand je peux commencer a transcrire.

**Acceptance Criteria :**
- [ ] Widget affichant l'etat : starting (spinner), ready (vert), error (rouge), stopped (gris)
- [ ] Le state est un `ServerState` enum gere par un provider Riverpod
- [ ] En cas d'erreur, le message d'erreur du serveur est affiche
- [ ] Bouton "Relancer" visible en cas d'erreur

**Technical Notes :**
- `ServerState { starting, ready, error, stopped }` dans core_domain/enum
- Provider Riverpod `@Riverpod(keepAlive: true)` car le serveur est un singleton

**Dependencies :** STORY-001

---

#### STORY-003 : Capture audio micro (input)

**Epic:** E2 - Capture audio
**Priorite:** P0
**Points:** 5

**User Story :**
En tant qu'utilisateur, je veux que l'app capture l'audio de mon micro pour transcrire ce que je dis.

**Acceptance Criteria :**
- [ ] Platform Channel Swift cree (MethodChannel + EventChannel)
- [ ] Cote Swift : AVAudioEngine capture le micro par defaut
- [ ] Audio resample en 16kHz mono PCM float32
- [ ] Stream de `AudioChunk` recu cote Dart via EventChannel
- [ ] Permission micro demandee proprement (entitlement + dialogue systeme)

**Technical Notes :**
- Fichier Swift : `macos/Runner/AudioCapturePlugin.swift`
- Enregistrer le plugin dans `MainFlutterWindow.swift`
- EventChannel name : `com.icitranscript/audio_stream`
- MethodChannel name : `com.icitranscript/audio_control`
- Chunk size : 100ms (~1600 samples a 16kHz)

**Dependencies :** SPIKE-002

---

#### STORY-004 : Capture audio systeme (output via ScreenCaptureKit)

**Epic:** E2 - Capture audio
**Priorite:** P0
**Points:** 5

**User Story :**
En tant qu'utilisateur, je veux que l'app capture l'audio sortant de mon systeme (via ScreenCaptureKit) pour transcrire ce que les autres disent.

**Acceptance Criteria :**
- [ ] ScreenCaptureKit capture l'audio systeme nativement (pas de driver tiers)
- [ ] Les chunks sont taggues `source: output` pour les distinguer du micro
- [ ] La permission ScreenCaptureKit est demandee au premier lancement
- [ ] Si la permission est refusee, mode micro-only avec avertissement

**Technical Notes :**
- Utiliser SCStream avec SCStreamConfiguration (capturesAudio = true)
- SCStreamDelegate pour recevoir les buffers audio
- Resample en 16kHz mono PCM float32 (meme format que STORY-003)

**Dependencies :** STORY-003, SPIKE-002

---

#### STORY-005 : Client WebSocket vers voxmlx-serve

**Epic:** E3 - Transcription temps reel
**Priorite:** P0
**Points:** 5

**User Story :**
En tant qu'utilisateur, je veux que les chunks audio soient envoyes au serveur de transcription et que le texte transcrit revienne en streaming.

**Acceptance Criteria :**
- [ ] Client WebSocket se connecte a `ws://localhost:8765`
- [ ] Les AudioChunks sont encodes en base64 et envoyes au format documente dans SPIKE-001
- [ ] Les reponses du serveur sont parsees en `TranscriptSegment` (text, timestamp, source)
- [ ] Un `Stream<TranscriptSegment>` est expose au ViewModel
- [ ] Reconnexion automatique si la connexion est perdue

**Technical Notes :**
- Package : `web_socket_channel`
- Abstraire derriere `TranscriptionDataSource` (interface dans core_data)
- Encoder les chunks : `base64.encode(chunk.data)`

**Dependencies :** STORY-001, STORY-003, SPIKE-001

---

#### STORY-006 : Ecran de transcription en direct (UI basique)

**Epic:** E3 - Transcription temps reel + E4 - Controle session
**Priorite:** P0
**Points:** 5

**User Story :**
En tant qu'utilisateur, je veux voir le texte transcrit apparaitre en temps reel a l'ecran, avec des boutons Start/Stop et un timer.

**Acceptance Criteria :**
- [ ] Ecran avec : indicateur serveur, bouton Start, bouton Stop, timer, zone de transcription
- [ ] Le texte apparait en streaming, chaque segment sur une nouvelle ligne
- [ ] Les segments micro sont en bleu, les segments systeme en vert
- [ ] Auto-scroll vers le bas quand de nouveaux segments arrivent
- [ ] Le timer affiche la duree depuis le Start
- [ ] Respecte la triade : state.dart + view_model.dart + screen.dart

**Technical Notes :**
- `LiveTranscriptionState` : `List<TranscriptSegmentEntity>`, `isRecording`, `duration`, `serverState`
- `LiveTranscriptionViewModel` : orchestre ProcessManager + AudioCapture + WebSocket
- `LiveTranscriptionScreen` : `ConsumerStatefulWidget`, `ListView.builder` pour les segments
- Couleurs via `Theme.of(context).colorScheme` (pas de couleurs en dur)

**Dependencies :** STORY-002, STORY-005

---

### Sprint 1 — Resume

| Story | Points | Epic | Focus |
|-------|--------|------|-------|
| STORY-001 | 5 | E1 | Lancement serveur ML |
| STORY-002 | 3 | E1 | Indicateur etat serveur |
| STORY-003 | 5 | E2 | Capture audio micro |
| STORY-004 | 5 | E2 | Capture audio systeme |
| STORY-005 | 5 | E3 | Client WebSocket transcription |
| STORY-006 | 5 | E3/E4 | UI transcription + controles |
| **Total** | **28** | | |

**Ordre d'implementation recommande :**
```
Jour 1 : SPIKE-001 + SPIKE-002 (investigations)
Jour 2 : STORY-001 (serveur ML) + STORY-002 (indicateur)
Jour 3 : STORY-003 (capture micro Swift)
Jour 4 : STORY-004 (capture systeme BlackHole) + STORY-005 (WebSocket)
Jour 5 : STORY-006 (UI) + integration end-to-end + bug fixes
```

---

## Sprint 2 — "App complete" (Semaine 2)

**Goal :** A la fin du sprint, l'app est une vraie application macOS avec historique, sidebar, menubar, preferences et permission audio systeme.

**Points totaux :** 27

### Stories

---

#### STORY-007 : Persistance des sessions (SQLite/Drift)

**Epic:** E5 - Historique
**Priorite:** P1
**Points:** 5

**User Story :**
En tant qu'utilisateur, je veux que chaque session soit automatiquement sauvegardee avec date, duree et contenu.

**Acceptance Criteria :**
- [ ] Base Drift creee avec tables `sessions` et `transcript_segments` (schema de l'architecture)
- [ ] Chaque segment est insere en base au fur et a mesure de la reception (incrementale)
- [ ] A l'arret de la session, le statut passe a `completed` et la duree est calculee
- [ ] Le titre par defaut est "Session YYYY-MM-DD HH:mm"

**Technical Notes :**
- Package : `drift` + `drift_dev` + `sqlite3_flutter_libs`
- Database singleton via `@Riverpod(keepAlive: true)`
- Fichier DB dans `getApplicationSupportDirectory()`

**Dependencies :** Aucune

---

#### STORY-008 : Liste des sessions (sidebar)

**Epic:** E5 - Historique + E6 - Interface
**Priorite:** P1
**Points:** 5

**User Story :**
En tant qu'utilisateur, je veux voir la liste de mes sessions passees dans une sidebar, triees par date.

**Acceptance Criteria :**
- [ ] Sidebar affichant les sessions triees par date decroissante
- [ ] Chaque carte affiche : titre, date, duree
- [ ] Cliquer sur une session affiche la transcription dans la zone principale
- [ ] La session en cours est indiquee visuellement

**Technical Notes :**
- `SessionListViewModel` watche un stream Drift (reactive)
- Layout : `Row` avec sidebar fixe (250px) + zone principale flexible
- Utiliser `NavigationSplit` ou `Row` + `VerticalDivider`

**Dependencies :** STORY-007

---

#### STORY-009 : Detail d'une session passee

**Epic:** E5 - Historique
**Priorite:** P1
**Points:** 3

**User Story :**
En tant qu'utilisateur, je veux cliquer sur une session pour relire la transcription complete.

**Acceptance Criteria :**
- [ ] Ecran detail affichant tous les segments de la session
- [ ] Segments affiches avec timestamp, source (couleur) et texte
- [ ] Bouton renommer la session (inline edit du titre)
- [ ] Bouton supprimer avec confirmation

**Technical Notes :**
- Charger les segments via `TranscriptRepository.getSegmentsBySession(sessionId)`
- `SessionDetailState` : session + segments

**Dependencies :** STORY-007, STORY-008

---

#### STORY-010 : Layout principal 2 colonnes

**Epic:** E6 - Interface macOS
**Priorite:** P1
**Points:** 5

**User Story :**
En tant qu'utilisateur, je veux une app avec sidebar (historique) et zone principale (transcription en cours ou session passee).

**Acceptance Criteria :**
- [ ] Layout 2 colonnes : sidebar + main content
- [ ] La sidebar affiche la liste des sessions (STORY-008)
- [ ] La zone principale affiche soit la transcription en direct, soit le detail d'une session
- [ ] Navigation fluide entre les 2 modes
- [ ] Taille de fenetre par defaut : 1000x700

**Technical Notes :**
- Shell screen avec `NavigationRail` ou layout custom `Row`
- AutoRoute nested navigation pour la zone principale
- macOS window config dans `macos/Runner/MainFlutterWindow.swift`

**Dependencies :** STORY-006, STORY-008

---

#### STORY-011 : Integration menubar macOS

**Epic:** E6 - Interface macOS
**Priorite:** P1
**Points:** 3

**User Story :**
En tant qu'utilisateur, je veux une icone dans la barre de menu macOS pour acceder rapidement a l'app et controler la transcription.

**Acceptance Criteria :**
- [ ] Icone dans la menubar macOS
- [ ] Menu contextuel avec : Start/Stop transcription, etat du serveur, ouvrir l'app
- [ ] L'icone change selon l'etat (idle, recording, error)

**Technical Notes :**
- Package : `tray_manager` ou `system_tray`
- Ou natif Swift via Platform Channel
- L'app reste en background quand on ferme la fenetre (pas de quit)

**Dependencies :** STORY-001

---

#### STORY-012 : Permission audio systeme et premier lancement

**Epic:** E2 - Capture audio
**Priorite:** P1
**Points:** 2

**User Story :**
En tant qu'utilisateur, je veux que l'app me demande la permission de capturer l'audio systeme au premier lancement, pour que tout fonctionne sans configuration manuelle.

**Acceptance Criteria :**
- [ ] Au premier lancement, l'app demande la permission ScreenCaptureKit via le dialogue natif macOS
- [ ] Si accordee : l'app fonctionne normalement (micro + audio systeme)
- [ ] Si refusee : l'app fonctionne en mode micro-only avec un bandeau d'avertissement
- [ ] Un bouton dans les preferences permet de re-demander la permission (ouvre System Settings)
- [ ] Aussi verifier si `uvx` est disponible dans le PATH

**Technical Notes :**
- `SCShareableContent.current` declenche le dialogue de permission
- Stocker l'etat de la permission dans les preferences

**Dependencies :** STORY-004

---

#### STORY-013 : Ecran de preferences

**Epic:** E6 - Interface macOS
**Priorite:** P1
**Points:** 2

**User Story :**
En tant qu'utilisateur, je veux un ecran de preferences pour selectionner mes peripheriques audio.

**Acceptance Criteria :**
- [ ] Accessible depuis le menu ou un bouton dans la sidebar
- [ ] Selection du micro (dropdown des devices input)
- [ ] Selection du device de capture systeme (dropdown, BlackHole pre-selectionne)
- [ ] Les preferences sont persistees (SharedPreferences ou UserDefaults)

**Technical Notes :**
- Utiliser le MethodChannel pour lister les devices audio
- `SettingsState` avec `selectedInputDevice` et `selectedOutputDevice`

**Dependencies :** STORY-003

---

#### STORY-014 : Raccourci clavier global Start/Stop

**Epic:** E4 - Controle session
**Priorite:** P1
**Points:** 2

**User Story :**
En tant qu'utilisateur, je veux un raccourci clavier global pour demarrer/arreter la transcription meme quand l'app n'est pas au premier plan.

**Acceptance Criteria :**
- [ ] Raccourci par defaut : `Cmd+Shift+T` pour toggle Start/Stop
- [ ] Fonctionne meme quand l'app est en arriere-plan
- [ ] Configurable dans les preferences (post-MVP nice-to-have)

**Technical Notes :**
- Package : `hotkey_manager` ou natif via `NSEvent.addGlobalMonitorForEvents`
- Platform Channel si le package ne fonctionne pas bien sur macOS

**Dependencies :** STORY-006

---

### Sprint 2 — Resume

| Story | Points | Epic | Focus |
|-------|--------|------|-------|
| STORY-007 | 5 | E5 | Persistance SQLite |
| STORY-008 | 5 | E5/E6 | Sidebar liste sessions |
| STORY-009 | 3 | E5 | Detail session passee |
| STORY-010 | 5 | E6 | Layout 2 colonnes |
| STORY-011 | 3 | E6 | Menubar macOS |
| STORY-012 | 2 | E2 | Permission audio systeme |
| STORY-013 | 2 | E6 | Preferences audio |
| STORY-014 | 2 | E4 | Raccourci clavier global |
| **Total** | **27** | | |

**Ordre d'implementation recommande :**
```
Jour 1 : STORY-007 (Drift DB) + STORY-012 (permission audio)
Jour 2 : STORY-010 (layout 2 colonnes) + STORY-008 (sidebar)
Jour 3 : STORY-009 (detail session) + integrer persistence dans STORY-006
Jour 4 : STORY-011 (menubar) + STORY-013 (preferences)
Jour 5 : STORY-014 (raccourci clavier) + polish + tests manuels + bug fixes
```

---

## Backlog Post-MVP (Sprint 3+)

| Story | Points | Epic | Description |
|-------|--------|------|-------------|
| STORY-015 | 5 | E7 | Recherche full-text (Drift FTS5) |
| STORY-016 | 3 | E7 | Highlight des resultats de recherche |
| STORY-017 | 2 | E9 | Export Markdown |
| STORY-018 | 1 | E9 | Export texte brut |
| STORY-019 | 1 | E9 | Copier dans le presse-papier |
| STORY-020 | 5 | E8 | Lancement modele Mistral local pour resume |
| STORY-021 | 5 | E8 | Generation et affichage du resume |
| STORY-022 | 3 | E8 | Sauvegarde resume avec la session |
| STORY-023 | 5 | E10 | Mode fenetre flottante overlay |
| STORY-024 | 3 | E10 | Bascule entre mode app et mode overlay |
| STORY-025 | 3 | E4 | Pause/Resume session |

---

## Definition of Done (pour toutes les stories)

- [ ] Code respecte ARCHITECTURE.md (DDD, nommage, immutabilite)
- [ ] Types explicites partout (`always_specify_types`)
- [ ] Documentation `///` sur toute API publique
- [ ] Pas de strings en dur (LocaleKeys si affiche a l'utilisateur)
- [ ] State immutable (Freezed)
- [ ] Providers Riverpod avec code-gen
- [ ] Teste manuellement sur macOS

---

*Ce sprint plan est la reference pour l'implementation. Les stories sont ordonnees par dependance et valeur.*
