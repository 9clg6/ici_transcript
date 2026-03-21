import 'package:flutter/material.dart';

/// Widget affichant un petit cercle colore indicateur de statut.
///
/// Utilise pour representer l'etat d'une session (vert = active,
/// gris = terminee) ou du serveur (vert/rouge/orange/gris).
class StatusDotWidget extends StatelessWidget {
  /// Cree une instance de [StatusDotWidget].
  const StatusDotWidget({
    required this.color,
    this.size = 8,
    this.animate = false,
    super.key,
  });

  /// Couleur du point.
  final Color color;

  /// Taille du point en pixels.
  final double size;

  /// Indique si le point doit pulser (animation).
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
