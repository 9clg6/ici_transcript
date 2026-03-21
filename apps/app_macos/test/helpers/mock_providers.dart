import 'package:core_domain/domain/repositories/audio.repository.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_domain/domain/repositories/transcript.repository.dart';
import 'package:mockito/annotations.dart';

/// Annotations pour la generation des mocks.
///
/// Seules les interfaces abstraites sont mockables.
/// Les use cases et services (final class) sont testes
/// directement avec des mocks de repositories.
@GenerateMocks(<Type>[SessionRepository, TranscriptRepository, AudioRepository])
void main() {}
