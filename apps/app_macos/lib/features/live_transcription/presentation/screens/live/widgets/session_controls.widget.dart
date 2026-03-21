import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ici_transcript/generated/translations/locale_keys.g.dart';

/// Widget de controle de session : boutons Démarrer / Arrêter / Pause.
///
/// Affiche :
/// - Quand idle : bouton "Démarrer" prominent
/// - Quand en cours : boutons "Pause" et "Arrêter"
/// - Quand en pause : boutons "Reprendre" et "Arrêter"
class SessionControlsWidget extends StatelessWidget {
  /// Cree une instance de [SessionControlsWidget].
  const SessionControlsWidget({
    required this.isRecording,
    required this.isPaused,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStop,
    super.key,
  });

  /// Indique si un enregistrement est en cours.
  final bool isRecording;

  /// Indique si l'enregistrement est en pause.
  final bool isPaused;

  /// Callback pour demarrer l'enregistrement.
  final VoidCallback onStart;

  /// Callback pour mettre en pause l'enregistrement.
  final VoidCallback onPause;

  /// Callback pour reprendre l'enregistrement.
  final VoidCallback onResume;

  /// Callback pour arreter l'enregistrement.
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (!isRecording && !isPaused) {
      // Idle — bouton Démarrer
      return FilledButton.icon(
        onPressed: onStart,
        icon: const Icon(Icons.fiber_manual_record, size: 16),
        label: Text(LocaleKeys.transcription_live_start.tr()),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    // En cours ou en pause — Pause/Reprendre + Arrêter
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Pause / Reprendre
        OutlinedButton.icon(
          onPressed: isPaused ? onResume : onPause,
          icon: Icon(
            isPaused ? Icons.play_arrow : Icons.pause,
            size: 16,
          ),
          label: Text(
            isPaused
                ? LocaleKeys.transcription_live_resume.tr()
                : LocaleKeys.transcription_live_pause.tr(),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const Gap(8),
        // Arrêter
        FilledButton.icon(
          onPressed: onStop,
          icon: const Icon(Icons.stop, size: 16),
          label: Text(LocaleKeys.transcription_live_stop.tr()),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
