# Architecture Flutter - Guide pour agents IA

> Ce document est la source de verite architecturale du projet. Tout agent IA generant du code DOIT le lire et le respecter integralement avant de produire la moindre ligne.

---

## Table des matieres

1. [Vue d'ensemble du monorepo](#1-vue-densemble-du-monorepo)
2. [Principes fondamentaux](#2-principes-fondamentaux)
3. [Separation des couches](#3-separation-des-couches)
4. [Structure feature-first](#4-structure-feature-first)
5. [Domain Layer — `packages/core_domain`](#5-domain-layer)
6. [Data Layer — `packages/core_data`](#6-data-layer)
7. [Presentation Layer — `apps/app_mobile/lib`](#7-presentation-layer)
8. [Foundation Layer — `packages/core_foundation`](#8-foundation-layer)
9. [Injection de dependances avec Riverpod 3.0](#9-injection-de-dependances-avec-riverpod-30)
10. [Localisation avec EasyLocalization](#10-localisation-avec-easylocalization)
11. [Assets avec flutter_gen](#11-assets-avec-flutter_gen)
12. [Navigation avec AutoRoute](#12-navigation-avec-autoroute)
13. [Generation de code](#13-generation-de-code)
14. [Conventions de nommage](#14-conventions-de-nommage)
15. [Checklist : ajouter une nouvelle feature](#15-checklist--ajouter-une-nouvelle-feature)
16. [Erreurs frequentes a eviter](#16-erreurs-frequentes-a-eviter)
17. [Exemples de reference complets](#17-exemples-de-reference-complets)

---

## 1. Vue d'ensemble du monorepo

```
project_root/
├── apps/
│   ├── app_mobile/              # Application Flutter mobile
│   │   ├── lib/
│   │   │   ├── application/     # Services applicatifs (orchestrateurs)
│   │   │   ├── core/            # Providers Riverpod, config locale
│   │   │   ├── features/        # Features organisees par domaine
│   │   │   ├── foundation/      # Routing, guards, utils app-level
│   │   │   ├── gen/             # Fichiers generes flutter_gen
│   │   │   ├── generated/       # Fichiers generes (locale_keys, etc.)
│   │   │   ├── presentation/    # Widgets partages, app.dart
│   │   │   └── main.dart
│   │   ├── assets/
│   │   │   ├── translations/    # fr.json, en.json...
│   │   │   └── images/
│   │   └── bricks/              # Templates Mason
│   └── api_agent_vocal/         # Backend Dart (meme patterns DDD)
├── packages/
│   ├── core_foundation/         # Interfaces de base, config, logging
│   ├── core_domain/             # Entites, repositories abstraits, use cases
│   ├── core_data/               # Models, endpoints, datasources, repo impls
│   └── core_presentation/       # Theme, services UI abstraits
└── pubspec.yaml                 # Workspace Dart 3.9+
```

### Regle absolue de dependance

```
core_foundation  <--  core_domain  <--  core_data  <--  app_mobile
                                    <--  core_presentation <--+
```

- `core_domain` ne depend QUE de `core_foundation`.
- `core_data` depend de `core_domain` + `core_foundation`.
- `app_mobile` depend de TOUS les packages.
- **Jamais** de dependance inverse : `core_domain` ne connait pas `core_data`.

---

## 2. Principes fondamentaux

### SOLID

| Principe | Application concrete |
|----------|---------------------|
| **S** — Single Responsibility | 1 use case = 1 action metier. 1 view model = 1 ecran. 1 datasource = 1 source de donnees. |
| **O** — Open/Closed | Les repository interfaces (domain) sont stables. Les implementations (data) peuvent changer sans impacter le domaine. |
| **L** — Liskov Substitution | `AppointmentRepositoryImpl implements AppointmentRepository` — l'impl est substituable sans casser l'appelant. |
| **I** — Interface Segregation | `abstract interface class XxxRemoteDataSource` — interfaces granulaires par responsabilite. |
| **D** — Dependency Inversion | Le domain declare des interfaces (`AppointmentRepository`). L'injection Riverpod fournit l'implementation (`AppointmentRepositoryImpl`). Jamais de dependance directe sur une implementation. |

### KISS — Keep It Simple, Stupid

- Un use case ne contient qu'un `invoke()`. Pas de logique conditionnelle complexe.
- Un view model orchestre des appels de services/use cases. Pas de logique HTTP.
- Un screen consomme un state et rend des widgets. Pas de logique metier.

### DRY — Don't Repeat Yourself

- Les mappers sont des extensions reutilisables (`XxxRemoteModelX.toEntity()`).
- Les base classes (`FutureUseCase`, `FutureUseCaseWithParams`) factorisent try/catch + timeout.
- Les widgets partages sont dans `presentation/widgets/` ou `features/shared/`.
- Les constantes textuelles sont centralisees dans `LocaleKeys`.

### Immutabilite

- **Tout** est immutable : entites, modeles, params, states.
- Freezed est utilise sur **chaque** classe de donnees sans exception.
- Les modifications passent par `copyWith()`.

---

## 3. Separation des couches

```
┌─────────────────────────────────────────────────────┐
│                  PRESENTATION                        │
│  Screen ←→ ViewModel ←→ State (Freezed)             │
│  ConsumerStatefulWidget    @riverpod class           │
│  @RoutePage()              AsyncValue<State>         │
│  ref.watch(viewModelProv)  state = AsyncData(...)    │
└───────────────────┬─────────────────────────────────┘
                    │ depends on
┌───────────────────▼─────────────────────────────────┐
│                   DOMAIN                             │
│  Entity (Freezed)                                    │
│  Repository (abstract class / abstract interface)    │
│  UseCase (FutureUseCase / FutureUseCaseWithParams)   │
│  Params (Freezed)                                    │
│  Service (orchestrateur multi-use-cases, BSubject)   │
└───────────────────┬─────────────────────────────────┘
                    │ implemented by
┌───────────────────▼─────────────────────────────────┐
│                    DATA                              │
│  RemoteModel (Freezed + JSON)                        │
│  LocalModel (JSON serializable)                      │
│  Endpoint (Retrofit @RestApi)                        │
│  DataSource (interface + impl)                       │
│  RepositoryImpl (mapping RemoteModel → Entity)       │
│  Mapper (extensions toEntity() / fromEntity())       │
└─────────────────────────────────────────────────────┘
```

### Flux de donnees complet (lecture)

```
Screen
  → ref.watch(viewModelProvider)
    → ViewModel.build()
      → ref.watch(xxxUseCaseProvider.future)
        → UseCase.invoke(params)
          → Repository.getXxx(...)           // interface domain
            → RepositoryImpl.getXxx(...)     // impl data
              → DataSource.getXxx(...)       // interface data
                → DataSourceImpl.getXxx(...) // impl data
                  → Endpoint.getXxx(...)     // Retrofit/Dio
                    → API HTTP
```

---

## 4. Structure feature-first

Chaque fonctionnalite est isolee dans un dossier sous `lib/features/` :

```
lib/features/
├── client/
│   └── presentation/
│       └── screens/
│           ├── home/
│           │   ├── client_home.screen.dart
│           │   ├── client_home.view_model.dart
│           │   ├── client_home.view_model.g.dart       # GENERE
│           │   ├── client_home.state.dart
│           │   ├── client_home.state.freezed.dart       # GENERE
│           │   ├── widgets/                             # Widgets specifiques a cet ecran
│           │   ├── models/                              # Models de presentation si besoin
│           │   └── providers/                           # Providers locaux si besoin
│           ├── search/
│           │   ├── client_search.screen.dart
│           │   ├── client_search.view_model.dart
│           │   ├── client_search.state.dart
│           │   └── widgets/
│           ├── appointments/
│           │   └── ...
│           └── settings/
│               └── ...
├── artisan/
│   └── presentation/
│       └── screens/
│           ├── dashboard/
│           ├── planning/
│           └── ...
├── shared/
│   └── presentation/
│       ├── screens/          # Ecrans communs (auth, splash...)
│       └── widgets/          # Widgets reutilisables cross-feature
└── tutorial/
    └── ...
```

### Regle de la triade ecran

Chaque ecran est TOUJOURS compose de **3 fichiers** :

| Fichier | Responsabilite |
|---------|---------------|
| `xxx.state.dart` | Etat immutable (Freezed). Definit ce que l'ecran affiche. |
| `xxx.view_model.dart` | Logique de presentation (@riverpod class). Orchestre les use cases/services et met a jour le state. |
| `xxx.screen.dart` | Widget UI (@RoutePage ConsumerStatefulWidget). Consomme le state, ne contient AUCUNE logique. |

---

## 5. Domain Layer

**Package** : `packages/core_domain/`

```
core_domain/lib/
├── domain/
│   ├── entities/          # Entites metier (Freezed, immutables)
│   ├── params/            # Parametres d'appel (Freezed + JSON)
│   ├── enum/              # Enums metier (@JsonEnum)
│   ├── repositories/      # Interfaces de repositories
│   ├── usecases/          # Use cases (FutureUseCase / FutureUseCaseWithParams)
│   └── services/          # Services applicatifs (orchestrateurs)
└── localization/          # Fichiers de localisation generes
```

### 5.1 Entite (Freezed)

```dart
// fichier : packages/core_domain/lib/domain/entities/appointment.entity.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.entity.freezed.dart';

/// Entite representant un rendez-vous.
@freezed
abstract class AppointmentEntity with _$AppointmentEntity {
  /// Cree une instance de [AppointmentEntity].
  const factory AppointmentEntity({
    required String id,
    required DateTime startHour,
    required DateTime endHour,
    required DateTime date,
    required ClientEntity client,
    required String reason,
    required AppointmentStatus status,
    @Default('') String notes,
  }) = _AppointmentEntity;
}
```

**Regles** :
- `@freezed abstract class` avec `_$NomEntite`.
- `part 'xxx.entity.freezed.dart';` — jamais de `.g.dart` (pas de JSON sur les entites).
- `const factory` avec named parameters.
- `@Default(valeur)` pour les valeurs par defaut.
- Documentation `///` sur la classe et le constructeur factory.
- Pas de logique metier dans l'entite. Les proprietes calculees passent par une extension.

### 5.2 Params (Freezed + JSON)

```dart
// fichier : packages/core_domain/lib/domain/params/create_appointment.param.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_appointment.param.freezed.dart';
part 'create_appointment.param.g.dart';

/// Parametres pour la creation d'un rendez-vous.
@Freezed()
abstract class CreateAppointmentParam with _$CreateAppointmentParam {
  /// Cree une instance de [CreateAppointmentParam].
  const factory CreateAppointmentParam({
    required String clientId,
    required String artisanId,
    required DateTime date,
    required DateTime startHour,
    required String reason,
  }) = _CreateAppointmentParam;

  /// Cree une instance depuis un JSON.
  factory CreateAppointmentParam.fromJson(Map<String, dynamic> json) =>
      _$CreateAppointmentParamFromJson(json);
}
```

**Regles** :
- Les params ont `fromJson` car ils sont serialises pour les appels API.
- Part `.freezed.dart` ET `.g.dart`.

### 5.3 Repository — Interface

```dart
// fichier : packages/core_domain/lib/domain/repositories/appointment.repository.dart

/// Contrat du repository de rendez-vous.
abstract interface class AppointmentRepository {
  /// Recupere la liste des rendez-vous selon les filtres.
  Future<List<AppointmentEntity>> getAppointments({
    String? artisanId,
    String? clientId,
    String? date,
  });

  /// Recupere un rendez-vous par son identifiant.
  Future<AppointmentEntity?> getAppointment(String id);

  /// Cree un rendez-vous.
  Future<AppointmentEntity> createAppointment(AppointmentEntity appointment);

  /// Met a jour un rendez-vous.
  Future<AppointmentEntity> updateAppointment(
    String id,
    AppointmentEntity appointment,
  );

  /// Supprime un rendez-vous.
  Future<void> deleteAppointment(String id);
}
```

**Regles** :
- `abstract interface class` (Dart 3).
- Les types de retour et parametres sont des **entites domain**, jamais des modeles data.
- Documentation `///` sur chaque methode.

### 5.4 Use Case

```dart
// fichier : packages/core_domain/lib/domain/usecases/get_appointments.use_case.dart

import 'package:core_foundation/interfaces/future.usecases.dart';

/// Parametres pour [GetAppointmentsUseCase].
class GetAppointmentsParams {
  /// Cree une instance de [GetAppointmentsParams].
  const GetAppointmentsParams({
    this.artisanId,
    this.clientId,
    this.date,
  });

  /// Identifiant de l'artisan.
  final String? artisanId;

  /// Identifiant du client.
  final String? clientId;

  /// Date au format ISO.
  final String? date;
}

/// Recupere la liste des rendez-vous.
final class GetAppointmentsUseCase
    extends FutureUseCaseWithParams<List<AppointmentEntity>, GetAppointmentsParams> {
  /// Cree une instance de [GetAppointmentsUseCase].
  GetAppointmentsUseCase({
    required AppointmentRepository appointmentRepository,
  }) : _appointmentRepository = appointmentRepository;

  final AppointmentRepository _appointmentRepository;

  @override
  Future<List<AppointmentEntity>> invoke(GetAppointmentsParams params) {
    return _appointmentRepository.getAppointments(
      artisanId: params.artisanId,
      clientId: params.clientId,
      date: params.date,
    );
  }
}
```

**Regles** :
- `final class` — jamais etendu.
- Etend `FutureUseCase<T>` (sans params) ou `FutureUseCaseWithParams<T, P>` (avec params).
- Implemente **uniquement** `invoke()`. Ne jamais surcharger `execute()`.
- Injection par constructeur. Le champ est prive final (`_`).
- Un seul repository par use case (SRP). Si plusieurs repos sont necessaires, creer un Service.

### 5.5 Service applicatif (Domain)

```dart
// fichier : packages/core_domain/lib/domain/services/appointment.service.dart

/// Service orchestrant les operations sur les rendez-vous.
final class AppointmentService {
  /// Cree une instance de [AppointmentService].
  AppointmentService({
    required GetAppointmentsUseCase getAppointmentsUseCase,
    required CreateAppointmentUseCase createAppointmentUseCase,
    required UpdateAppointmentUseCase updateAppointmentUseCase,
    required DeleteAppointmentUseCase deleteAppointmentUseCase,
  }) : _getAppointmentsUseCase = getAppointmentsUseCase,
       _createAppointmentUseCase = createAppointmentUseCase,
       _updateAppointmentUseCase = updateAppointmentUseCase,
       _deleteAppointmentUseCase = deleteAppointmentUseCase;

  final GetAppointmentsUseCase _getAppointmentsUseCase;
  final CreateAppointmentUseCase _createAppointmentUseCase;
  final UpdateAppointmentUseCase _updateAppointmentUseCase;
  final DeleteAppointmentUseCase _deleteAppointmentUseCase;

  /// Stream reactif des rendez-vous.
  final BehaviorSubject<List<AppointmentEntity>> appointmentsStream =
      BehaviorSubject<List<AppointmentEntity>>.seeded(<AppointmentEntity>[]);

  /// Charge les rendez-vous.
  Future<void> loadAppointments({String? artisanId}) async {
    final ResultState<List<AppointmentEntity>> result =
        await _getAppointmentsUseCase.execute(
      GetAppointmentsParams(artisanId: artisanId),
    );
    result.when(
      success: (List<AppointmentEntity> data) {
        appointmentsStream.add(data);
      },
      failure: (Exception e) {
        debugPrint('[AppointmentService] loadAppointments error: $e');
      },
    );
  }
}
```

**Regles** :
- Les services orchestrent **plusieurs use cases** et/ou maintiennent un etat reactif via `BehaviorSubject`.
- Ils vivent dans `core_domain/lib/domain/services/` s'ils sont partageables, ou dans `app_mobile/lib/application/services/` s'ils sont specifiques a l'app mobile.

---

## 6. Data Layer

**Package** : `packages/core_data/`

```
core_data/lib/
├── bodies/             # Request bodies complexes (si besoin)
├── clients/            # Configuration Dio
├── datasources/
│   ├── remote/         # Interfaces datasources distantes
│   │   └── impl/       # Implementations datasources distantes
│   └── local/          # Interfaces datasources locales
│       └── impl/       # Implementations datasources locales
├── endpoint/           # Endpoints Retrofit
├── mappers/            # Extensions de mapping Model ↔ Entity
├── model/
│   ├── remote/         # Modeles API (Freezed + JSON)
│   └── local/          # Modeles stockage local (JSON)
├── models/             # Alias / anciens modeles (a consolider)
├── repositories/       # Implementations de repositories
└── storages/           # Implementations StorageInterface
```

### 6.1 Remote Model (Freezed + JSON)

```dart
// fichier : packages/core_data/lib/model/remote/appointment.remote.model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.remote.model.freezed.dart';
part 'appointment.remote.model.g.dart';

/// Modele de donnees distant pour un rendez-vous.
@freezed
abstract class AppointmentRemoteModel with _$AppointmentRemoteModel {
  /// Cree une instance de [AppointmentRemoteModel].
  const factory AppointmentRemoteModel({
    required String id,
    @JsonKey(name: 'start_hour') required DateTime startHour,
    @JsonKey(name: 'end_hour') required DateTime endHour,
    required DateTime date,
    required String reason,
    required String status,
    @Default('') String notes,
  }) = _AppointmentRemoteModel;

  /// Cree une instance depuis un JSON.
  factory AppointmentRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentRemoteModelFromJson(json);
}
```

**Regles** :
- Part `.freezed.dart` ET `.g.dart`.
- `@JsonKey(name: 'xxx')` quand le champ API differe du nom Dart.
- Les types sont primitifs ou d'autres RemoteModels. **Jamais** d'entite domain.

### 6.2 Endpoint (Retrofit)

```dart
// fichier : packages/core_data/lib/endpoint/appointment.endpoint.dart

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'appointment.endpoint.g.dart';

/// Endpoint API pour les rendez-vous.
@RestApi()
abstract class AppointmentEndpoint {
  /// Cree une instance de [AppointmentEndpoint].
  factory AppointmentEndpoint(Dio dio) = _AppointmentEndpoint;

  /// Recupere la liste des rendez-vous.
  @GET('/appointments')
  Future<List<AppointmentRemoteModel>> getAppointments({
    @Query('artisanId') String? artisanId,
    @Query('clientId') String? clientId,
    @Query('date') String? date,
  });

  /// Cree un rendez-vous.
  @POST('/appointments')
  Future<AppointmentRemoteModel> createAppointment(
    @Body() AppointmentRemoteModel appointment,
  );

  /// Met a jour un rendez-vous.
  @PUT('/appointments/{id}')
  Future<AppointmentRemoteModel> updateAppointment(
    @Path('id') String id,
    @Body() AppointmentRemoteModel appointment,
  );

  /// Supprime un rendez-vous.
  @DELETE('/appointments/{id}')
  Future<void> deleteAppointment(@Path('id') String id);
}
```

**Regles** :
- `@RestApi()` sans `baseUrl` — il est configure au niveau du `Dio` client.
- `part 'xxx.endpoint.g.dart';`
- Les types de retour sont des **RemoteModels**, jamais des entites.
- `factory XxxEndpoint(Dio dio) = _XxxEndpoint;`

### 6.3 DataSource — Interface

```dart
// fichier : packages/core_data/lib/datasources/remote/appointment.remote.data_source.dart

/// Contrat de la source de donnees distante pour les rendez-vous.
abstract interface class AppointmentRemoteDataSource {
  /// Recupere la liste des rendez-vous.
  Future<List<AppointmentRemoteModel>> getAppointments({
    String? artisanId,
    String? clientId,
    String? date,
  });

  /// Recupere un rendez-vous par son identifiant.
  Future<AppointmentRemoteModel> getAppointment(String id);

  /// Cree un rendez-vous.
  Future<AppointmentRemoteModel> createAppointment(
    AppointmentRemoteModel appointment,
  );

  /// Met a jour un rendez-vous.
  Future<AppointmentRemoteModel> updateAppointment(
    String id,
    AppointmentRemoteModel appointment,
  );

  /// Supprime un rendez-vous.
  Future<void> deleteAppointment(String id);
}
```

### 6.4 DataSource — Implementation

```dart
// fichier : packages/core_data/lib/datasources/remote/impl/appointment.remote.data_source.impl.dart

/// Implementation de [AppointmentRemoteDataSource].
final class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  /// Cree une instance de [AppointmentRemoteDataSourceImpl].
  AppointmentRemoteDataSourceImpl({required AppointmentEndpoint endpoint})
      : _endpoint = endpoint;

  final AppointmentEndpoint _endpoint;

  @override
  Future<List<AppointmentRemoteModel>> getAppointments({
    String? artisanId,
    String? clientId,
    String? date,
  }) async {
    return _endpoint.getAppointments(
      artisanId: artisanId,
      clientId: clientId,
      date: date,
    );
  }

  @override
  Future<AppointmentRemoteModel> createAppointment(
    AppointmentRemoteModel appointment,
  ) async {
    return _endpoint.createAppointment(appointment);
  }

  // ... autres methodes
}
```

**Regles** :
- `final class ... implements XxxRemoteDataSource`.
- Delegation pure vers l'endpoint. Aucune logique de mapping ici.
- Le datasource peut ajouter du caching, de la pagination, du retry — c'est sa responsabilite.

### 6.5 Repository — Implementation

```dart
// fichier : packages/core_data/lib/repositories/appointment.repository.impl.dart

/// Implementation de [AppointmentRepository].
final class AppointmentRepositoryImpl implements AppointmentRepository {
  /// Cree une instance de [AppointmentRepositoryImpl].
  AppointmentRepositoryImpl({
    required AppointmentRemoteDataSource appointmentRemoteDataSource,
  }) : _remoteDataSource = appointmentRemoteDataSource;

  final AppointmentRemoteDataSource _remoteDataSource;

  @override
  Future<List<AppointmentEntity>> getAppointments({
    String? artisanId,
    String? clientId,
    String? date,
  }) async {
    final List<AppointmentRemoteModel> remoteList =
        await _remoteDataSource.getAppointments(
      artisanId: artisanId,
      clientId: clientId,
      date: date,
    );
    return remoteList.map((AppointmentRemoteModel e) => e.toEntity()).toList();
  }

  // ... autres methodes avec mapping inverse pour les ecritures
}
```

**Regles** :
- `final class ... implements XxxRepository` (l'interface du domain).
- Recoit un/des DataSource(s) par injection.
- **C'est ici et uniquement ici** que le mapping `RemoteModel ↔ Entity` se fait.
- Utilise les extensions mapper (`.toEntity()`, `.fromEntity()`).

### 6.6 Mapper (Extension)

```dart
// fichier : packages/core_data/lib/mappers/appointment.mapper.dart

/// Extensions de mapping pour [AppointmentRemoteModel].
extension AppointmentRemoteModelX on AppointmentRemoteModel {
  /// Convertit en [AppointmentEntity].
  AppointmentEntity toEntity() => AppointmentEntity(
    id: id,
    startHour: startHour,
    endHour: endHour,
    date: date,
    reason: reason,
    status: AppointmentStatus.values.byName(status),
    notes: notes,
  );
}

/// Extensions de mapping pour [AppointmentEntity].
extension AppointmentEntityToRemoteX on AppointmentEntity {
  /// Convertit en [AppointmentRemoteModel].
  AppointmentRemoteModel toRemoteModel() => AppointmentRemoteModel(
    id: id,
    startHour: startHour,
    endHour: endHour,
    date: date,
    reason: reason,
    status: status.name,
    notes: notes,
  );
}
```

**Regles** :
- Fichier dedie `xxx.mapper.dart` dans `core_data/lib/mappers/`.
- Nommage de l'extension : `XxxRemoteModelX` et `XxxEntityToRemoteX`.
- Un mapper par couple model/entite.

---

## 7. Presentation Layer

### 7.1 State (Freezed)

```dart
// fichier : lib/features/client/presentation/screens/appointments/client_appointments.state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_appointments.state.freezed.dart';

/// Etat de l'ecran des rendez-vous client.
@Freezed(copyWith: true)
abstract class ClientAppointmentsState with _$ClientAppointmentsState {
  /// Cree une instance de [ClientAppointmentsState].
  const factory ClientAppointmentsState({
    required List<AppointmentEntity> upcomingAppointments,
    required List<AppointmentEntity> pastAppointments,
    @Default(false) bool isRefreshing,
  }) = _ClientAppointmentsState;

  /// Etat initial par defaut.
  factory ClientAppointmentsState.initial() => const ClientAppointmentsState(
    upcomingAppointments: <AppointmentEntity>[],
    pastAppointments: <AppointmentEntity>[],
  );
}
```

**Regles** :
- `@Freezed(copyWith: true)`.
- Factory nommee `.initial()` pour l'etat de depart.
- Tous les champs sont des types immutables (List, entites Freezed, primitifs).
- Part `.freezed.dart` uniquement (pas de `.g.dart`).
- **Sealed class** si l'etat a des variantes distinctes :

```dart
@Freezed()
sealed class PaymentState with _$PaymentState {
  const factory PaymentState.idle() = PaymentIdle;
  const factory PaymentState.processing() = PaymentProcessing;
  const factory PaymentState.success(String transactionId) = PaymentSuccess;
  const factory PaymentState.failure(String message) = PaymentFailure;
}
```

### 7.2 ViewModel (Riverpod 3.0 code-gen)

#### Pattern asynchrone (recommande pour les ecrans avec chargement initial) :

```dart
// fichier : lib/features/client/presentation/screens/appointments/client_appointments.view_model.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'client_appointments.view_model.g.dart';

/// ViewModel de l'ecran des rendez-vous client.
@riverpod
class ClientAppointmentsViewModel extends _$ClientAppointmentsViewModel {
  late AppointmentService _appointmentService;

  @override
  Future<ClientAppointmentsState> build() async {
    _appointmentService = await ref.watch(appointmentServiceProvider.future);
    return _fetch();
  }

  Future<ClientAppointmentsState> _fetch({bool force = false}) async {
    await _appointmentService.loadAppointments(force: force);
    final List<AppointmentEntity> all =
        _appointmentService.appointmentsStream.value;
    return ClientAppointmentsState(
      upcomingAppointments: all.where((AppointmentEntity a) =>
          a.status == AppointmentStatus.confirmed).toList(),
      pastAppointments: all.where((AppointmentEntity a) =>
          a.status == AppointmentStatus.completed).toList(),
    );
  }

  /// Rafraichit les rendez-vous.
  Future<void> refresh() async {
    state = const AsyncLoading<ClientAppointmentsState>();
    state = await AsyncValue.guard<ClientAppointmentsState>(
      () => _fetch(force: true),
    );
  }

  /// Supprime un rendez-vous.
  Future<void> deleteAppointment(String id) async {
    await _appointmentService.deleteAppointment(id);
    state = await AsyncValue.guard<ClientAppointmentsState>(() => _fetch());
  }
}
```

#### Pattern synchrone (quand les donnees sont deja disponibles) :

```dart
@riverpod
class ClientHomeViewModel extends _$ClientHomeViewModel {
  @override
  ClientHomeState build() {
    _init();
    return ClientHomeState.initial();
  }

  Future<void> _init() async {
    // Charge les donnees et met a jour le state
    final UserEntity? user = ref.read(currentUserProvider).valueOrNull;
    state = state.copyWith(userName: user?.firstname ?? '');
  }

  /// Met a jour la recherche.
  void updateSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }
}
```

**Regles** :
- `@riverpod class XxxViewModel extends _$XxxViewModel`.
- `build()` retourne `Future<XxxState>` (async) ou `XxxState` (sync).
- Les methodes publiques modifient `state` via `state = AsyncData(...)` ou `state = state.copyWith(...)`.
- Utiliser `AsyncValue.guard()` pour les operations async dans les methodes.
- Les dependances sont resolues dans `build()` via `ref.watch(xxxProvider.future)`.
- `late` pour les services initialises dans `build()`.
- Pas de `@Riverpod(keepAlive: true)` sur les view models — ils sont auto-dispose.

### 7.3 Screen (ConsumerStatefulWidget)

```dart
// fichier : lib/features/client/presentation/screens/appointments/client_appointments.screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

/// Ecran des rendez-vous du client.
@RoutePage()
class ClientAppointmentsScreen extends ConsumerStatefulWidget {
  /// Cree une instance de [ClientAppointmentsScreen].
  const ClientAppointmentsScreen({super.key});

  @override
  ConsumerState<ClientAppointmentsScreen> createState() =>
      _ClientAppointmentsScreenState();
}

class _ClientAppointmentsScreenState
    extends ConsumerState<ClientAppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<ClientAppointmentsState> asyncState =
        ref.watch(clientAppointmentsViewModelProvider);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.appointments_title.tr()),
      ),
      body: asyncState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (Object error, StackTrace stackTrace) => Center(
          child: Text(LocaleKeys.common_error_generic.tr()),
        ),
        data: (ClientAppointmentsState state) => RefreshIndicator(
          onRefresh: () => ref
              .read(clientAppointmentsViewModelProvider.notifier)
              .refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(
                LocaleKeys.appointments_upcoming.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(8),
              ...state.upcomingAppointments.map(
                (AppointmentEntity a) => AppointmentCard(appointment: a),
              ),
              const Gap(24),
              Text(
                LocaleKeys.appointments_past.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(8),
              ...state.pastAppointments.map(
                (AppointmentEntity a) => AppointmentCard(appointment: a),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Regles critiques pour les screens** :

1. **`@RoutePage()`** obligatoire sur chaque ecran.
2. **`ConsumerStatefulWidget`** — toujours, meme si stateless semble suffire (coherence).
3. **`asyncState.when(loading:, error:, data:)`** — pattern obligatoire pour les VM async.
4. **Zero string en dur** — tout passe par `LocaleKeys.xxx.tr()`.
5. **Zero couleur en dur** — tout passe par `Theme.of(context).colorScheme`.
6. **`Gap(n)`** pour les espacements, pas de `SizedBox`.
7. **`ref.watch(xxxViewModelProvider)`** pour ecouter le state.
8. **`ref.read(xxxViewModelProvider.notifier).method()`** pour les actions.
9. **Padding/margin** via `const EdgeInsets`, pas de valeurs magiques.

---

## 8. Foundation Layer

**Package** : `packages/core_foundation/`

```
core_foundation/lib/
├── config/
│   ├── app_config.dart          # Classe abstraite AppConfig
│   └── impl/
│       ├── app_config.dev.dart
│       ├── app_config.prod.dart
│       ├── app_config.staging.dart
│       ├── app_config.mock.dart
│       └── app_config.test.dart
├── interfaces/
│   ├── usecase.interfaces.dart       # BaseUseCase, BaseUseCaseWithParams
│   ├── future.usecases.dart          # FutureUseCase, FutureUseCaseWithParams
│   ├── stream.usecases.dart          # StreamUseCase, StreamUseCaseWithParams
│   ├── results.usecases.dart         # ResultState<T>
│   └── storage.interface.dart        # StorageInterface<T>
├── enum/                             # Enums partages (Environment, etc.)
├── exceptions/                       # Exceptions custom
├── extensions/                       # Extensions Dart generiques
└── logging/
    └── logger.dart                   # Log.named('Component')
```

### 8.1 AppConfig

```dart
// fichier : packages/core_foundation/lib/config/app_config.dart

/// Configuration abstraite de l'application.
abstract class AppConfig {
  /// Cree une instance de [AppConfig].
  const AppConfig({
    required this.appName,
    required this.baseUrl,
    required this.sireneBaseUrl,
    required this.env,
  });

  /// Environnement courant.
  final Environment env;

  /// Nom de l'application.
  final String appName;

  /// URL de base de l'API.
  final String baseUrl;

  /// URL de base de l'API Sirene.
  final String sireneBaseUrl;

  /// Indique si c'est la production.
  bool get isProd => env == Environment.production;
}
```

```dart
// fichier : packages/core_foundation/lib/config/impl/app_config.dev.dart

/// Configuration de l'environnement de developpement.
final class AppConfigDev extends AppConfig {
  /// Cree une instance de [AppConfigDev].
  const AppConfigDev()
      : super(
          appName: 'IciArtisan Dev',
          baseUrl: 'https://api-dev.iciartisan.fr',
          sireneBaseUrl: 'https://api.sirene.fr',
          env: Environment.development,
        );
}
```

### 8.2 FutureUseCase (classe de base)

```dart
// fichier : packages/core_foundation/lib/interfaces/future.usecases.dart

/// Use case asynchrone sans parametres.
abstract class FutureUseCase<T> implements BaseUseCase<Future<ResultState<T>>> {
  @override
  Future<ResultState<T>> execute() async => _futureCatcher(invoke);

  /// Methode a implementer par les sous-classes.
  Future<T> invoke();
}

/// Use case asynchrone avec parametres.
abstract class FutureUseCaseWithParams<T, P>
    implements BaseUseCaseWithParams<Future<ResultState<T>>, P> {
  @override
  Future<ResultState<T>> execute(P params) async =>
      _futureCatcher(() => invoke(params));

  /// Methode a implementer par les sous-classes.
  Future<T> invoke(P params);
}
```

- `execute()` est le point d'entree public — il wrape `invoke()` avec try/catch + timeout (15s).
- **Ne jamais appeler `invoke()` directement** depuis l'exterieur du use case. Toujours passer par `execute()`.
- Le resultat est un `ResultState<T>` (success/failure) qu'on traite avec `.when()`.

### 8.3 ResultState

```dart
// fichier : packages/core_foundation/lib/interfaces/results.usecases.dart

/// Resultat d'un use case : succes ou echec.
class ResultState<T> {
  /// Cree un resultat de succes.
  factory ResultState.success(T data) => ResultState<T>._(data: data);

  /// Cree un resultat d'echec.
  factory ResultState.failure(Exception exception) =>
      ResultState<T>._(exception: exception);

  /// Applique un callback selon le resultat.
  R? when<R>({
    R Function(T data)? success,
    R Function(Exception exception)? failure,
  });
}
```

### 8.4 Logging

```dart
// Utilisation
final Log _log = Log.named('AppointmentRepositoryImpl');
_log.info('Fetching appointments for artisan: $artisanId');
_log.error('Failed to fetch appointments', error, stackTrace);
```

---

## 9. Injection de dependances avec Riverpod 3.0

### 9.1 Chaine d'injection complete

```
dioClientProvider (keepAlive)
    └→ xxxEndpointProvider
        └→ xxxRemoteDataSourceProvider
            └→ xxxRepositoryProvider
                └→ xxxUseCaseProvider
                    └→ xxxServiceProvider (keepAlive si singleton)
                        └→ xxxViewModelProvider (auto-dispose)
```

### 9.2 Organisation des providers

```
lib/core/providers/
├── data/
│   ├── endpoint/
│   │   ├── appointment.endpoint.provider.dart
│   │   ├── artisan.endpoint.provider.dart
│   │   └── ...
│   └── datasource/
│       ├── appointment.remote.data_source.provider.dart
│       └── ...
├── core/
│   ├── repositories/
│   │   ├── appointment.repository.provider.dart
│   │   └── ...
│   └── usecases/
│       ├── get_appointments.use_case.provider.dart
│       └── ...
├── services/
│   ├── appointment.service.provider.dart
│   └── ...
├── kernel.provider.dart            # Bootstrap de l'app
├── current_user.provider.dart      # Stream user courant
└── dio_client.provider.dart        # Client HTTP singleton
```

### 9.3 Exemples de providers

#### Endpoint Provider

```dart
// fichier : lib/core/providers/data/endpoint/appointment.endpoint.provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointment.endpoint.provider.g.dart';

/// Provider pour [AppointmentEndpoint].
@riverpod
Future<AppointmentEndpoint> appointmentEndpoint(Ref ref) async {
  final DioClient dio = await ref.watch(dioClientProvider.future);
  return AppointmentEndpoint(dio);
}
```

#### DataSource Provider

```dart
// fichier : lib/core/providers/data/datasource/appointment.remote.data_source.provider.dart

part 'appointment.remote.data_source.provider.g.dart';

/// Provider pour [AppointmentRemoteDataSource].
@riverpod
Future<AppointmentRemoteDataSource> appointmentRemoteDataSource(
  Ref ref,
) async {
  final AppointmentEndpoint endpoint =
      await ref.watch(appointmentEndpointProvider.future);
  return AppointmentRemoteDataSourceImpl(endpoint: endpoint);
}
```

#### Repository Provider

```dart
// fichier : lib/core/providers/core/repositories/appointment.repository.provider.dart

part 'appointment.repository.provider.g.dart';

/// Provider pour [AppointmentRepository].
@riverpod
Future<AppointmentRepository> appointmentRepository(Ref ref) async {
  final AppointmentRemoteDataSource remoteDataSource =
      await ref.watch(appointmentRemoteDataSourceProvider.future);
  return AppointmentRepositoryImpl(
    appointmentRemoteDataSource: remoteDataSource,
  );
}
```

#### Use Case Provider

```dart
// fichier : lib/core/providers/core/usecases/get_appointments.use_case.provider.dart

part 'get_appointments.use_case.provider.g.dart';

/// Provider pour [GetAppointmentsUseCase].
@riverpod
Future<GetAppointmentsUseCase> getAppointmentsUseCase(Ref ref) async {
  final AppointmentRepository repository =
      await ref.watch(appointmentRepositoryProvider.future);
  return GetAppointmentsUseCase(appointmentRepository: repository);
}
```

### 9.4 Regles Riverpod

| Annotation | Usage | Auto-dispose |
|------------|-------|-------------|
| `@riverpod` | Endpoints, datasources, repositories, use cases, view models | Oui |
| `@Riverpod(keepAlive: true)` | Singletons : DioClient, Router, NavigationService, UserService, Kernel | Non |

- **Toujours** `ref.watch(xxxProvider.future)` pour resoudre les futures dans les providers.
- **Jamais** de `ref.read` dans `build()` d'un ViewModel — toujours `ref.watch`.
- `ref.read` uniquement dans les callbacks utilisateur (bouton presse, etc.).
- Les providers sont des **fonctions top-level** annotees `@riverpod`, pas des variables globales.

### 9.5 Kernel Provider (bootstrap)

```dart
// fichier : lib/core/providers/kernel.provider.dart

/// Initialise les dependances au demarrage.
@Riverpod(keepAlive: true)
Future<void> kernel(Ref ref) async {
  final AppConfig config = ref.watch(appConfigProvider);

  // Initialisation parallele
  final (DioClient dioClient, AuthLocalDataSource authLocalDS) = await (
    ref.watch(dioClientProvider.future),
    ref.watch(authLocalDataSourceProvider.future),
  ).wait;

  // Configuration du token interceptor
  dioClient.setTokenInterceptor(
    getFreshToken: () async {
      final AuthLocalModel? auth = await authLocalDS.getAuthToken();
      return auth?.token;
    },
  );

  // Chargement du user
  final UserService userService = await ref.watch(userServiceProvider.future);
  await userService.loadUser();
}
```

---

## 10. Localisation avec EasyLocalization

### 10.1 Configuration

```dart
// dans main.dart
runApp(
  ProviderScope(
    child: EasyLocalization(
      supportedLocales: const <Locale>[Locale('fr')],
      path: 'assets/translations',
      child: const RootAppWidget(),
    ),
  ),
);
```

### 10.2 Fichiers de traduction

```
assets/translations/
└── fr.json
```

Structure du JSON :
```json
{
  "common": {
    "error": {
      "generic": "Une erreur est survenue",
      "network": "Verifiez votre connexion internet"
    },
    "action": {
      "save": "Enregistrer",
      "cancel": "Annuler",
      "delete": "Supprimer",
      "confirm": "Confirmer"
    }
  },
  "appointments": {
    "title": "Mes rendez-vous",
    "upcoming": "A venir",
    "past": "Passes",
    "empty": "Aucun rendez-vous"
  }
}
```

### 10.3 Generation des LocaleKeys

```bash
# Via Melos ou directement
dart run easy_localization:generate -S assets/translations -f keys -O lib/generated -o locale_keys.g.dart
```

### 10.4 Utilisation dans le code

```dart
// TOUJOURS :
Text(LocaleKeys.appointments_title.tr())
Text(LocaleKeys.common_greeting.tr(args: <String>[firstName]))
Text(LocaleKeys.items_count.plural(count))

// JAMAIS :
Text('Mes rendez-vous')        // INTERDIT
Text('Bonjour $firstName')     // INTERDIT
```

**Regle absolue** : AUCUNE string affichee a l'utilisateur ne doit etre ecrite en dur dans le code Dart. Tout passe par `LocaleKeys.xxx.tr()`.

### 10.5 Ajout d'une nouvelle cle

1. Ajouter la cle dans `assets/translations/fr.json`.
2. Lancer la generation : `dart run easy_localization:generate ...`
3. Utiliser `LocaleKeys.nouvelle_cle.tr()` dans le code.

---

## 11. Assets avec flutter_gen

### 11.1 Configuration (pubspec.yaml)

```yaml
flutter_gen:
  output: lib/gen
  integrations:
    flutter_svg: true
```

### 11.2 Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 11.3 Utilisation

```dart
// TOUJOURS :
Image.asset(Assets.images.logo.path)
SvgPicture.asset(Assets.images.iconSearch.path)

// JAMAIS :
Image.asset('assets/images/logo.png')     // INTERDIT
SvgPicture.asset('assets/images/icon_search.svg')  // INTERDIT
```

---

## 12. Navigation avec AutoRoute

### 12.1 Configuration du Router

```dart
// fichier : lib/foundation/routing/app_router.dart

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required Ref ref, super.navigatorKey})
      : _authGuard = AuthGuard(ref);

  final AuthGuard _authGuard;

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(
      page: ClientShellRoute.page,
      children: <AutoRoute>[
        AutoRoute(page: ClientHomeRoute.page, initial: true),
        AutoRoute(page: ClientSearchRoute.page),
        AutoRoute(
          page: ClientAppointmentsRoute.page,
          guards: <AutoRouteGuard>[_authGuard],
        ),
      ],
    ),
    AutoRoute(page: AuthenticationRoute.page),
    // ...
  ];
}
```

### 12.2 Navigation

```dart
// Navigation declarative
context.router.push(const ClientAppointmentsRoute());
context.router.push(ClientArtisanProfileRoute(artisanId: artisan.id));

// Via NavigationService (prefere pour les actions cross-feature)
ref.read(navigationServiceProvider).navigateToArtisanProfile(artisan);
```

### 12.3 Ajout d'une nouvelle route

1. Creer le screen avec `@RoutePage()`.
2. Ajouter la route dans `AppRouter.routes`.
3. Lancer `dart run build_runner build --delete-conflicting-outputs`.
4. La route generee suit le pattern `XxxRoute` (le suffixe `Screen` est remplace par `Route`).

---

## 13. Generation de code

### 13.1 Commande unique

```bash
dart run build_runner build --delete-conflicting-outputs
```

Cette commande genere :
- `*.freezed.dart` — classes Freezed (entites, models, states, params)
- `*.g.dart` — JSON serialization, Retrofit endpoints, Riverpod providers
- `app_router.gr.dart` — routes AutoRoute
- `lib/gen/assets.gen.dart` — references type-safe aux assets

### 13.2 Fichiers generes — NE JAMAIS MODIFIER

Les fichiers suivants sont generes automatiquement. **Ne jamais les editer manuellement** :

- `*.freezed.dart`
- `*.g.dart`
- `*.gr.dart`
- `lib/gen/*.gen.dart`
- `lib/generated/locale_keys.g.dart`

---

## 14. Conventions de nommage

### 14.1 Fichiers

| Element | Pattern | Exemple |
|---------|---------|---------|
| Entite | `{nom}.entity.dart` | `appointment.entity.dart` |
| Param | `{nom}.param.dart` | `create_appointment.param.dart` |
| Repository interface | `{nom}.repository.dart` | `appointment.repository.dart` |
| Repository impl | `{nom}.repository.impl.dart` | `appointment.repository.impl.dart` |
| Remote Model | `{nom}.remote.model.dart` | `appointment.remote.model.dart` |
| Local Model | `{nom}.local.model.dart` | `appointment.local.model.dart` |
| Endpoint | `{nom}.endpoint.dart` | `appointment.endpoint.dart` |
| Remote DataSource (interface) | `{nom}.remote.data_source.dart` | `appointment.remote.data_source.dart` |
| Remote DataSource (impl) | `{nom}.remote.data_source.impl.dart` | `appointment.remote.data_source.impl.dart` |
| Local DataSource (interface) | `{nom}.local.data_source.dart` | `appointment.local.data_source.dart` |
| Local DataSource (impl) | `{nom}.local.data_source.impl.dart` | `appointment.local.data_source.impl.dart` |
| Mapper | `{nom}.mapper.dart` | `appointment.mapper.dart` |
| Use Case | `{action}_{nom}.use_case.dart` | `get_appointments.use_case.dart` |
| Provider | `{nom}.{type}.provider.dart` | `appointment.endpoint.provider.dart` |
| ViewModel | `{nom}.view_model.dart` | `client_appointments.view_model.dart` |
| State | `{nom}.state.dart` | `client_appointments.state.dart` |
| Screen | `{nom}.screen.dart` | `client_appointments.screen.dart` |
| Service | `{nom}_service.dart` | `appointment_service.dart` |

### 14.2 Classes

| Element | Pattern | Exemple |
|---------|---------|---------|
| Entite | `{Nom}Entity` | `AppointmentEntity` |
| Param | `{Nom}Param` | `CreateAppointmentParam` |
| Repository interface | `{Nom}Repository` | `AppointmentRepository` |
| Repository impl | `{Nom}RepositoryImpl` | `AppointmentRepositoryImpl` |
| Remote Model | `{Nom}RemoteModel` | `AppointmentRemoteModel` |
| Local Model | `{Nom}LocalModel` | `AppointmentLocalModel` |
| Endpoint | `{Nom}Endpoint` | `AppointmentEndpoint` |
| Remote DataSource | `{Nom}RemoteDataSource` | `AppointmentRemoteDataSource` |
| Remote DataSource impl | `{Nom}RemoteDataSourceImpl` | `AppointmentRemoteDataSourceImpl` |
| Use Case | `{Action}{Nom}UseCase` | `GetAppointmentsUseCase` |
| ViewModel | `{Nom}ViewModel` | `ClientAppointmentsViewModel` |
| State | `{Nom}State` | `ClientAppointmentsState` |
| Screen | `{Nom}Screen` | `ClientAppointmentsScreen` |
| Service | `{Nom}Service` | `AppointmentService` |
| Mapper (extension) | `{Nom}RemoteModelX` | `AppointmentRemoteModelX` |

### 14.3 Regles de style Dart

- **`always_specify_types`** — Toujours declarer les types explicitement.
- **`prefer_single_quotes`** — Guillemets simples partout.
- **`always_use_package_imports`** — Jamais d'imports relatifs.
- **`require_trailing_commas`** — Virgule apres le dernier parametre.
- **`public_member_api_docs`** — Documentation `///` sur toute API publique.
- **`final class`** pour les implementations concretes (use cases, repos impl, DS impl).
- **`abstract interface class`** pour les contrats (datasources, certains repositories).
- **`const` constructors** partout ou c'est possible.

---

## 15. Checklist : ajouter une nouvelle feature

> Ce processus doit etre suivi **dans cet ordre exact** pour chaque nouvelle fonctionnalite. Chaque etape produit des fichiers specifiques.

### Phase 1 : Domain (packages/core_domain)

- [ ] **1.1** Creer l'entite `packages/core_domain/lib/domain/entities/{nom}.entity.dart`
  - `@freezed abstract class {Nom}Entity`
  - Part `.freezed.dart`
  - Pas de `fromJson` (les entites ne connaissent pas le JSON)

- [ ] **1.2** Creer les params (si necessaire) `packages/core_domain/lib/domain/params/{nom}.param.dart`
  - `@Freezed() abstract class {Nom}Param`
  - Part `.freezed.dart` + `.g.dart`
  - Factory `fromJson`

- [ ] **1.3** Creer l'interface du repository `packages/core_domain/lib/domain/repositories/{nom}.repository.dart`
  - `abstract interface class {Nom}Repository`
  - Methodes retournant des **entites**, pas des models

- [ ] **1.4** Creer les use cases `packages/core_domain/lib/domain/usecases/{action}_{nom}.use_case.dart`
  - `final class extends FutureUseCase<T>` ou `FutureUseCaseWithParams<T, P>`
  - Implementer uniquement `invoke()`
  - Injection du repository par constructeur

### Phase 2 : Data (packages/core_data)

- [ ] **2.1** Creer le remote model `packages/core_data/lib/model/remote/{nom}.remote.model.dart`
  - `@freezed abstract class {Nom}RemoteModel`
  - Part `.freezed.dart` + `.g.dart`
  - Factory `fromJson`
  - `@JsonKey(name: 'xxx')` si les noms API different

- [ ] **2.2** Creer le mapper `packages/core_data/lib/mappers/{nom}.mapper.dart`
  - Extension `{Nom}RemoteModelX on {Nom}RemoteModel` avec `toEntity()`
  - Extension `{Nom}EntityToRemoteX on {Nom}Entity` avec `toRemoteModel()` (si ecriture)

- [ ] **2.3** Creer l'endpoint `packages/core_data/lib/endpoint/{nom}.endpoint.dart`
  - `@RestApi() abstract class {Nom}Endpoint`
  - Part `.g.dart`
  - Factory `{Nom}Endpoint(Dio dio) = _{Nom}Endpoint`
  - Methodes annotees `@GET`, `@POST`, `@PUT`, `@DELETE`

- [ ] **2.4** Creer l'interface datasource `packages/core_data/lib/datasources/remote/{nom}.remote.data_source.dart`
  - `abstract interface class {Nom}RemoteDataSource`

- [ ] **2.5** Creer l'implementation datasource `packages/core_data/lib/datasources/remote/impl/{nom}.remote.data_source.impl.dart`
  - `final class {Nom}RemoteDataSourceImpl implements {Nom}RemoteDataSource`
  - Injection de l'endpoint par constructeur
  - Delegation pure vers l'endpoint

- [ ] **2.6** Creer l'implementation repository `packages/core_data/lib/repositories/{nom}.repository.impl.dart`
  - `final class {Nom}RepositoryImpl implements {Nom}Repository`
  - Injection du datasource par constructeur
  - Mapping via les extensions mapper (`.toEntity()`, `.toRemoteModel()`)

### Phase 3 : Providers (apps/app_mobile/lib/core/providers)

- [ ] **3.1** Endpoint provider `lib/core/providers/data/endpoint/{nom}.endpoint.provider.dart`
  - `@riverpod Future<{Nom}Endpoint> {nom}Endpoint(Ref ref) async { ... }`

- [ ] **3.2** DataSource provider `lib/core/providers/data/datasource/{nom}.remote.data_source.provider.dart`
  - `@riverpod Future<{Nom}RemoteDataSource> {nom}RemoteDataSource(Ref ref) async { ... }`

- [ ] **3.3** Repository provider `lib/core/providers/core/repositories/{nom}.repository.provider.dart`
  - `@riverpod Future<{Nom}Repository> {nom}Repository(Ref ref) async { ... }`

- [ ] **3.4** UseCase provider(s) `lib/core/providers/core/usecases/{action}_{nom}.use_case.provider.dart`
  - `@riverpod Future<{Action}{Nom}UseCase> {action}{Nom}UseCase(Ref ref) async { ... }`

- [ ] **3.5** Service provider (si necessaire) `lib/core/providers/services/{nom}.service.provider.dart`

### Phase 4 : Presentation (apps/app_mobile/lib/features)

- [ ] **4.1** Creer le dossier `lib/features/{domaine}/presentation/screens/{nom_ecran}/`

- [ ] **4.2** Creer le state `{nom_ecran}.state.dart`
  - `@Freezed(copyWith: true) abstract class {Nom}State`
  - Factory `.initial()`
  - Part `.freezed.dart`

- [ ] **4.3** Creer le view model `{nom_ecran}.view_model.dart`
  - `@riverpod class {Nom}ViewModel extends _${Nom}ViewModel`
  - `build()` retourne `Future<{Nom}State>` ou `{Nom}State`
  - Part `.g.dart`

- [ ] **4.4** Creer le screen `{nom_ecran}.screen.dart`
  - `@RoutePage() class {Nom}Screen extends ConsumerStatefulWidget`
  - `asyncState.when(loading:, error:, data:)` si VM async
  - Textes via `LocaleKeys.xxx.tr()`
  - Couleurs via `Theme.of(context).colorScheme`

- [ ] **4.5** Ajouter les traductions dans `assets/translations/fr.json`
  - Regenerer les LocaleKeys

- [ ] **4.6** Ajouter la route dans `AppRouter`
  - Regenerer le router

### Phase 5 : Generation et verification

- [ ] **5.1** Lancer `dart run build_runner build --delete-conflicting-outputs`
- [ ] **5.2** Lancer `dart run easy_localization:generate -S assets/translations -f keys -O lib/generated -o locale_keys.g.dart`
- [ ] **5.3** Verifier les lints : `dart analyze`
- [ ] **5.4** Verifier que les imports sont en `package:` (pas de relatifs)
- [ ] **5.5** Verifier que tous les membres publics ont une doc `///`
- [ ] **5.6** Verifier qu'aucune string n'est en dur dans les screens

---

## 16. Erreurs frequentes a eviter

### INTERDIT — Violations architecturales

```dart
// INTERDIT : Import d'un model data dans le domain
import 'package:core_data/model/remote/appointment.remote.model.dart';
// Dans un fichier de core_domain → violation de la dependance

// INTERDIT : Logique metier dans le screen
class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final double total = items.fold(0, (a, b) => a + b.price * b.qty); // INTERDIT
  }
}

// INTERDIT : Appel HTTP direct dans le ViewModel
Future<void> loadData() async {
  final response = await Dio().get('/api/data'); // INTERDIT
}

// INTERDIT : String en dur
Text('Bonjour')                    // INTERDIT → Text(LocaleKeys.greeting.tr())
Text('Erreur: $message')           // INTERDIT → Text(LocaleKeys.error_with_message.tr(args: [message]))

// INTERDIT : Couleur en dur
Container(color: Colors.blue)       // INTERDIT → Container(color: colorScheme.primary)
TextStyle(color: Color(0xFF123456)) // INTERDIT → TextStyle(color: colorScheme.onSurface)

// INTERDIT : Asset path en dur
Image.asset('assets/images/logo.png')  // INTERDIT → Image.asset(Assets.images.logo.path)

// INTERDIT : Modifier un fichier genere
// Tout fichier .g.dart, .freezed.dart, .gr.dart → JAMAIS modifier

// INTERDIT : Import relatif
import '../../../core/providers/xxx.dart';  // INTERDIT
import 'package:iciartisan/core/providers/xxx.dart';  // CORRECT

// INTERDIT : Variable mutable dans un state
@freezed
abstract class MyState with _$MyState {
  const factory MyState({
    required List<String> items,  // OK
  }) = _MyState;
}
// Puis : state.items.add('new'); ← INTERDIT. Utiliser copyWith.

// INTERDIT : ref.read dans build()
@override
Future<MyState> build() async {
  final service = ref.read(myServiceProvider); // INTERDIT → ref.watch
}

// INTERDIT : Surcharger execute() dans un use case
class MyUseCase extends FutureUseCase<String> {
  @override
  Future<ResultState<String>> execute() async { ... } // INTERDIT
  // Implementer invoke() uniquement
}

// INTERDIT : SizedBox pour l'espacement
SizedBox(height: 16)  // INTERDIT → Gap(16)
```

### RECOMMANDE — Bonnes pratiques

```dart
// CORRECT : Types explicites partout
final List<AppointmentEntity> appointments = <AppointmentEntity>[];
final AsyncValue<ClientHomeState> state = ref.watch(viewModelProvider);

// CORRECT : Const constructors
const ClientHomeScreen({super.key});
const EdgeInsets.all(16);
const <Widget>[];

// CORRECT : Trailing commas
const ClientHomeState(
  searchQuery: '',
  appointments: <AppointmentEntity>[],
);

// CORRECT : Documentation
/// Recupere les rendez-vous de l'artisan connecte.
Future<List<AppointmentEntity>> getArtisanAppointments();

// CORRECT : Logging structure
final Log _log = Log.named('AppointmentService');
_log.info('Loading appointments for artisan: $artisanId');

// CORRECT : Guard pour les operations async dans un ViewModel
Future<void> refresh() async {
  state = const AsyncLoading<MyState>();
  state = await AsyncValue.guard<MyState>(() => _fetch());
}
```

---

## 17. Exemples de reference complets

### 17.1 Exemple complet : Feature "Appointments"

#### Flux de fichiers (dans l'ordre de creation) :

```
packages/core_domain/lib/domain/
├── entities/appointment.entity.dart                          ← Entite
├── params/create_appointment.param.dart                      ← Params
├── enum/appointment_status.enum.dart                         ← Enum
├── repositories/appointment.repository.dart                  ← Interface repo
└── usecases/
    ├── get_appointments.use_case.dart                        ← Use case lecture
    ├── create_appointment.use_case.dart                      ← Use case ecriture
    ├── update_appointment.use_case.dart
    └── delete_appointment.use_case.dart

packages/core_data/lib/
├── model/remote/appointment.remote.model.dart                ← Model API
├── mappers/appointment.mapper.dart                           ← Mapper
├── endpoint/appointment.endpoint.dart                        ← Endpoint Retrofit
├── datasources/
│   ├── remote/appointment.remote.data_source.dart            ← Interface DS
│   └── remote/impl/appointment.remote.data_source.impl.dart ← Impl DS
└── repositories/appointment.repository.impl.dart             ← Impl repo

apps/app_mobile/lib/core/providers/
├── data/endpoint/appointment.endpoint.provider.dart
├── data/datasource/appointment.remote.data_source.provider.dart
├── core/repositories/appointment.repository.provider.dart
├── core/usecases/get_appointments.use_case.provider.dart
├── core/usecases/create_appointment.use_case.provider.dart
└── services/appointment.service.provider.dart

apps/app_mobile/lib/features/client/presentation/screens/appointments/
├── client_appointments.state.dart                            ← State
├── client_appointments.view_model.dart                       ← ViewModel
└── client_appointments.screen.dart                           ← Screen

assets/translations/fr.json  ← Cles ajoutees
```

### 17.2 Template de creation rapide — Use Case

```dart
// 1. Creer le use case
// fichier : packages/core_domain/lib/domain/usecases/{action}_{nom}.use_case.dart

import 'package:core_domain/domain/repositories/{nom}.repository.dart';
import 'package:core_foundation/interfaces/future.usecases.dart';

/// {Description du use case}.
final class {Action}{Nom}UseCase extends FutureUseCase<{TypeRetour}> {
  /// Cree une instance de [{Action}{Nom}UseCase].
  {Action}{Nom}UseCase({
    required {Nom}Repository {nom}Repository,
  }) : _{nom}Repository = {nom}Repository;

  final {Nom}Repository _{nom}Repository;

  @override
  Future<{TypeRetour}> invoke() {
    return _{nom}Repository.{methode}();
  }
}

// 2. Creer le provider
// fichier : lib/core/providers/core/usecases/{action}_{nom}.use_case.provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{action}_{nom}.use_case.provider.g.dart';

/// Provider pour [{Action}{Nom}UseCase].
@riverpod
Future<{Action}{Nom}UseCase> {action}{Nom}UseCase(Ref ref) async {
  final {Nom}Repository repository =
      await ref.watch({nom}RepositoryProvider.future);
  return {Action}{Nom}UseCase({nom}Repository: repository);
}
```

### 17.3 Template de creation rapide — Ecran

```dart
// === STATE ===
// fichier : lib/features/{domaine}/presentation/screens/{nom}/{nom}.state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part '{nom}.state.freezed.dart';

/// Etat de l'ecran {NomEcran}.
@Freezed(copyWith: true)
abstract class {Nom}State with _${Nom}State {
  /// Cree une instance de [{Nom}State].
  const factory {Nom}State({
    // Definir les champs de l'etat ici
    @Default(false) bool isLoading,
  }) = _{Nom}State;

  /// Etat initial.
  factory {Nom}State.initial() => const {Nom}State();
}

// === VIEW MODEL ===
// fichier : lib/features/{domaine}/presentation/screens/{nom}/{nom}.view_model.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{nom}.view_model.g.dart';

/// ViewModel de l'ecran {NomEcran}.
@riverpod
class {Nom}ViewModel extends _${Nom}ViewModel {
  @override
  Future<{Nom}State> build() async {
    // Resoudre les dependances
    // Charger les donnees initiales
    return {Nom}State.initial();
  }
}

// === SCREEN ===
// fichier : lib/features/{domaine}/presentation/screens/{nom}/{nom}.screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ecran {NomEcran}.
@RoutePage()
class {Nom}Screen extends ConsumerStatefulWidget {
  /// Cree une instance de [{Nom}Screen].
  const {Nom}Screen({super.key});

  @override
  ConsumerState<{Nom}Screen> createState() => _{Nom}ScreenState();
}

class _{Nom}ScreenState extends ConsumerState<{Nom}Screen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<{Nom}State> asyncState =
        ref.watch({nom}ViewModelProvider);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.{section}_{nom}_title.tr()),
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stack) => Center(
          child: Text(LocaleKeys.common_error_generic.tr()),
        ),
        data: ({Nom}State state) => _buildContent(state, colorScheme),
      ),
    );
  }

  Widget _buildContent({Nom}State state, ColorScheme colorScheme) {
    return const Placeholder(); // Construire l'UI ici
  }
}
```

---

## Annexe A : Arbre de decision

### Ou placer mon code ?

```
Est-ce une structure de donnees immutable ?
├── Represente un concept metier ? → Entity (core_domain/entities/)
├── Represente un payload API ?    → RemoteModel (core_data/model/remote/)
├── Represente du stockage local ? → LocalModel (core_data/model/local/)
├── Represente un etat d'ecran ?   → State (features/{feature}/presentation/screens/{ecran}/)
└── Represente des parametres ?    → Param (core_domain/params/)

Est-ce de la logique ?
├── Une seule operation metier ?   → UseCase (core_domain/usecases/)
├── Orchestration multi-use-case ? → Service (core_domain/services/ ou app_mobile/application/services/)
├── Appel HTTP ?                   → Endpoint (core_data/endpoint/) + DataSource (core_data/datasources/)
├── Logique de presentation ?      → ViewModel (features/{feature}/presentation/screens/{ecran}/)
└── Mapping model ↔ entite ?      → Mapper (core_data/mappers/)

Est-ce un contrat (interface) ?
├── Source de donnees ?            → DataSource interface (core_data/datasources/)
├── Acces metier ?                 → Repository interface (core_domain/repositories/)
└── Service UI ?                   → ServiceContract (core_presentation/services/)

Est-ce de l'UI ?
├── Specifique a un ecran ?        → Widget dans features/{feature}/presentation/screens/{ecran}/widgets/
├── Partage cross-feature ?        → Widget dans features/shared/presentation/widgets/
└── Ecran complet ?                → Screen dans features/{feature}/presentation/screens/{ecran}/
```

### Quel provider utiliser ?

```
La dependance doit-elle vivre toute la duree de l'app ?
├── Oui → @Riverpod(keepAlive: true)  [DioClient, Router, UserService, Kernel]
└── Non → @riverpod                    [Tout le reste]

Le provider retourne-t-il un Future ?
├── Oui → Future<Type> {nom}(Ref ref) async { ... }
└── Non → Type {nom}(Ref ref) { ... }

C'est un ViewModel ?
├── Oui → @riverpod class XxxViewModel extends _$XxxViewModel { ... }
└── Non → @riverpod function top-level
```

---

## Annexe B : Commandes utiles

```bash
# Generation de code (Freezed, Retrofit, Riverpod, AutoRoute, flutter_gen)
dart run build_runner build --delete-conflicting-outputs

# Generation des LocaleKeys
dart run easy_localization:generate -S assets/translations -f keys -O lib/generated -o locale_keys.g.dart

# Analyse statique
dart analyze

# Build runner en mode watch (dev)
dart run build_runner watch --delete-conflicting-outputs

# Nettoyage des fichiers generes
dart run build_runner clean
```

---

## Annexe C : Diagramme de dependance des providers

```
                    ┌──────────────┐
                    │ appConfigProv│ (keepAlive)
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │ dioClientProv│ (keepAlive)
                    └──────┬───────┘
                           │
              ┌────────────▼────────────┐
              │   xxxEndpointProvider    │
              └────────────┬────────────┘
                           │
         ┌─────────────────▼──────────────────┐
         │   xxxRemoteDataSourceProvider       │
         └─────────────────┬──────────────────┘
                           │
              ┌────────────▼────────────┐
              │  xxxRepositoryProvider   │
              └────────────┬────────────┘
                           │
              ┌────────────▼────────────┐
              │   xxxUseCaseProvider     │
              └────────────┬────────────┘
                           │
         ┌─────────────────▼──────────────────┐
         │   xxxServiceProvider (si besoin)    │
         └─────────────────┬──────────────────┘
                           │
              ┌────────────▼────────────┐
              │  xxxViewModelProvider    │ (auto-dispose)
              └─────────────────────────┘
```
