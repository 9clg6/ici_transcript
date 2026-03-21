import 'package:flutter/material.dart';

/// Widget de controle de session : boutons Play/Pause/Resume/Stop.
///
/// Affiche un groupe de boutons segmentes (pill style) pour controler
/// le demarrage, la pause, la reprise et l'arret de l'enregistrement.
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

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Play button
          _ControlButton(
            icon: Icons.play_circle_outline,
            isActive: !isRecording && !isPaused,
            onPressed: isRecording || isPaused ? onResume : onStart,
            activeColor: colorScheme.onSurfaceVariant,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
          // Pause button
          _ControlButton(
            icon: Icons.pause_circle_filled,
            isActive: isRecording && !isPaused,
            onPressed: onPause,
            activeColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.primary,
          ),
          // Stop button
          _ControlButton(
            icon: Icons.stop_circle_outlined,
            isActive: false,
            onPressed: onStop,
            activeColor: colorScheme.error,
            backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.isActive,
    required this.onPressed,
    required this.activeColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;
  final Color activeColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? backgroundColor : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: isActive
                ? activeColor
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
