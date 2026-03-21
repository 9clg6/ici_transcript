import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ici_transcript/application/services/ollama.service.dart';
import 'package:ici_transcript/features/live_transcription/presentation/screens/live/live_transcription.state.dart';
import 'package:ici_transcript/features/live_transcription/presentation/screens/live/live_transcription.view_model.dart';
import 'package:ici_transcript/features/live_transcription/presentation/screens/live/widgets/audio_level_indicator.widget.dart';
import 'package:ici_transcript/features/live_transcription/presentation/screens/live/widgets/server_status.widget.dart';
import 'package:ici_transcript/features/live_transcription/presentation/screens/live/widgets/session_controls.widget.dart';
import 'package:ici_transcript/features/live_transcription/presentation/screens/live/widgets/transcript_line.widget.dart';
import 'package:ici_transcript/generated/translations/locale_keys.g.dart';

/// Ecran de transcription en direct.
///
/// Affiche la barre d'outils avec statut serveur, minuteur et controles,
/// la zone de transcription en temps reel avec auto-scroll,
/// et la barre de statut avec niveau audio et peripheriques.
@RoutePage()
class LiveTranscriptionScreen extends ConsumerStatefulWidget {
  /// Cree une instance de [LiveTranscriptionScreen].
  const LiveTranscriptionScreen({super.key});

  @override
  ConsumerState<LiveTranscriptionScreen> createState() =>
      _LiveTranscriptionScreenState();
}

class _LiveTranscriptionScreenState
    extends ConsumerState<LiveTranscriptionScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatDuration(Duration duration) {
    final String hours = duration.inHours.toString().padLeft(2, '0');
    final String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final LiveTranscriptionState state = ref.watch(
      liveTranscriptionViewModelProvider,
    );
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Auto-scroll when segments change.
    ref.listen(
      liveTranscriptionViewModelProvider.select(
        (LiveTranscriptionState s) => s.segments.length,
      ),
      (int? previous, int next) {
        _scrollToBottom();
      },
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: <Widget>[
          // Top toolbar
          _buildToolbar(state, colorScheme, textTheme),
          // Option Résumé IA (visible seulement quand idle)
          if (!state.isRecording && !state.isPaused)
            _buildSummaryOption(state, colorScheme, textTheme),
          // Bannières de permissions
          if (state.micPermission == 'denied')
            _buildPermissionBanner(
              context: context,
              colorScheme: colorScheme,
              icon: Icons.mic_off,
              message: 'Accès au microphone refusé.',
              isWarning: false,
              onOpenSettings: () => ref
                  .read(liveTranscriptionViewModelProvider.notifier)
                  .openMicSettings(),
              onRecheck: () => ref
                  .read(liveTranscriptionViewModelProvider.notifier)
                  .recheckPermissions(),
            ),
          if (state.screenRecordingPermission == 'denied')
            _buildPermissionBanner(
              context: context,
              colorScheme: colorScheme,
              icon: Icons.screenshot_monitor,
              message: 'Permission Screen Recording refusée — son système non capturé.',
              isWarning: true,
              onOpenSettings: () => ref
                  .read(liveTranscriptionViewModelProvider.notifier)
                  .openScreenRecordingSettings(),
              onRecheck: () => ref
                  .read(liveTranscriptionViewModelProvider.notifier)
                  .recheckPermissions(),
            ),
          // Ollama setup progress (téléchargement binaire / modèle)
          if (state.ollamaSetupStage != OllamaSetupStage.idle &&
              state.ollamaSetupStage != OllamaSetupStage.ready &&
              state.ollamaSetupStage != OllamaSetupStage.error)
            _buildOllamaSetupBanner(state, colorScheme, textTheme),
          // Transcript area
          Expanded(child: _buildTranscriptArea(state, colorScheme)),
          // Summary panel (visible après arrêt si résumé activé)
          if (state.summary != null || state.isSummaryLoading)
            _buildSummaryPanel(state, colorScheme, textTheme),
          // Bottom status bar
          _buildStatusBar(state, colorScheme),
        ],
      ),
    );
  }

  Widget _buildPermissionBanner({
    required BuildContext context,
    required ColorScheme colorScheme,
    required IconData icon,
    required String message,
    required VoidCallback onOpenSettings,
    required VoidCallback onRecheck,
    bool isWarning = false,
  }) {
    final Color bgColor = isWarning
        ? colorScheme.tertiaryContainer
        : colorScheme.errorContainer;
    final Color fgColor = isWarning
        ? colorScheme.onTertiaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: bgColor,
      child: Row(
        children: <Widget>[
          Icon(icon, size: 16, color: fgColor),
          const Gap(8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: fgColor,
              ),
            ),
          ),
          const Gap(8),
          TextButton(
            onPressed: onOpenSettings,
            style: TextButton.styleFrom(
              foregroundColor: fgColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: const Text('Ouvrir les Réglages'),
          ),
          TextButton(
            onPressed: onRecheck,
            style: TextButton.styleFrom(
              foregroundColor: fgColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: const Text('Re-vérifier'),
          ),
        ],
      ),
    );
  }

  Widget _buildOllamaSetupBanner(
    LiveTranscriptionState state,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final String label = switch (state.ollamaSetupStage) {
      OllamaSetupStage.downloadingBinary =>
        'Téléchargement du moteur IA (${(state.ollamaSetupProgress * 100).toStringAsFixed(0)} %)...',
      OllamaSetupStage.startingServer => 'Démarrage du moteur IA...',
      OllamaSetupStage.downloadingModel =>
        'Téléchargement du modèle Mistral (${(state.ollamaSetupProgress * 100).toStringAsFixed(0)} %, ~4 Go — une seule fois)...',
      _ => '',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      color: colorScheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.secondary,
                ),
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          if (state.ollamaSetupProgress > 0 &&
              state.ollamaSetupProgress < 1) ...<Widget>[
            const Gap(6),
            LinearProgressIndicator(
              value: state.ollamaSetupProgress,
              backgroundColor:
                  colorScheme.secondaryContainer.withValues(alpha: 0.5),
              color: colorScheme.secondary,
              minHeight: 3,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryOption(
    LiveTranscriptionState state,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(Icons.auto_awesome, size: 13, color: colorScheme.secondary),
          const Gap(6),
          Text(
            LocaleKeys.transcription_live_summary_option.tr(),
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
          const Gap(6),
          Switch.adaptive(
            value: state.isSummaryEnabled,
            onChanged: (_) => ref
                .read(liveTranscriptionViewModelProvider.notifier)
                .toggleSummary(),
            activeTrackColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(
    LiveTranscriptionState state,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Server status indicator
          ServerStatusWidget(serverState: state.serverState),
          // Timer (centered in remaining space)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    _formatDuration(state.duration),
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    LocaleKeys.transcription_live_recording_time.tr(),
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1.5,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Transport controls
          SessionControlsWidget(
            isRecording: state.isRecording,
            isPaused: state.isPaused,
            onStart: () => ref
                .read(liveTranscriptionViewModelProvider.notifier)
                .startSession(),
            onPause: () => ref
                .read(liveTranscriptionViewModelProvider.notifier)
                .pauseSession(),
            onResume: () => ref
                .read(liveTranscriptionViewModelProvider.notifier)
                .resumeSession(),
            onStop: () => ref
                .read(liveTranscriptionViewModelProvider.notifier)
                .stopSession(),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptArea(
    LiveTranscriptionState state,
    ColorScheme colorScheme,
  ) {
    if (state.segments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (state.isRecording) ...<Widget>[
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
              const Gap(16),
              Text(
                'En attente de transcription...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ] else
              Text(
                LocaleKeys.transcription_live_no_session.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      itemCount: state.segments.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: TranscriptLineWidget(segment: state.segments[index]),
        );
      },
    );
  }

  Widget _buildSummaryPanel(
    LiveTranscriptionState state,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 180),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: colorScheme.secondary,
                ),
                const Gap(6),
                Text(
                  LocaleKeys.transcription_live_summary_title.tr(),
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const Gap(8),
            if (state.isSummaryLoading)
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    LocaleKeys.transcription_live_summary_loading.tr(),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              )
            else
              Text(
                state.summary ?? '',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(
    LiveTranscriptionState state,
    ColorScheme colorScheme,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Audio level
          Text(
            LocaleKeys.transcription_status_bar_level.tr(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 10,
            ),
          ),
          const Gap(8),
          const AudioLevelIndicatorWidget(level: 0.6),
          const Gap(16),
          // Mic device
          Icon(
            state.micPermission == 'denied' ? Icons.mic_off : Icons.mic,
            size: 14,
            color: state.micPermission == 'denied'
                ? colorScheme.error
                : colorScheme.onSurfaceVariant,
          ),
          const Gap(4),
          Flexible(
            child: Text(
              '${LocaleKeys.transcription_status_bar_mic.tr()}: ${state.micPermission == 'denied' ? 'Refusé' : 'Actif'}',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: state.micPermission == 'denied'
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ),
          const Spacer(),
          // System audio device
          Icon(
            Icons.screenshot_monitor,
            size: 14,
            color: state.screenRecordingPermission == 'denied'
                ? colorScheme.error
                : colorScheme.onSurfaceVariant,
          ),
          const Gap(4),
          Flexible(
            child: Text(
              '${LocaleKeys.transcription_status_bar_system.tr()}: ${state.screenRecordingPermission == 'denied' ? 'Refusé' : 'ScreenCaptureKit'}',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: state.screenRecordingPermission == 'denied'
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
