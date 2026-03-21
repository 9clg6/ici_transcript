import 'package:flutter/material.dart';

/// Widget de sidebar avec effet de fond translucide.
///
/// Conteneur utilise pour la barre laterale de l'application
/// avec un effet glass/translucent typique de macOS.
class AppSidebarWidget extends StatelessWidget {
  /// Cree une instance de [AppSidebarWidget].
  const AppSidebarWidget({required this.child, this.width = 240, super.key});

  /// Contenu de la sidebar.
  final Widget child;

  /// Largeur de la sidebar en pixels.
  final double width;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.7),
      ),
      child: child,
    );
  }
}
