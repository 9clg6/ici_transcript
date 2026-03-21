import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/services/session_history.service.dart';
import 'package:core_domain/domain/usecases/get_session_detail.use_case.dart';
import 'package:ici_transcript/application/services/summary.service.dart';
import 'package:ici_transcript/core/providers/services/session_history.service.provider.dart';
import 'package:ici_transcript/core/providers/services/summary.service.provider.dart';
import 'package:ici_transcript/features/history/presentation/screens/detail/session_detail.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_detail.view_model.g.dart';

/// ViewModel de l'ecran de detail d'une session.
///
/// Charge la session et ses segments, gere l'edition du titre,
/// la suppression, l'export et la copie du contenu.
@riverpod
class SessionDetailViewModel extends _$SessionDetailViewModel {
  late SessionHistoryService _sessionHistoryService;
  late SummaryService _summaryService;

  @override
  Future<SessionDetailState> build({required String sessionId}) async {
    _sessionHistoryService = ref.watch(sessionHistoryServiceProvider);
    _summaryService = ref.watch(summaryServiceProvider);
    return _loadSession(sessionId);
  }

  Future<SessionDetailState> _loadSession(String sessionId) async {
    final SessionDetailResult? detail = await _sessionHistoryService
        .getSessionDetail(sessionId);
    if (detail == null) {
      return SessionDetailState.initial();
    }
    final String? summary = await _summaryService.getSummaryForSession(
      sessionId,
    );
    return SessionDetailState(
      session: detail.session,
      segments: detail.segments,
      summary: summary,
    );
  }

  /// Met a jour le titre de la session.
  Future<void> updateTitle(String newTitle) async {
    final SessionDetailState currentState =
        state.valueOrNull ?? SessionDetailState.initial();
    final SessionEntity? session = currentState.session;
    if (session == null) return;

    await _sessionHistoryService.updateSessionTitle(
      sessionId: session.id,
      newTitle: newTitle,
    );

    state = AsyncData<SessionDetailState>(
      currentState.copyWith(
        session: session.copyWith(title: newTitle),
        isEditing: false,
      ),
    );
  }

  /// Supprime la session courante.
  Future<void> deleteSession() async {
    final SessionEntity? session = state.valueOrNull?.session;
    if (session == null) return;
    await _sessionHistoryService.deleteSession(session.id);
  }

  /// Exporte la transcription en Markdown.
  String exportMarkdown() {
    final SessionDetailState currentState =
        state.valueOrNull ?? SessionDetailState.initial();
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('# ${currentState.session?.title ?? ""}');
    buffer.writeln();
    for (final TranscriptSegmentEntity segment in currentState.segments) {
      buffer.writeln(
        '**[${segment.source.name.toUpperCase()}]** '
        '${segment.text}',
      );
      buffer.writeln();
    }
    return buffer.toString();
  }

  /// Copie la transcription complete dans le presse-papier.
  String copyToClipboard() {
    final SessionDetailState currentState =
        state.valueOrNull ?? SessionDetailState.initial();
    final StringBuffer buffer = StringBuffer();
    for (final TranscriptSegmentEntity segment in currentState.segments) {
      buffer.writeln('[${segment.source.name.toUpperCase()}] ${segment.text}');
    }
    return buffer.toString();
  }

  /// Supprime le résumé IA de la session.
  Future<void> deleteSummary() async {
    final SessionEntity? session = state.valueOrNull?.session;
    if (session == null) return;
    await _summaryService.deleteSummaryForSession(session.id);
    final SessionDetailState currentState =
        state.valueOrNull ?? SessionDetailState.initial();
    state = AsyncData<SessionDetailState>(
      currentState.copyWith(summary: null),
    );
  }

  /// Active ou desactive le mode edition du titre.
  void toggleEditing() {
    final SessionDetailState currentState =
        state.valueOrNull ?? SessionDetailState.initial();
    state = AsyncData<SessionDetailState>(
      currentState.copyWith(isEditing: !currentState.isEditing),
    );
  }
}
