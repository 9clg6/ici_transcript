
![Generated Image March 21, 2026 - 2_07PM](https://github.com/user-attachments/assets/0bf3385c-9a50-47c3-9bdb-bf5ae8d7bda6)

# IciTranscript

Application macOS de transcription vocale temps réel, propulsée par [voxmlx](https://github.com/voxmlx/voxmlx) (MLX / Apple Silicon).

## Installation

1. **Télécharger** le DMG depuis [GitHub Releases](../../releases)
2. **Glisser** IciTranscript dans le dossier Applications
3. **Clic droit > Ouvrir** (première fois — Gatekeeper avertit car signature ad-hoc)
4. Au premier lancement, l'app guide pour installer `uv` si nécessaire

### Prérequis

- macOS 13+ (Apple Silicon recommandé pour MLX)
- `uv` — installé automatiquement au premier lancement via le script officiel [Astral](https://astral.sh/uv)

## Développement

```bash
# Dépendances
cd apps/app_mobile && flutter pub get

# Lancer en debug
flutter run -d macos

# Build release
make build

# Créer le DMG
make dmg
```

### Structure

```
apps/app_mobile/     — App Flutter macOS
packages/
  core_domain/       — Entités, use cases, interfaces
  core_data/         — Implémentations repository, base de données
  core_foundation/   — Logger, config, utilitaires
  core_presentation/ — Widgets partagés
```

## Fonctionnement

IciTranscript lance `voxmlx-serve` en processus enfant via `uvx` au démarrage d'une session. Le serveur écoute sur `ws://localhost:8000` et retourne les segments transcrits en temps réel.

## Licence

MIT
