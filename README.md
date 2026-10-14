# Ant Budget

An AI-powered personal finance app built with Flutter. Track expenses and budgets,
and scan receipts into transactions using **on-device** ML Kit text recognition —
no receipt image ever leaves the device.

## Features

- **Dashboard** — monthly income/expense summary and budget progress at a glance.
- **Transactions** — browse by month, filter, add, and delete.
- **Budgets** — set a monthly limit per category and watch spending against it.
- **Receipt scanning** — photograph a receipt; the OCR text is parsed into
  merchant, amount, and date, then presented for review before saving.

## Architecture

The project follows Clean Architecture with strict, one-way dependencies:
**Presentation → Domain ← Data**. The domain layer is pure Dart with zero
framework dependencies.

```
lib/
├── main.dart                     # Entry point: ProviderScope(overrides: appProviderOverrides)
├── app/                          # Composition root + shell
│   ├── app.dart                  # Root MaterialApp.router
│   ├── app_composition.dart      # appProviderOverrides (wires concrete adapters/seeders)
│   ├── router/                   # go_router config + route names
│   └── shell/app_shell.dart      # Bottom-nav shell for the three tabs
├── core/                         # Shared, feature-agnostic building blocks
│   ├── error/                    # Result/Ok/Err, sealed Failure, FailureMapper
│   ├── values/                   # Money, Currency, YearMonth, enums
│   ├── data/database/            # Drift schema + tables + seeder port
│   ├── providers/                # appDatabaseProvider / databaseSeedersProvider
│   ├── theme/ · utils/ · widgets/ · config/
└── features/
    ├── dashboard/                # Read-only monthly overview
    ├── transactions/             # domain/ · data/ · presentation/
    ├── categories/
    ├── budget/
    └── receipt_scan/             # domain/parsing strategies + ML Kit/camera adapters
```

Each feature is split into:

- **`domain/`** — entities, value objects, repository *interfaces*, and use cases.
  No Flutter, no Drift, no plugins.
- **`data/`** — repository implementations, DAOs/data sources, DTO mappers, and
  adapters for external services (Drift, ML Kit, camera).
- **`presentation/`** — Riverpod providers/notifiers, screens, and widgets. No
  business logic; it only orchestrates use cases.

### Key design decisions

| Concern | Choice | Why |
| --- | --- | --- |
| Error handling | Custom sealed `Result<S, F extends Failure>` | Exhaustive, dependency-free, removes nested `try`/`catch` |
| Failures | Sealed `Failure` hierarchy + `FailureMapper` | One place turns driver exceptions into typed domain failures |
| State | Riverpod 3 codegen (auto-dispose) | Compile-safe DI, reactive, testable overrides |
| Persistence | Drift (SQLite) + `drift_flutter` | Reactive stream queries, migrations, type-safe SQL |
| OCR | Strategy pipeline (`ReceiptParserPipeline`) | Add a new field parser without touching existing ones (OCP) |
| Camera | `CameraService` port + adapter | Presentation never imports the `camera` plugin |
| Money | Integer **minor units** | Avoids floating-point rounding errors |

**Result over exceptions.** Data sources throw; repositories catch and map to a
typed `Failure` (e.g. `DatabaseFailure`, `OcrFailure`, `CameraFailure`).
Presentation renders failures via `FailureView`, so a failed state is just
another branch of the UI.

**Composition root.** `core/` never imports a feature. `appDatabaseProvider`
reads seeders from a `databaseSeedersProvider` seam that
`lib/app/app_composition.dart` overrides with the concrete `DefaultCategorySeeder`.
The same `appProviderOverrides` list is reused in tests.

## Getting started

### Prerequisites

- Flutter stable (with Dart `^3.11.0`), e.g. Flutter 3.3x+.
- An Android emulator/device or iOS simulator/device for the OCR + camera paths.

```bash
flutter pub get

# Generate Riverpod providers, go_router, and Drift code.
dart run build_runner build
```

### Run

```bash
flutter run
```

### Quality gates

```bash
flutter analyze
flutter test
```

### Regenerating code

After changing an annotated provider, a route, or a Drift table, re-run:

```bash
dart run build_runner build
```

## Platform setup

Receipt scanning needs camera access, already declared for both platforms:

- **Android** (`android/app/src/main/AndroidManifest.xml`): `CAMERA` permission,
  optional `camera` features, and the ML Kit `ocr` dependency metadata.
- **iOS** (`ios/Runner/Info.plist`): `NSCameraUsageDescription`.

## Testing

Tests live under `test/` and mirror `lib/`. Unit tests cover value objects,
parsers, the receipt pipeline, and use cases; a widget test boots the app against
an in-memory Drift database and asserts the shell renders.

```bash
flutter test
```

> Drift keeps its query cache for one event-loop turn after a stream is cancelled,
> so the widget test disposes the tree inside the test and elapses the fake clock
> before closing the database. This avoids `flutter_test`'s "pending timer"
> assertion (the `drift` source points this out explicitly).

## Tech stack

- **Flutter** / Dart, sound null safety
- **Riverpod 3** (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`)
- **Drift** (SQLite) + `drift_flutter`
- **go_router**
- **google_mlkit_text_recognition** + **camera** + **permission_handler**
- **equatable**, **meta**
