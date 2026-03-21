import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ici_transcript/features/history/presentation/screens/detail/session_detail.screen.dart';
import 'package:ici_transcript/features/history/presentation/screens/list/session_list.screen.dart';
import 'package:ici_transcript/features/history/presentation/screens/list/session_list.view_model.dart';
import 'package:ici_transcript/features/shared/presentation/widgets/app_sidebar.widget.dart';
import 'package:ici_transcript/features/live_transcription/presentation/screens/live/live_transcription.screen.dart';
import 'package:ici_transcript/generated/translations/locale_keys.g.dart';

/// Ecran shell principal de l'application.
///
/// Layout : sidebar (240px) + contenu principal.
/// Le contenu principal est un Stack : LiveTranscriptionScreen toujours en
/// dessous, SessionDetailScreen en overlay animé par-dessus quand une session
/// est sélectionnée.
@RoutePage()
class MainShellScreen extends ConsumerWidget {
  /// Cree une instance de [MainShellScreen].
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String? selectedId = ref
        .watch(sessionListViewModelProvider)
        .selectedSessionId;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: <Widget>[
          // Sidebar
          AppSidebarWidget(
            width: 240,
            child: Column(
              children: <Widget>[
                // App header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        LocaleKeys.app_name.tr(),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        LocaleKeys.app_subtitle.tr(),
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                          letterSpacing: 1.5,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SessionListScreen()),
              ],
            ),
          ),
          // Vertical divider
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
          // Main content : live screen + session detail overlay
          Expanded(
            child: Stack(
              children: <Widget>[
                // Live transcription screen — always rendered underneath
                const LiveTranscriptionScreen(),

                // Session detail overlay — slides in from the right
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: selectedId != null
                      ? _SessionDetailOverlay(
                          key: ValueKey<String>(selectedId),
                          sessionId: selectedId,
                          onClose: () => ref
                              .read(sessionListViewModelProvider.notifier)
                              .clearSelection(),
                          colorScheme: colorScheme,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Overlay affichant le détail d'une session par-dessus le contenu principal.
class _SessionDetailOverlay extends StatelessWidget {
  const _SessionDetailOverlay({
    required this.sessionId,
    required this.onClose,
    required this.colorScheme,
    super.key,
  });

  final String sessionId;
  final VoidCallback onClose;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.surface,
      elevation: 0,
      child: Column(
        children: <Widget>[
          // Close bar
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Fermer',
                  onPressed: onClose,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                Text(
                  'Retour',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SessionDetailScreen(
              sessionId: sessionId,
              onClose: onClose,
            ),
          ),
        ],
      ),
    );
  }
}
