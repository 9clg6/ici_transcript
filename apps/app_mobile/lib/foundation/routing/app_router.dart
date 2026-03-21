import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:ici_transcript/features/history/presentation/screens/detail/session_detail.screen.dart';
import 'package:ici_transcript/features/settings/presentation/screens/settings/settings.screen.dart';
import 'package:ici_transcript/features/shared/presentation/screens/shell/main_shell.screen.dart';
import 'package:ici_transcript/features/transcription/presentation/screens/live/live_transcription.screen.dart';

part 'app_router.gr.dart';

/// Configuration du routeur de l'application IciTranscript.
///
/// Definit l'arbre de navigation avec :
/// - [MainShellRoute] : shell principal avec sidebar + contenu
///   - [LiveTranscriptionRoute] : ecran de transcription en direct (initial)
///   - [SessionDetailRoute] : detail d'une session (param: sessionId)
///   - [SettingsRoute] : ecran des reglages
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  /// Cree une instance de [AppRouter].
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(
      page: MainShellRoute.page,
      initial: true,
      children: <AutoRoute>[
        AutoRoute(page: LiveTranscriptionRoute.page, initial: true),
        AutoRoute(page: SessionDetailRoute.page, path: 'session/:sessionId'),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),
  ];
}
