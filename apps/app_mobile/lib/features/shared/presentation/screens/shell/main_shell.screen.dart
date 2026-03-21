import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ici_transcript/features/history/presentation/screens/list/session_list.screen.dart';
import 'package:ici_transcript/features/shared/presentation/widgets/app_sidebar.widget.dart';
import 'package:ici_transcript/generated/locale_keys.g.dart';

/// Ecran shell principal de l'application.
///
/// Layout en Row : sidebar (SessionListScreen, 240px)
/// + VerticalDivider + Expanded(AutoRouter pour le contenu nested).
@RoutePage()
class MainShellScreen extends ConsumerStatefulWidget {
  /// Cree une instance de [MainShellScreen].
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

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
                // Session list (embedded, not a route page)
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
          // Main content area via AutoRouter
          const Expanded(child: AutoRouter()),
        ],
      ),
    );
  }
}
