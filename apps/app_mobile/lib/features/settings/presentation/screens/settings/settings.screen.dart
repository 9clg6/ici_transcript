import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ici_transcript/features/settings/presentation/screens/settings/settings.state.dart';
import 'package:ici_transcript/features/settings/presentation/screens/settings/settings.view_model.dart';
import 'package:ici_transcript/features/shared/presentation/widgets/keyboard_shortcut_badge.widget.dart';
import 'package:ici_transcript/generated/locale_keys.g.dart';

/// Ecran des reglages de l'application.
///
/// Style macOS System Preferences avec sections :
/// Audio, Serveur ML, Raccourcis, Stockage.
@RoutePage()
class SettingsScreen extends ConsumerStatefulWidget {
  /// Cree une instance de [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final SettingsState state = ref.watch(settingsViewModelProvider);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          LocaleKeys.settings_title.tr(),
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: LocaleKeys.common_action_close.tr(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: <Widget>[
          // Audio section
          _buildSectionHeader(
            LocaleKeys.settings_audio_title.tr(),
            colorScheme,
          ),
          const Gap(8),
          _buildSettingsCard(
            colorScheme: colorScheme,
            children: <Widget>[
              // Microphone
              _buildSettingsRow(
                label: LocaleKeys.settings_audio_microphone.tr(),
                colorScheme: colorScheme,
                trailing: state.availableDevices.isEmpty
                    ? Text(
                        '...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : DropdownButton<String>(
                        value: state.selectedMicId ??
                            state.availableDevices.first.id,
                        underline: const SizedBox.shrink(),
                        dropdownColor: colorScheme.surfaceContainerLow,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        items: state.availableDevices
                            .map(
                              (d) => DropdownMenuItem<String>(
                                value: d.id,
                                child: Text(d.name),
                              ),
                            )
                            .toList(),
                        onChanged: (String? id) {
                          if (id != null) {
                            ref
                                .read(settingsViewModelProvider.notifier)
                                .updateMic(id);
                          }
                        },
                      ),
              ),
              _buildDivider(colorScheme),
              // System audio
              _buildSettingsRow(
                label: LocaleKeys.settings_audio_system_audio.tr(),
                subtitle: LocaleKeys.settings_audio_system_audio_description
                    .tr(),
                colorScheme: colorScheme,
                trailing: Switch.adaptive(
                  value: state.systemAudioEnabled,
                  onChanged: (_) async =>
                      ref.read(settingsViewModelProvider.notifier).toggleSystemAudio(),
                  activeTrackColor: colorScheme.primary,
                ),
              ),
              _buildDivider(colorScheme),
              // Level indicator
              _buildSettingsRow(
                label: LocaleKeys.settings_audio_level_indicator.tr(),
                colorScheme: colorScheme,
                trailing: Switch.adaptive(
                  value: true,
                  onChanged: (_) {},
                  activeTrackColor: colorScheme.primary,
                ),
              ),
            ],
          ),
          const Gap(24),
          // ML Server section
          _buildSectionHeader(
            LocaleKeys.settings_server_title.tr(),
            colorScheme,
          ),
          const Gap(8),
          _buildSettingsCard(
            colorScheme: colorScheme,
            children: <Widget>[
              // Model
              _buildSettingsRow(
                label: LocaleKeys.settings_server_model.tr(),
                colorScheme: colorScheme,
                trailing: _buildDropdownButton(
                  value: 'Voxtral-Mini-4B-Realtime',
                  colorScheme: colorScheme,
                ),
              ),
              _buildDivider(colorScheme),
              // Port
              _buildSettingsRow(
                label: LocaleKeys.settings_server_port.tr(),
                colorScheme: colorScheme,
                trailing: SizedBox(
                  width: 64,
                  child: TextField(
                    textAlign: TextAlign.right,
                    controller: TextEditingController(text: state.serverPort),
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLow,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      isDense: true,
                    ),
                    onSubmitted: (String value) => ref
                        .read(settingsViewModelProvider.notifier)
                        .updatePort(value),
                  ),
                ),
              ),
              _buildDivider(colorScheme),
              // Auto launch
              _buildSettingsRow(
                label: LocaleKeys.settings_server_auto_launch.tr(),
                colorScheme: colorScheme,
                trailing: Switch.adaptive(
                  value: state.autoStartServer,
                  onChanged: (_) => ref
                      .read(settingsViewModelProvider.notifier)
                      .toggleAutoStart(),
                  activeTrackColor: colorScheme.primary,
                ),
              ),
            ],
          ),
          const Gap(24),
          // Shortcuts section
          _buildSectionHeader(
            LocaleKeys.settings_shortcuts_title.tr(),
            colorScheme,
          ),
          const Gap(8),
          _buildSettingsCard(
            colorScheme: colorScheme,
            children: <Widget>[
              _buildSettingsRow(
                label: LocaleKeys.settings_shortcuts_start_stop.tr(),
                colorScheme: colorScheme,
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    KeyboardShortcutBadgeWidget(
                      keys: <String>['\u2318', '\u21E7', 'T'],
                    ),
                  ],
                ),
              ),
              _buildDivider(colorScheme),
              _buildSettingsRow(
                label: LocaleKeys.settings_shortcuts_pause.tr(),
                colorScheme: colorScheme,
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    KeyboardShortcutBadgeWidget(
                      keys: <String>['\u2318', '\u21E7', 'P'],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(24),
          // Storage section
          _buildSectionHeader(
            LocaleKeys.settings_storage_title.tr(),
            colorScheme,
          ),
          const Gap(8),
          _buildSettingsCard(
            colorScheme: colorScheme,
            children: <Widget>[
              // Storage location
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          LocaleKeys.settings_storage_location.tr(),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Open file picker.
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                          child: Text(
                            LocaleKeys.settings_storage_change.tr(),
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        state.storagePath,
                        style: textTheme.labelSmall?.copyWith(
                          fontFamily: 'monospace',
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildDivider(colorScheme),
              // Database size
              _buildSettingsRow(
                label: LocaleKeys.settings_storage_database_size.tr(),
                colorScheme: colorScheme,
                trailing: Text(
                  '${state.dbSizeMb.toStringAsFixed(0)} Mo',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const Gap(32),
          // About footer
          Center(
            child: Column(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    // TODO: Show about dialog.
                  },
                  child: Text(
                    LocaleKeys.settings_about.tr(),
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const Gap(4),
                Text(
                  'v0.1.0',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required ColorScheme colorScheme,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsRow({
    required String label,
    required ColorScheme colorScheme,
    required Widget trailing,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...<Widget>[
                  const Gap(2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: colorScheme.outlineVariant.withValues(alpha: 0.1),
    );
  }

  Widget _buildDropdownButton({
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(4),
          Icon(
            Icons.unfold_more,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
