import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ici_transcript/features/history/presentation/screens/list/session_list.state.dart';
import 'package:ici_transcript/features/history/presentation/screens/list/session_list.view_model.dart';
import 'package:ici_transcript/features/history/presentation/screens/list/widgets/session_card.widget.dart';
import 'package:ici_transcript/features/settings/presentation/screens/settings/settings.screen.dart';
import 'package:ici_transcript/generated/locale_keys.g.dart';

/// Ecran de la liste des sessions affiche dans la sidebar.
///
/// Inclut un champ de recherche, les sessions groupees par date
/// (Aujourd'hui/Hier/Plus ancien), et un bouton Reglages en bas.
/// Note: Pas de @RoutePage() car ce widget est embarque dans le shell.
class SessionListScreen extends ConsumerStatefulWidget {
  /// Cree une instance de [SessionListScreen].
  const SessionListScreen({super.key});

  @override
  ConsumerState<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends ConsumerState<SessionListScreen> {
  @override
  Widget build(BuildContext context) {
    final SessionListState state = ref.watch(sessionListViewModelProvider);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Filter sessions by search query.
    final List<SessionEntity> filteredSessions = state.searchQuery.isEmpty
        ? state.sessions
        : state.sessions
              .where(
                (SessionEntity s) => s.title.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                ),
              )
              .toList();

    // Group sessions by date.
    final DateTime now = DateTime.now();
    final DateTime todayStart = DateTime(now.year, now.month, now.day);
    final DateTime yesterdayStart = todayStart.subtract(
      const Duration(days: 1),
    );

    final List<SessionEntity> todaySessions = filteredSessions
        .where((SessionEntity s) => s.createdAt.isAfter(todayStart))
        .toList();
    final List<SessionEntity> yesterdaySessions = filteredSessions
        .where(
          (SessionEntity s) =>
              s.createdAt.isAfter(yesterdayStart) &&
              s.createdAt.isBefore(todayStart),
        )
        .toList();
    final List<SessionEntity> olderSessions = filteredSessions
        .where((SessionEntity s) => s.createdAt.isBefore(yesterdayStart))
        .toList();

    return Column(
      children: <Widget>[
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextField(
            onChanged: (String value) =>
                ref.read(sessionListViewModelProvider.notifier).search(value),
            decoration: InputDecoration(
              hintText: LocaleKeys.history_list_search_placeholder.tr(),
              hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
            style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
          ),
        ),
        // Session list
        Expanded(
          child: filteredSessions.isEmpty
              ? Center(
                  child: Text(
                    LocaleKeys.history_list_empty.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: <Widget>[
                    if (todaySessions.isNotEmpty) ...<Widget>[
                      _buildSectionHeader(
                        LocaleKeys.common_label_today.tr(),
                        colorScheme,
                      ),
                      ...todaySessions.map(
                        (SessionEntity s) => _buildSessionCard(s, state),
                      ),
                    ],
                    if (yesterdaySessions.isNotEmpty) ...<Widget>[
                      _buildSectionHeader(
                        LocaleKeys.common_label_yesterday.tr(),
                        colorScheme,
                      ),
                      ...yesterdaySessions.map(
                        (SessionEntity s) => _buildSessionCard(s, state),
                      ),
                    ],
                    if (olderSessions.isNotEmpty) ...<Widget>[
                      _buildSectionHeader(
                        LocaleKeys.common_label_older.tr(),
                        colorScheme,
                      ),
                      ...olderSessions.map(
                        (SessionEntity s) => _buildSessionCard(s, state),
                      ),
                    ],
                  ],
                ),
        ),
        // Bottom settings button
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return Dialog(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: 520,
                      height: 560,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: const SettingsScreen(),
                      ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.settings,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const Gap(12),
                  Text(
                    LocaleKeys.settings_title.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 16, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildSessionCard(SessionEntity session, SessionListState state) {
    final bool isSelected = state.selectedSessionId == session.id;

    return SessionCardWidget(
      session: session,
      isSelected: isSelected,
      onTap: () => ref
          .read(sessionListViewModelProvider.notifier)
          .selectSession(session.id),
    );
  }
}
