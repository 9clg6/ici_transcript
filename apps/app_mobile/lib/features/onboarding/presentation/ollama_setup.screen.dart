import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ici_transcript/application/services/ollama.service.dart';
import 'package:ici_transcript/features/onboarding/presentation/ollama_setup.state.dart';
import 'package:ici_transcript/features/onboarding/presentation/ollama_setup.view_model.dart';

/// Ecran de configuration initiale d'Ollama.
///
/// Affiché au premier lancement pour télécharger le moteur IA et le modèle
/// Mistral. Disparaît automatiquement une fois la configuration terminée.
class OllamaSetupScreen extends ConsumerWidget {
  const OllamaSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OllamaSetupState setupState = ref.watch(
      ollamaSetupViewModelProvider,
    );
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: SizedBox(
          width: 480,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Icon + title
              Row(
                children: <Widget>[
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 28,
                      color: colorScheme.primary,
                    ),
                  ),
                  const Gap(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Configuration du moteur IA',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        'Ce processus n\'a lieu qu\'une seule fois',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Gap(40),

              // Steps list
              _SetupStep(
                index: 0,
                label: 'Moteur Ollama',
                sublabel: '~106 Mo',
                stage: OllamaSetupStage.downloadingBinary,
                currentStage: setupState.stage,
                progress: setupState.progress,
                isReady: setupState.isReady,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const Gap(12),
              _SetupStep(
                index: 1,
                label: 'Démarrage du serveur',
                sublabel: '',
                stage: OllamaSetupStage.startingServer,
                currentStage: setupState.stage,
                progress: setupState.progress,
                isReady: setupState.isReady,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const Gap(12),
              _SetupStep(
                index: 2,
                label: 'Modèle Mistral',
                sublabel: '~4 Go',
                stage: OllamaSetupStage.downloadingModel,
                currentStage: setupState.stage,
                progress: setupState.progress,
                isReady: setupState.isReady,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),

              const Gap(32),

              // Error state
              if (setupState.stage == OllamaSetupStage.error) ...<Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.error_outline,
                            size: 16,
                            color: colorScheme.error,
                          ),
                          const Gap(8),
                          Text(
                            'Erreur de configuration',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (setupState.error != null) ...<Widget>[
                        const Gap(6),
                        Text(
                          setupState.error!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onErrorContainer,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap(16),
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(ollamaSetupViewModelProvider.notifier).retry(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
              ],

              // Status text (non-error)
              if (setupState.stage != OllamaSetupStage.error &&
                  setupState.stage != OllamaSetupStage.idle) ...<Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      _stageLabel(setupState.stage, setupState.progress),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _stageLabel(OllamaSetupStage stage, double progress) {
    final String pct = '${(progress * 100).toStringAsFixed(0)} %';
    return switch (stage) {
      OllamaSetupStage.downloadingBinary =>
        'Téléchargement du moteur Ollama... $pct',
      OllamaSetupStage.startingServer => 'Démarrage du serveur...',
      OllamaSetupStage.downloadingModel =>
        'Téléchargement du modèle Mistral... $pct',
      OllamaSetupStage.ready => 'Prêt',
      _ => 'Initialisation...',
    };
  }
}

/// Un élément de la liste des étapes de configuration.
class _SetupStep extends StatelessWidget {
  const _SetupStep({
    required this.index,
    required this.label,
    required this.sublabel,
    required this.stage,
    required this.currentStage,
    required this.progress,
    required this.isReady,
    required this.colorScheme,
    required this.textTheme,
  });

  final int index;
  final String label;
  final String sublabel;
  final OllamaSetupStage stage;
  final OllamaSetupStage currentStage;
  final double progress;
  final bool isReady;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  bool get _isDone {
    if (isReady) return true;
    const List<OllamaSetupStage> order = <OllamaSetupStage>[
      OllamaSetupStage.downloadingBinary,
      OllamaSetupStage.startingServer,
      OllamaSetupStage.downloadingModel,
      OllamaSetupStage.ready,
    ];
    final int currentIdx = order.indexOf(currentStage);
    final int myIdx = order.indexOf(stage);
    return currentIdx > myIdx;
  }

  bool get _isActive => currentStage == stage;

  @override
  Widget build(BuildContext context) {
    final Color containerColor = _isDone
        ? colorScheme.primaryContainer
        : _isActive
        ? colorScheme.surfaceContainerHighest
        : colorScheme.surfaceContainerLow;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isActive
              ? colorScheme.primary.withValues(alpha: 0.4)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Status icon
              SizedBox(
                width: 24,
                height: 24,
                child: _isActive
                    ? CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.primary,
                      )
                    : _isDone
                    ? Icon(
                        Icons.check_circle,
                        size: 22,
                        color: colorScheme.primary,
                      )
                    : Icon(
                        Icons.circle_outlined,
                        size: 22,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        ),
                      ),
              ),
              const Gap(12),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: _isActive || _isDone
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.6,
                              ),
                        fontWeight: _isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    if (sublabel.isNotEmpty) ...<Widget>[
                      const Gap(6),
                      Text(
                        sublabel,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_isDone)
                Text(
                  'Terminé',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          // Progress bar (only for download steps when active)
          if (_isActive &&
              (stage == OllamaSetupStage.downloadingBinary ||
                  stage == OllamaSetupStage.downloadingModel)) ...<Widget>[
            const Gap(12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress > 0 ? progress : null,
                backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                color: colorScheme.primary,
                minHeight: 6,
              ),
            ),
            if (progress > 0) ...<Widget>[
              const Gap(6),
              Text(
                '${(progress * 100).toStringAsFixed(1)} %',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
