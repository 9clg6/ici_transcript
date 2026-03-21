import 'package:flutter/material.dart';

/// Widget affichant un indicateur de niveau audio sous forme de barres.
///
/// Affiche une serie de petites barres verticales dont la hauteur
/// varie pour representer le niveau audio actuel.
class AudioLevelIndicatorWidget extends StatelessWidget {
  /// Cree une instance de [AudioLevelIndicatorWidget].
  const AudioLevelIndicatorWidget({
    required this.level,
    this.barCount = 7,
    super.key,
  });

  /// Niveau audio normalise entre 0.0 et 1.0.
  final double level;

  /// Nombre de barres a afficher.
  final int barCount;

  @override
  Widget build(BuildContext context) {
    // Predefined bar heights pattern for visual appeal.
    final List<double> barHeights = <double>[
      0.2,
      0.5,
      0.8,
      0.6,
      0.3,
      0.45,
      0.1,
    ];

    return SizedBox(
      height: 12,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List<Widget>.generate(barCount, (int index) {
          final double barLevel = index < barHeights.length
              ? barHeights[index] * level
              : 0.1;
          final bool isActive = barLevel > 0.5 * level;

          return Container(
            width: 3,
            height: 12 * barLevel.clamp(0.1, 1.0),
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.green.shade400
                  : Colors.green.shade200.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
