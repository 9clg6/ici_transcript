import 'package:core_domain/domain/enum/server_state.enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ici_transcript/generated/locale_keys.g.dart';

/// Widget affichant le statut du serveur de transcription.
///
/// Affiche un point colore (vert/rouge/orange/gris) avec un texte
/// descriptif de l'etat actuel du serveur.
class ServerStatusWidget extends StatelessWidget {
  /// Cree une instance de [ServerStatusWidget].
  const ServerStatusWidget({required this.serverState, super.key});

  /// Etat courant du serveur.
  final ServerState serverState;

  Color _dotColor(ColorScheme colorScheme) {
    switch (serverState) {
      case ServerState.ready:
        return Colors.green;
      case ServerState.starting:
        return Colors.orange;
      case ServerState.error:
        return colorScheme.error;
      case ServerState.stopped:
        return Colors.grey;
    }
  }

  String _statusLabel() {
    switch (serverState) {
      case ServerState.ready:
        return LocaleKeys.server_state_ready.tr();
      case ServerState.starting:
        return LocaleKeys.server_state_starting.tr();
      case ServerState.error:
        return LocaleKeys.server_state_error.tr();
      case ServerState.stopped:
        return LocaleKeys.server_state_stopped.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color dotColor = _dotColor(colorScheme);
    final bool isReady = serverState == ServerState.ready;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isReady
            ? Colors.green.withValues(alpha: 0.08)
            : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isReady
              ? Colors.green.withValues(alpha: 0.2)
              : colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const Gap(8),
          Text(
            _statusLabel(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isReady
                  ? Colors.green.shade700
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
