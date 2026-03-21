import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Widget affichant un badge de raccourci clavier.
///
/// Affiche une combinaison de touches dans des badges arrondis gris,
/// style macOS System Preferences.
class KeyboardShortcutBadgeWidget extends StatelessWidget {
  /// Cree une instance de [KeyboardShortcutBadgeWidget].
  const KeyboardShortcutBadgeWidget({required this.keys, super.key});

  /// Liste des touches a afficher (ex: ['⌘', '⇧', 'T']).
  final List<String> keys;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < keys.length; i++) ...<Widget>[
            if (i > 0) const Gap(4),
            Text(
              keys[i],
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
