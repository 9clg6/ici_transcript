import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ici_transcript/features/shared/presentation/widgets/status_dot.widget.dart';

/// Widget representant une carte de session dans la sidebar.
///
/// Affiche le titre, l'heure, un badge de duree et un indicateur
/// de statut colore (vert = active, gris = terminee).
/// Au survol, un bouton de suppression apparait.
class SessionCardWidget extends StatefulWidget {
  /// Cree une instance de [SessionCardWidget].
  const SessionCardWidget({
    required this.session,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// La session a afficher.
  final SessionEntity session;

  /// Indique si cette session est selectionnee.
  final bool isSelected;

  /// Callback lorsque l'utilisateur tape sur la carte.
  final VoidCallback onTap;

  /// Callback lorsque l'utilisateur supprime la session.
  final VoidCallback onDelete;

  @override
  State<SessionCardWidget> createState() => _SessionCardWidgetState();
}

class _SessionCardWidgetState extends State<SessionCardWidget> {
  bool _isHovered = false;

  String _formatDuration(int? durationSeconds) {
    if (durationSeconds == null) return '';
    final int minutes = durationSeconds ~/ 60;
    final int seconds = durationSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color statusColor = widget.session.status == SessionStatus.active
        ? Colors.green
        : Colors.grey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: widget.isSelected
              ? colorScheme.surface.withValues(alpha: 0.8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: <Widget>[
                  StatusDotWidget(color: statusColor),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.session.title,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: widget.isSelected
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: widget.isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.session.durationSeconds != null) ...<Widget>[
                          const Gap(2),
                          Text(
                            _formatDuration(widget.session.durationSeconds),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_isHovered)
                    GestureDetector(
                      onTap: widget.onDelete,
                      child: Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: colorScheme.error.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
