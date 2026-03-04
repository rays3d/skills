---
id: skill_flutter_provider_scaffold
name: Flutter Provider Scaffold
version: 1.0.0
description: Scaffolds Riverpod providers with Freezed state classes matching the project's layer conventions.
tags: [flutter, riverpod, state, freezed, frontend]
permissions: [read_file, write_file, execute_terminal]
---

# Flutter Provider Scaffold

## Overview

Generates robust Riverpod 3.0 Notifiers connected to Freezed-backed State classes. This strictly follows `medisphere-frontend`'s presentation layer patterns.

Each generated state block requires a `_provider.dart`, `_state.dart`, and automatically runs the `build_runner` to produce `_state.freezed.dart` and `_provider.g.dart`.

## Capabilities

### Scaffold Riverpod Provider

**Trigger:** `/provider <FeatureName>`
**Prerequisites:** The feature folder (e.g., `lib/features/patient`) must exist.

**Actions:**
1. Generates `lib/features/<feature_name>/presentation/providers/<feature_name>_state.dart`.
2. Generates `lib/features/<feature_name>/presentation/providers/<feature_name>_provider.dart`.
3. Notifies the user to run `dart run build_runner build -d` (or relies on `build-runner-sentinel` if active).

## Reference Templates

### State Class (`<feature>_state.dart`)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

// Replace with actual models
// import 'package:medispherexr/features/{{feature}}/imports.dart';

part '{{feature}}_state.freezed.dart';

@freezed
class {{FeatureName}}State with _${{FeatureName}}State {
  const factory {{FeatureName}}State.initial() = _Initial;
  const factory {{FeatureName}}State.loading() = _Loading;
  const factory {{FeatureName}}State.loaded(
      // List<{{ModelName}}> items,
  ) = _Loaded;
  const factory {{FeatureName}}State.error(String message) = _Error;
}
```

### Provider Class (`<feature>_provider.dart`)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '{{feature}}_state.dart';

// Inject necessary repositories/services
// import 'package:medispherexr/features/{{feature}}/imports.dart';

part '{{feature}}_provider.g.dart';

@riverpod
class {{FeatureName}}Notifier extends _${{FeatureName}}Notifier {
  @override
  {{FeatureName}}State build() {
    return const {{FeatureName}}State.initial();
  }

  Future<void> loadData() async {
    state = const {{FeatureName}}State.loading();
    try {
      // final repo = ref.read({{feature}}RepositoryProvider);
      // final data = await repo.fetchSomething();

      // state = {{FeatureName}}State.loaded(data);
    } catch (e) {
      state = {{FeatureName}}State.error(e.toString());
    }
  }
}
```
