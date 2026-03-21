# Prompts Stitch — IciTranscript

Ouvrir https://stitch.withgoogle.com/, selectionner **Web**, coller chaque prompt.

---

## Ecran 1 — Main App (Live Transcription Active)

```
macOS native desktop application "IciTranscript" for real-time voice transcription. Apple-native aesthetic with SF Pro typography, indigo accent color (#4F46E5), supports both dark and light mode. Clean, professional, minimal. Think Apple Notes meets Otter.ai.

Layout: Two-column layout with macOS window chrome (traffic light close/minimize/maximize buttons top-left).

Left sidebar (240px, translucent vibrancy material background):
- Search bar at top with magnifying glass icon, rounded pill shape
- "Aujourd'hui" section label, then session card: green dot, title "Reunion produit", subtitle "14:32", duration badge "00:45:12"
- Another session card below: green dot, "Call technique", "11:15", "00:22:08"
- "Hier" section label, then 2 past session cards with gray dots: "Entretien RH" and "Point hebdo"
- Small gear icon button at very bottom for settings

Main content area (right, fills remaining space):
- Top toolbar bar (48px, flat, no border): Left side shows small green circle dot + "Voxtral Ready" in muted gray text. Center shows session timer "00:12:34" in medium weight. Right side has three buttons in a pill-shaped segmented control: a grayed-out Play triangle, an active indigo Pause icon, and a subtle red Stop square.
- Large scrollable transcript area filling the remaining space. Each line has: a muted timestamp on the far left, then a small colored badge/tag, then the text. Lines alternate between two speakers:
  - "10:32:01  [MOI]  Bonjour, on peut commencer la reunion" — [MOI] badge is indigo
  - "10:32:05  [SYSTEME]  Oui, j'ai prepare les documents pour le budget" — [SYSTEME] badge is teal
  - "10:32:12  [MOI]  Parfait, on commence par le point sur les ventes"
  - "10:32:18  [SYSTEME]  Les ventes du mois dernier ont augmente de quinze pourcent par rapport au trimestre precedent"
  - "10:32:25  [MOI]  Tres bien, et pour les projections du trimestre prochain ?"
  - "10:32:31  [SYSTEME]  On prevoit une croissance similaire si on maintient le rythme actuel"
  - At the bottom: a blinking cursor line indicating live transcription in progress
- Very bottom status bar (24px height, very subtle): small horizontal audio level bar on the left, then "Micro: MacBook Pro" and "Systeme: ScreenCaptureKit" in tiny muted text

Overall mood: Professional, clean, focused on readability. The transcript text is the hero. Generous line spacing for easy reading.
```

---

## Ecran 2 — Session Detail (Past Session View)

```
macOS native desktop application "IciTranscript". Same design system as the main screen: SF Pro, indigo accent (#4F46E5), translucent sidebar, Apple-native aesthetic.

This screen shows a PAST session (not live). The session is completed and being reviewed.

Layout: Same two-column layout with macOS window chrome.

Left sidebar (same as main screen):
- Search bar at top
- Session list. The session "Entretien RH" from yesterday is selected/highlighted with indigo background
- Other sessions visible but not selected

Main content area — Session Detail view:
- Top area: Large title "Entretien RH" (editable, with a subtle pencil icon on hover). Below it: "Hier, 10:00 — Duree: 00:34:12" in muted gray text.
- Row of action buttons below the title: "Copier" button with clipboard icon, "Exporter" dropdown button with download icon, "Resumer" button with sparkle/AI icon (indigo accent), "Supprimer" button in subtle red text with trash icon. All buttons are small, pill-shaped, outlined style.
- Transcript area: Same format as live view but static (no blinking cursor). Timestamped lines with [MOI] indigo and [SYSTEME] teal tags. Show 8-10 lines of French conversation about an HR interview topic.
- No bottom status bar (session is not active)

Mood: Same clean, professional look. The action buttons should be subtle and not dominate the transcript content.
```

---

## Ecran 3 — Settings / Preferences

```
macOS native settings/preferences window for "IciTranscript". Floating panel style (smaller window, ~500x400px), Apple-native look like System Settings. SF Pro, indigo accent (#4F46E5).

This is a separate preferences window (not inside the main app window). macOS window chrome with traffic lights.

Layout: Single column with sections separated by subtle dividers.

Section 1 — "Audio":
- Row: "Microphone" label on left, dropdown selector on right showing "MacBook Pro Microphone" with a chevron
- Row: "Audio systeme" label on left, toggle switch on right (active/indigo), with small text below "Capture via ScreenCaptureKit"
- Row: "Indicateur de niveau" label on left, toggle switch on right (active)

Section 2 — "Serveur ML":
- Row: "Modele" label on left, dropdown showing "Voxtral-Mini-4B-Realtime" on right
- Row: "Port" label on left, text field showing "8765" on right
- Row: "Lancement automatique" label on left, toggle switch (active/indigo) on right

Section 3 — "Raccourcis":
- Row: "Demarrer/Arreter" label on left, keyboard shortcut badge "Cmd+Shift+T" on right in a rounded gray badge
- Row: "Pause" label on left, keyboard shortcut badge "Cmd+Shift+P" on right

Section 4 — "Stockage":
- Row: "Emplacement" label on left, path text "/Users/clement/Library/Application Support/IciTranscript" with a "Modifier..." button on right
- Row: "Taille base de donnees" label on left, "124 Mo" text on right

Bottom: Small "A propos" link and version number "v0.1.0" in muted text, centered.

Mood: Native macOS Settings feel. Clean rows, no clutter. Toggle switches in indigo when active.
```

---

## Ecran 4 — Menubar Dropdown

```
macOS menubar dropdown/popover for "IciTranscript". Small floating panel (280px wide, ~200px tall) that appears when clicking the app's menubar icon. Apple-native popover style with subtle shadow and rounded corners.

Dark semi-transparent background (like macOS menubar popovers). Light text.

Content from top to bottom:
- Status row: Green dot + "Voxtral Ready" text, or if recording: pulsing red dot + "En cours — 00:12:34"
- Thin separator line
- Button row: Large "Demarrer" button (indigo, pill-shaped, full width). When recording, this changes to "Arreter" (red subtle)
- Thin separator line  
- "Session en cours:" label in tiny muted text, then "Reunion produit" title below it
- Last 2 lines of live transcript in small text, fading at the bottom
- Thin separator line
- Bottom row: "Ouvrir IciTranscript" link text on left, gear icon on right

Mood: Compact, informative at a glance. Like the macOS battery or wifi popover but for transcription status.
```

---

## Notes pour Stitch

- Selectionner **Web** pour tous les ecrans (c'est du desktop macOS, pas mobile)
- Utiliser **Gemini 3.0 Flash** pour la vitesse ou **3.0 Pro** pour plus de detail
- Apres generation, les ecrans seront visibles dans le projet "IciTranscript" sur stitch.withgoogle.com
