# PRD — IciTranscript

**Date:** 2026-03-19
**Auteur:** Clement
**Statut:** DRAFT
**Ref:** product-brief-icitranscript-2026-03-19.md
**Niveau projet:** 2

---

## 1. Vue d'ensemble

### 1.1 Objectif

Creer une application macOS native de transcription vocale en temps reel, entierement locale, qui :
- Capture simultanement l'audio entrant (micro) et sortant (systeme)
- Transcrit en streaming via Voxtral-Mini-4B-Realtime (MLX) tournant en local
- Affiche les sous-titres en direct
- Sauvegarde un historique cherchable
- Propose une experience "cle en main" (lancement auto du serveur ML, detection BlackHole)

### 1.2 Indicateurs de succes

| KPI | Cible MVP |
|-----|-----------|
| Latence transcription | < 3s entre parole et affichage |
| Stabilite session | 2h+ sans crash |
| Precision FR/EN | > 85% |
| Temps premier usage | < 2 min apres installation |
| Usage Clement | 3x/semaine minimum |

### 1.3 Parties prenantes

| Role | Qui |
|------|-----|
| Product Owner | Clement |
| Utilisateur principal | Clement |
| Communaute | Contributeurs open-source (futur) |

---

## 2. Exigences fonctionnelles

### FR-001 : Lancement et gestion du serveur de transcription

**Priorite:** Must Have (P0)

L'application doit pouvoir lancer, surveiller et arreter le serveur voxmlx-serve automatiquement.

| ID | Exigence | Critere d'acceptation |
|----|----------|----------------------|
| FR-001.1 | L'app lance voxmlx-serve au demarrage d'une session | Le processus voxmlx-serve est demarre en arriere-plan avec les bons parametres (modele Voxtral-Mini-4B-Realtime-2602-MLX-4bit) |
| FR-001.2 | L'app detecte si le serveur est pret | L'app attend que le serveur reponde avant de demarrer la transcription, avec indicateur visuel de chargement |
| FR-001.3 | L'app arrete le serveur a la fermeture | Le processus est proprement tue quand l'app se ferme ou quand l'utilisateur arrete la session |
| FR-001.4 | L'app gere les erreurs du serveur | Si le serveur crash, l'app affiche un message d'erreur et propose de relancer |
| FR-001.5 | L'app affiche l'etat du serveur | Indicateur visible : demarrage / pret / erreur / arrete |

### FR-002 : Capture audio duale (input + output)

**Priorite:** Must Have (P0)

L'application doit capturer simultanement l'audio du micro et l'audio systeme.

| ID | Exigence | Critere d'acceptation |
|----|----------|----------------------|
| FR-002.1 | Capture de l'audio micro (input) | L'app accede au micro selectionne et envoie le flux audio au serveur de transcription |
| FR-002.2 | Capture de l'audio systeme (output) via ScreenCaptureKit | L'audio sortant du systeme est capture nativement via ScreenCaptureKit (macOS 13+), sans driver tiers |
| FR-002.3 | Permission audio systeme | L'app demande la permission ScreenCaptureKit au premier lancement via le dialogue natif macOS |
| FR-002.4 | Fallback si permission refusee | Si l'utilisateur refuse la permission, l'app fonctionne en mode micro-only avec un message expliquant que l'audio systeme ne sera pas capture |
| FR-002.5 | Selection des peripheriques audio | L'utilisateur peut choisir le micro et le peripherique de capture systeme dans les preferences |
| FR-002.6 | Indicateur niveaux audio | Visualisation en temps reel que l'audio est bien capture (VU meter ou indicateur simple) |

### FR-003 : Transcription en temps reel

**Priorite:** Must Have (P0)

L'application doit afficher la transcription au fur et a mesure que les mots sont prononces.

| ID | Exigence | Critere d'acceptation |
|----|----------|----------------------|
| FR-003.1 | Streaming de la transcription | Le texte apparait progressivement a l'ecran pendant que la personne parle |
| FR-003.2 | Support multilingue | La transcription fonctionne en francais et en anglais au minimum |
| FR-003.3 | Horodatage des segments | Chaque segment de transcription est associe a un timestamp |
| FR-003.4 | Distinction input/output | Les flux micro et systeme sont visuellement distincts (couleur ou label differents) |
| FR-003.5 | Scrolling automatique | La vue scroll automatiquement vers le dernier texte transcrit |

### FR-004 : Controle de session

**Priorite:** Must Have (P0)

L'utilisateur doit pouvoir demarrer et arreter une session de transcription.

| ID | Exigence | Critere d'acceptation |
|----|----------|----------------------|
| FR-004.1 | Bouton Start | Un bouton demarre la session (lance le serveur si besoin, commence la capture) |
| FR-004.2 | Bouton Stop | Un bouton arrete la session et sauvegarde automatiquement la transcription |
| FR-004.3 | Bouton Pause/Resume | Possibilite de mettre en pause sans perdre le contexte de session |
| FR-004.4 | Duree de session affichee | Un timer visible indique la duree de la session en cours |
| FR-004.5 | Raccourci clavier global | Start/Stop/Pause accessibles via raccourci clavier meme quand l'app n'est pas au premier plan |

### FR-005 : Historique des sessions

**Priorite:** Should Have (P1)

L'application doit sauvegarder et permettre de consulter les sessions passees.

| ID | Exigence | Critere d'acceptation |
|----|----------|----------------------|
| FR-005.1 | Sauvegarde automatique | Chaque session est sauvegardee localement avec : texte transcrit, date, duree, titre |
| FR-005.2 | Titre editable | L'utilisateur peut renommer une session |
| FR-005.3 | Liste des sessions | La sidebar affiche la liste des sessions passees triees par date |
| FR-005.4 | Consultation d'une session | Cliquer sur une session affiche la transcription complete |
| FR-005.5 | Suppression d'une session | L'utilisateur peut supprimer une session avec confirmation |

### FR-006 : Interface principale (app macOS)

**Priorite:** Should Have (P1)

L'application doit offrir une interface macOS native avec sidebar et zone principale.

| ID | Exigence | Critere d'acceptation |
|----|----------|----------------------|
| FR-006.1 | Layout 2 colonnes | Sidebar (historique) + zone principale (transcription en cours ou session passee) |
| FR-006.2 | Icone menubar | Icone dans la barre de menu macOS pour acces rapide |
| FR-006.3 | Menubar actions | Depuis la menubar : Start/Stop, voir etat du serveur, ouvrir l'app |
| FR-006.4 | Preferences | Ecran de preferences : selection audio, raccourcis, chemin stockage |

### FR-007 : Recherche dans l'historique

**Priorite:** Could Have (P2)

| ID | Exigence | Critere d'acceptation |
|----|----------|----------------------|
| FR-007.1 | Recherche full-text | Barre de recherche dans la sidebar filtrant les sessions par contenu |
| FR-007.2 | Highlight des resultats | Les termes recherches sont mis en surbrillance dans la transcription |

### FR-008 : Resume automatique

**Priorite:** Could Have (P2)

| ID | Exigence | Critere d'acceptation |
|----|----------|----------------------|
| FR-008.1 | Generation de resume | Bouton "Resumer" sur une session terminee, utilisant un modele Mistral local via MLX |
| FR-008.2 | Resume structure | Le resume contient : points cles, decisions, actions a mener |
| FR-008.3 | Resume sauvegarde | Le resume est sauvegarde avec la session |

### FR-009 : Export

**Priorite:** Could Have (P2)

| ID | Exigence | Critere d'acceptation |
|----|----------|----------------------|
| FR-009.1 | Export Markdown | Exporter une session en fichier .md |
| FR-009.2 | Export texte brut | Exporter en .txt |
| FR-009.3 | Copier dans le presse-papier | Bouton copier la transcription complete |

---

## 3. Exigences non-fonctionnelles

### NFR-001 : Performance

| ID | Exigence | Cible |
|----|----------|-------|
| NFR-001.1 | Latence transcription | < 3 secondes entre parole et affichage texte |
| NFR-001.2 | Usage CPU en session active | < 30% d'un coeur (hors serveur ML) |
| NFR-001.3 | Usage RAM app Flutter | < 200 Mo (hors serveur ML) |
| NFR-001.4 | Demarrage de l'app | < 3 secondes jusqu'a l'ecran principal |
| NFR-001.5 | Demarrage serveur ML | < 30 secondes pour le chargement du modele |

### NFR-002 : Securite et confidentialite

| ID | Exigence | Cible |
|----|----------|-------|
| NFR-002.1 | Zero appel reseau | Aucune donnee audio ou textuelle ne quitte la machine |
| NFR-002.2 | Stockage local uniquement | Toutes les donnees sont stockees dans le repertoire local de l'app |
| NFR-002.3 | Pas de telemetrie | Aucun tracking, analytics ou telemetrie |

### NFR-003 : Fiabilite

| ID | Exigence | Cible |
|----|----------|-------|
| NFR-003.1 | Stabilite session longue | Session stable pendant 2h+ sans crash ni degradation |
| NFR-003.2 | Recovery serveur ML | Si le serveur crash, l'app detecte et propose de relancer en < 5s |
| NFR-003.3 | Sauvegarde incrementale | La transcription est sauvegardee au fur et a mesure, pas seulement a la fin |

### NFR-004 : Compatibilite

| ID | Exigence | Cible |
|----|----------|-------|
| NFR-004.1 | macOS minimum | macOS 13 Ventura ou superieur |
| NFR-004.2 | Hardware minimum | Apple Silicon M1 ou superieur |
| NFR-004.3 | RAM minimum machine | 16 Go recommande (modele 4-bit ~4-6 Go GPU) |

### NFR-005 : Maintenabilite

| ID | Exigence | Cible |
|----|----------|-------|
| NFR-005.1 | Architecture clean | Monorepo Flutter respectant ARCHITECTURE.md (DDD, SOLID) |
| NFR-005.2 | Open-source ready | Licence GPL-3.0 (compatible avec BlackHole) |
| NFR-005.3 | Documentation | README d'installation, ARCHITECTURE.md, contribution guide |

---

## 4. Epics et User Stories — MVP

### Epic 1 : Serveur ML (FR-001)

**Objectif :** Gerer le cycle de vie du serveur de transcription

| Story | Description | Points | Priorite |
|-------|-------------|--------|----------|
| E1-S1 | En tant qu'utilisateur, je veux que l'app lance automatiquement le serveur ML quand je demarre une session, pour ne pas avoir a le faire manuellement | 5 | P0 |
| E1-S2 | En tant qu'utilisateur, je veux voir l'etat du serveur ML (chargement/pret/erreur), pour savoir quand je peux commencer | 3 | P0 |
| E1-S3 | En tant qu'utilisateur, je veux que le serveur s'arrete proprement quand je ferme l'app, pour ne pas gaspiller mes ressources | 2 | P0 |
| E1-S4 | En tant qu'utilisateur, si le serveur crash je veux etre informe et pouvoir le relancer d'un clic | 3 | P0 |

**Criteres d'acceptation Epic :**
- Le serveur voxmlx-serve demarre avec la commande `uvx --from "git+https://github.com/T0mSIlver/voxmlx.git[server]" voxmlx-serve --model T0mSIlver/Voxtral-Mini-4B-Realtime-2602-MLX-4bit`
- Le processus est supervise (heartbeat ou polling du endpoint health)
- Le processus est kill au shutdown de l'app (SIGTERM puis SIGKILL)

---

### Epic 2 : Capture audio (FR-002)

**Objectif :** Capturer simultanement audio micro et audio systeme

| Story | Description | Points | Priorite |
|-------|-------------|--------|----------|
| E2-S1 | En tant qu'utilisateur, je veux que l'app capture l'audio de mon micro, pour transcrire ce que je dis | 5 | P0 |
| E2-S2 | En tant qu'utilisateur, je veux que l'app capture l'audio sortant de mon systeme (via BlackHole), pour transcrire ce que les autres disent dans un call | 8 | P0 |
| E2-S3 | En tant qu'utilisateur, je veux que l'app demande la permission de capturer l'audio systeme au premier lancement | 2 | P0 |
| E2-S4 | En tant qu'utilisateur, je veux pouvoir choisir mes peripheriques audio dans les preferences | 3 | P1 |
| E2-S5 | En tant qu'utilisateur, je veux voir un indicateur que l'audio est bien capture (VU meter) | 2 | P1 |

**Criteres d'acceptation Epic :**
- L'app capture 2 flux audio en parallele (input micro + output systeme via BlackHole)
- Les flux sont envoyes au serveur ML pour transcription
- Si la permission ScreenCaptureKit est refusee, l'app fonctionne en mode micro-only avec un avertissement

---

### Epic 3 : Transcription temps reel (FR-003)

**Objectif :** Afficher la transcription en streaming

| Story | Description | Points | Priorite |
|-------|-------------|--------|----------|
| E3-S1 | En tant qu'utilisateur, je veux voir le texte apparaitre au fur et a mesure que quelqu'un parle, comme des sous-titres | 8 | P0 |
| E3-S2 | En tant qu'utilisateur, je veux distinguer visuellement ce qui vient de mon micro vs ce qui vient de l'audio systeme | 3 | P0 |
| E3-S3 | En tant qu'utilisateur, je veux que la vue scroll automatiquement vers le dernier texte | 2 | P0 |
| E3-S4 | En tant qu'utilisateur, je veux voir l'horodatage de chaque segment de transcription | 2 | P1 |

**Criteres d'acceptation Epic :**
- Le texte apparait en streaming (mot par mot ou phrase par phrase selon le modele)
- 2 couleurs/labels distincts pour input vs output
- Auto-scroll activable/desactivable
- Latence < 3 secondes

---

### Epic 4 : Controle de session (FR-004)

**Objectif :** Demarrer, arreter et controler une session

| Story | Description | Points | Priorite |
|-------|-------------|--------|----------|
| E4-S1 | En tant qu'utilisateur, je veux un bouton Start pour demarrer la transcription | 2 | P0 |
| E4-S2 | En tant qu'utilisateur, je veux un bouton Stop pour arreter la session et sauvegarder | 2 | P0 |
| E4-S3 | En tant qu'utilisateur, je veux voir la duree de ma session en cours | 1 | P0 |
| E4-S4 | En tant qu'utilisateur, je veux pouvoir mettre en pause et reprendre la session | 3 | P1 |
| E4-S5 | En tant qu'utilisateur, je veux un raccourci clavier global pour Start/Stop | 3 | P1 |

**Criteres d'acceptation Epic :**
- Boutons Start/Stop visibles et clairs
- Stop sauvegarde automatiquement la session
- Timer visible pendant la session

---

### Epic 5 : Historique (FR-005)

**Objectif :** Sauvegarder et consulter les sessions passees

| Story | Description | Points | Priorite |
|-------|-------------|--------|----------|
| E5-S1 | En tant qu'utilisateur, je veux que chaque session soit automatiquement sauvegardee avec date, duree et contenu | 5 | P1 |
| E5-S2 | En tant qu'utilisateur, je veux voir la liste de mes sessions passees dans la sidebar | 3 | P1 |
| E5-S3 | En tant qu'utilisateur, je veux cliquer sur une session pour relire la transcription | 2 | P1 |
| E5-S4 | En tant qu'utilisateur, je veux pouvoir renommer une session | 1 | P1 |
| E5-S5 | En tant qu'utilisateur, je veux pouvoir supprimer une session | 1 | P1 |

**Criteres d'acceptation Epic :**
- Stockage SQLite local
- Sauvegarde incrementale (pas de perte si crash)
- Liste triee par date decroissante

---

### Epic 6 : Interface macOS (FR-006)

**Objectif :** Application macOS native avec sidebar et menubar

| Story | Description | Points | Priorite |
|-------|-------------|--------|----------|
| E6-S1 | En tant qu'utilisateur, je veux une app avec sidebar (historique) et zone principale (transcription) | 5 | P1 |
| E6-S2 | En tant qu'utilisateur, je veux une icone dans la barre de menu macOS | 3 | P1 |
| E6-S3 | En tant qu'utilisateur, je veux pouvoir Start/Stop depuis la menubar sans ouvrir l'app | 3 | P1 |
| E6-S4 | En tant qu'utilisateur, je veux un ecran de preferences (peripheriques audio, raccourcis) | 3 | P1 |

---

## 5. Epics Post-MVP

### Epic 7 : Recherche (FR-007) — P2

| Story | Description | Points |
|-------|-------------|--------|
| E7-S1 | Recherche full-text dans l'historique | 5 |
| E7-S2 | Highlight des resultats dans la transcription | 3 |

### Epic 8 : Resume automatique (FR-008) — P2

| Story | Description | Points |
|-------|-------------|--------|
| E8-S1 | Bouton "Resumer" sur une session terminee | 5 |
| E8-S2 | Lancement d'un modele Mistral local pour generer le resume | 8 |
| E8-S3 | Affichage et sauvegarde du resume avec la session | 3 |

### Epic 9 : Export (FR-009) — P2

| Story | Description | Points |
|-------|-------------|--------|
| E9-S1 | Export en Markdown | 2 |
| E9-S2 | Export en texte brut | 1 |
| E9-S3 | Copier dans le presse-papier | 1 |

### Epic 10 : Fenetre flottante overlay — P2

| Story | Description | Points |
|-------|-------------|--------|
| E10-S1 | Mode fenetre flottante toujours visible avec les sous-titres | 5 |
| E10-S2 | Basculer entre mode app complete et mode overlay | 3 |

---

## 6. UX Flow — MVP

### 6.1 Premier lancement (onboarding)

```
App demarre
  → Verification BlackHole
    ├── BlackHole installe → Ecran principal
    └── BlackHole absent → Guide d'installation
                              → Lien brew install blackhole-2ch
                              → Bouton "Verifier a nouveau"
                              → Si OK → Ecran principal
```

### 6.2 Session de transcription

```
Ecran principal (sidebar + zone principale)
  → Clic "Start" (ou raccourci clavier)
    → Indicateur : "Demarrage du serveur ML..."
    → Serveur pret : indicateur vert
    → Capture audio commence
    → Texte apparait en streaming
      ├── Ligne bleue = audio micro (moi)
      └── Ligne verte = audio systeme (interlocuteur)
    → Timer de session visible
  → Clic "Stop" (ou raccourci)
    → Session sauvegardee automatiquement
    → Apparait dans la sidebar
```

### 6.3 Consultation historique

```
Sidebar
  → Liste des sessions (date, duree, titre)
  → Clic sur une session
    → Zone principale affiche la transcription complete
    → Boutons : Renommer, Supprimer, Exporter (post-MVP), Resumer (post-MVP)
```

### 6.4 Layout principal

```
┌─────────────────────────────────────────────────────────────┐
│ [Menubar icon: IciTranscript]                               │
├──────────────┬──────────────────────────────────────────────┤
│              │                                              │
│  SIDEBAR     │  ZONE PRINCIPALE                             │
│              │                                              │
│  [Recherche] │  ┌─ Etat serveur: ● Pret ─────────────────┐ │
│              │  │                                         │ │
│  Sessions:   │  │  [Start] [Pause] [Stop]   00:12:34     │ │
│  ─────────── │  │                                         │ │
│  > Aujourd'  │  │  10:32:01 [MOI]                         │ │
│    Reunion   │  │  Bonjour, on peut commencer la reunion  │ │
│    14:30     │  │                                         │ │
│              │  │  10:32:05 [SYSTEME]                      │ │
│  > Hier      │  │  Oui, j'ai prepare les documents        │ │
│    Call RH   │  │                                         │ │
│    10:00     │  │  10:32:12 [MOI]                         │ │
│              │  │  Parfait, on commence par le budget...   │ │
│              │  │                                         │ │
│              │  │  █ (curseur en attente)                  │ │
│              │  └─────────────────────────────────────────┘ │
├──────────────┴──────────────────────────────────────────────┤
│  ⚙ Preferences                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Hors perimetre (Won't Have — v1)

| Element | Raison |
|---------|--------|
| Support Windows/Linux | macOS uniquement pour le MVP, MLX = Apple Silicon |
| Mode cloud/SaaS | Contradictoire avec la proposition de valeur |
| Diarization avancee | Complexe, pas supporte nativement par Voxtral |
| Traduction en temps reel | Feature separee, post-MVP lointain |
| Application mobile | Desktop-first, pas de besoin mobile identifie |
| Comptes utilisateur | App locale, pas d'authentification |
| Enregistrement audio | Seulement le texte + metadonnees, pas l'audio brut |

---

## 8. Risques identifies

| Risque | Probabilite | Impact | Mitigation | Owner |
|--------|-------------|--------|------------|-------|
| ScreenCaptureKit permission refusee par l'utilisateur | Faible | Moyen | Mode fallback micro-only, message explicatif | Clement |
| ScreenCaptureKit indisponible (macOS < 13) | Faible | Faible | macOS 13+ est notre cible minimum, machines anciennes non supportees | Clement |
| Voxtral qualite insuffisante | Moyen | Haut | Tester tot, avoir Whisper-MLX en fallback | Clement |
| voxmlx-serve API instable | Moyen | Haut | Abstraire l'interface, fork si necessaire | Clement |
| Flutter macOS limitations audio capture | Moyen | Haut | Platform channels Swift pour la capture audio native (CoreAudio) | Clement |
| Consommation ressources trop elevee | Moyen | Moyen | Parametres qualite ajustables, monitoring dans l'app | Clement |

---

## 9. Estimation et planning

### MVP — 2 sprints (1-2 semaines)

| Sprint | Epics | Points | Focus |
|--------|-------|--------|-------|
| Sprint 1 (semaine 1) | E1 (Serveur ML), E2 (Capture audio), E3 (Transcription), E4 (Controle) | ~38 | Fonctionnel : ca transcrit en temps reel |
| Sprint 2 (semaine 2) | E5 (Historique), E6 (Interface macOS) | ~26 | UI/UX : app complete avec historique |

### Post-MVP — sprints suivants

| Sprint | Epics | Focus |
|--------|-------|-------|
| Sprint 3 | E7 (Recherche), E9 (Export) | Exploitation des donnees |
| Sprint 4 | E8 (Resume auto), E10 (Overlay) | Intelligence et UX avancee |

---

## 10. Dependances techniques a investiguer

| Question | Importance | Quand |
|----------|-----------|-------|
| Comment voxmlx-serve expose son API ? (WebSocket, HTTP streaming, SSE ?) | Critique | Avant Sprint 1 |
| Comment capturer l'audio systeme + micro en parallele depuis Flutter/Dart ? (Platform channels CoreAudio) | Critique | Avant Sprint 1 |
| Comment configurer ScreenCaptureKit pour capturer uniquement l'audio systeme ? | Important | Sprint 1 |
| Quel modele Mistral utiliser pour le resume ? Quelle API MLX ? | Moyen | Avant Sprint 4 |
| Comment gerer la fenetre flottante overlay sur macOS depuis Flutter ? | Moyen | Avant Sprint 4 |

---

*Ce PRD est la reference pour toutes les decisions d'implementation. Tout changement de perimetre doit etre documente ici.*
