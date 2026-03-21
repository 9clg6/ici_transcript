# Product Brief — IciTranscript

**Date:** 2026-03-19
**Auteur:** Clement
**Statut:** DRAFT
**Niveau projet:** 2 (Moyen)

---

## 1. Probleme et contexte

### Le probleme

Les outils de transcription vocale existants (Otter.ai, Whisper cloud, Google Meet captions) envoient les donnees audio sur des serveurs distants. Pour un utilisateur soucieux de la souverainete et de la confidentialite de ses donnees — entretiens professionnels, reunions strategiques, interviews sensibles — c'est un risque inacceptable.

Aujourd'hui, il est possible de faire tourner des modeles de transcription performants en local sur Apple Silicon (via MLX), mais la mise en place est entierement manuelle :
- Lancer voxmlx-serve en CLI
- Configurer BlackHole pour capturer l'audio systeme
- Modifier les parametres audio de macOS a la main
- Pas d'interface visuelle, pas d'historique, pas de resume

**Le setup actuel fonctionne mais n'est pas utilisable au quotidien.**

### Pourquoi maintenant ?

- Les modeles de transcription en temps reel (Voxtral-Mini-4B-Realtime) sont suffisamment performants pour tourner sur Apple Silicon en local
- MLX permet une inference rapide et efficace sur les puces M-series
- BlackHole offre un Developer Guide permettant l'integration programmatique du routage audio
- Aucun outil open-source n'offre cette experience "cle en main" sur macOS avec tout en local

### Impact si non resolu

- Perte de temps quotidienne a configurer manuellement l'environnement
- Pas de trace exploitable des reunions/entretiens
- Dependance a des outils cloud pour la transcription = risque donnees
- Impossibilite de partager facilement un resume de reunion

---

## 2. Utilisateurs cibles

### Persona principal : Le professionnel tech-savvy soucieux de sa vie privee

- **Profil :** Developpeur, consultant, entrepreneur, chercheur
- **Contexte :** Travaille sur macOS avec Apple Silicon (M1-M5)
- **Besoins :**
  - Transcrire en temps reel reunions visio, calls, cours, presentations, interviews
  - Conserver un historique cherchable de toutes les transcriptions
  - Obtenir des resumes automatiques des echanges
  - Ne jamais envoyer ses donnees audio/texte a l'exterieur
- **Frustrations :**
  - Les outils cloud posent des problemes de confidentialite
  - Les solutions locales sont trop techniques a configurer
  - Pas d'outil "cle en main" qui combine transcription temps reel + resume + historique en local

### Utilisateur initial

Clement — premier utilisateur quotidien. Le produit doit repondre a SES besoins concrets avant tout.

### Audience secondaire (post-MVP)

Communaute open-source : utilisateurs macOS Apple Silicon cherchant une alternative privee aux outils de transcription cloud.

---

## 3. Solution proposee

### Vision

**IciTranscript** est une application macOS native qui offre une transcription vocale en temps reel, entierement locale, avec affichage sous-titres en direct, historique persistent et resumes automatiques.

### Comment ca marche

```
Audio Input (Micro) ──┐
                       ├──→ voxmlx-serve (Voxtral MLX, local)
Audio Output (System) ─┘        │
   via BlackHole                │
                                ▼
                     Transcription temps reel
                                │
                                ▼
                     IciTranscript (Flutter macOS)
                     ├── Sous-titres en direct
                     ├── Historique persistent
                     ├── Recherche full-text
                     └── Resume auto (Mistral MLX, local)
```

### Proposition de valeur unique

1. **100% local** — zero donnee envoyee a l'exterieur
2. **Cle en main** — l'app gere le lancement du serveur ML, le routage audio, tout
3. **Temps reel** — affichage sous-titres en direct pendant que quelqu'un parle
4. **Multilingue** — francais et anglais principalement, autres langues supportees par Voxtral
5. **Open-source** — code ouvert, communaute, transparence

---

## 4. Features cles

### MVP (Sprint 1-2 — objectif 1-2 semaines)

| # | Feature | Priorite | Description |
|---|---------|----------|-------------|
| F1 | **Transcription temps reel** | P0 | Capture et transcription en streaming via Voxtral-Mini-4B-Realtime-MLX |
| F2 | **Capture audio duale** | P0 | Capture simultanee micro (input) + audio systeme (output) via BlackHole |
| F3 | **Affichage sous-titres** | P0 | Rendu en direct du texte transcrit, style sous-titres |
| F4 | **Gestion automatique du serveur ML** | P0 | L'app lance/arrete voxmlx-serve automatiquement |
| F5 | **Historique des sessions** | P1 | Sauvegarde locale de chaque session de transcription |
| F6 | **App macOS complete** | P1 | App avec sidebar (historique) + zone principale (transcription) |
| F7 | **Menubar integration** | P1 | Icone dans la barre de menu macOS pour acces rapide |

### Post-MVP (Sprint 3+)

| # | Feature | Priorite | Description |
|---|---------|----------|-------------|
| F8 | **Resume automatique** | P2 | Generation de resumes via modele Mistral local (MLX) |
| F9 | **Recherche full-text** | P2 | Recherche dans l'historique de toutes les transcriptions |
| F10 | **Mode fenetre flottante/overlay** | P2 | Sous-titres en overlay par-dessus les autres apps |
| F11 | **Export** | P2 | Export en Markdown, TXT, JSON |
| F12 | **Diarization** | P3 | Distinction des locuteurs (si supporte par le modele) |
| F13 | **Raccourcis clavier globaux** | P2 | Start/Stop transcription via hotkeys |

---

## 5. Contraintes et hypotheses

### Contraintes techniques

| Contrainte | Detail |
|------------|--------|
| **Tout en local** | Aucun appel reseau pour la transcription ou les resumes. Les modeles ML tournent sur la machine. |
| **macOS uniquement (v1)** | Cible macOS avec Apple Silicon (M1+). Pas de Windows/Linux pour le MVP. |
| **Apple Silicon requis** | MLX necessite une puce Apple Silicon pour l'inference. |
| **BlackHole requis** | Pour capturer l'audio systeme. L'app doit gerer son installation/configuration ou guider l'utilisateur. |
| **Performance temps reel** | La transcription doit etre suffisamment rapide pour suivre la parole en direct (latence < 2-3s). |
| **RAM/GPU** | Le modele Voxtral-Mini-4B-Realtime-MLX-4bit necessite ~4-6 Go de RAM GPU. L'app doit fonctionner sur des configs "bonnes/moyennes". |

### Hypotheses

1. Voxtral-Mini-4B-Realtime fournit une qualite de transcription suffisante en francais et anglais pour un usage quotidien
2. La latence de transcription sur un MacBook Pro M5 sera acceptable (< 2-3s)
3. BlackHole peut etre integre programmatiquement via son Developer Guide (pas juste config manuelle)
4. voxmlx-serve peut etre lance/arrete de facon fiable depuis un processus Dart/Flutter
5. Le modele 4-bit est un bon compromis performance/qualite pour des machines "moyennes"

### Dependances externes

| Dependance | Risque | Mitigation |
|------------|--------|------------|
| **voxmlx-serve** (T0mSIlver) | Projet tiers, peut casser | Fork si necessaire, contribuer au projet |
| **Voxtral-Mini-4B-Realtime** (Mistral) | Modele specifique, peut evoluer | Abstraire l'interface modele pour supporter d'autres backends |
| **BlackHole** (ExistentialAudio) | Open-source, stable | Bien documente, alternative : Soundflower |
| **MLX** (Apple) | Maintenu par Apple | Risque faible, ecosysteme en croissance |
| **Flutter macOS** | Support desktop mature | Stable depuis Flutter 3.x |

---

## 6. Metriques de succes

### MVP

| Metrique | Objectif |
|----------|----------|
| **Latence transcription** | < 3 secondes entre la parole et l'affichage |
| **Stabilite** | Session de transcription stable pendant 2h+ sans crash |
| **Qualite transcription FR** | Comprehensible sans relecture excessive (>85% precision) |
| **Qualite transcription EN** | Comprehensible sans relecture excessive (>85% precision) |
| **Temps de setup** | < 2 minutes de l'installation au premier usage |
| **Usage quotidien** | Utilise par Clement au moins 3x/semaine |

### Post-MVP

| Metrique | Objectif |
|----------|----------|
| **Resume qualite** | Le resume capture les points cles d'une reunion de 30min |
| **Recherche** | Retrouver une info dans l'historique en < 10 secondes |
| **Stars GitHub** | Indicateur d'interet communautaire |

---

## 7. Risques et mitigations

| Risque | Probabilite | Impact | Mitigation |
|--------|-------------|--------|------------|
| Voxtral qualite insuffisante en francais | Moyen | Haut | Tester d'autres modeles MLX (Whisper-MLX en fallback) |
| Latence trop elevee sur config moyenne | Moyen | Haut | Parametres de qualite ajustables, modeles plus petits en option |
| BlackHole integration complexe | Faible | Moyen | Fallback : guide d'installation manuelle + detection auto |
| voxmlx-serve instable | Moyen | Haut | Fork du projet, contribuer fixes upstream |
| Flutter macOS limitations audio | Moyen | Haut | Plugins natifs Swift via platform channels si necessaire |
| Consommation RAM/CPU excessive | Moyen | Moyen | Monitoring dans l'app, mode eco avec modeles plus legers |

---

## 8. Perimetre explicitement hors scope (v1)

- Support Windows/Linux
- Mode cloud/SaaS
- Diarization avancee (distinction multi-locuteurs)
- Traduction en temps reel
- Streaming vers des services tiers
- Application mobile (iOS/Android)
- Comptes utilisateur / authentification

---

## 9. Architecture technique (apercu)

Detaillee dans `ARCHITECTURE.md`. Points cles :

- **Frontend :** Flutter macOS (monorepo avec packages separes)
- **Transcription :** voxmlx-serve (Voxtral-Mini-4B-Realtime-MLX-4bit) lance en processus enfant
- **Audio routing :** BlackHole (capture audio systeme)
- **Resume :** Modele Mistral local via MLX
- **Stockage :** SQLite local (historique, recherche)
- **State management :** Riverpod 3.0
- **Communication app <-> serveur ML :** WebSocket ou HTTP streaming (API voxmlx-serve)

---

## 10. Prochaines etapes

1. **PRD** — Detailler les user stories et criteres d'acceptation pour le MVP
2. **Architecture technique** — Definir l'integration BlackHole, la communication avec voxmlx-serve, le schema de stockage
3. **Sprint planning** — Decouper le MVP en stories implementables
4. **Developpement** — Sprint 1 : transcription temps reel + affichage

---

*Ce document est la base de toutes les decisions produit. Tout changement de perimetre doit y etre reflete.*
