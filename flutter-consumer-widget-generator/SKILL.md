---
id: skill_flutter_consumer_widget_gen
name: Flutter Consumer Widget Generator
version: 1.0.0
description: Scaffolds UI components enforcing Riverpod 3.0 rules, forbidding StatelessWidget if watching state, and maximizing widget extraction.
tags: [flutter, widget, riverpod, frontend]
permissions: [write_code]
---

# Flutter Consumer Widget Generator

## Overview
Generates strict `ConsumerWidget` or `ConsumerStatefulWidget` classes for the Medisphere frontend, adhering to the project's state management guidelines.

## Rules Engine

### 1. State Consumption
* **Forbidden:** Using standard `StatelessWidget` or `StatefulWidget` if the widget needs to watch Riverpod state.
* **Required:** Always use `ConsumerWidget` or `ConsumerStatefulWidget`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeatureWidget extends ConsumerWidget {
  const FeatureWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ...
  }
}
```

### 2. Provider Usage
* **Observing Data (`build` method):** Always use `ref.watch(providerName)` to listen for reactivity.
* **Callback Execution (events/handlers):** Always use `ref.read(providerName.notifier).methodName()` inside click handlers. Never `watch` inside a callback.

```dart
final state = ref.watch(userProvider);
// ...
ElevatedButton(
  onPressed: () => ref.read(userProvider.notifier).fetchUsers(),
  child: const Text('Refresh'),
)
```

### 3. Modularity
* **Forbidden:** Creating UI helper methods like `Widget _buildHeader()` or `List<Widget> _buildListItems()`. This causes unnecessary full-page rebuilds.
* **Required:** Extract large chunks of UI into standalone private or public classes (e.g., `class _Header extends ConsumerWidget`).

### 4. Boilerplate
* Always import `flutter_riverpod`.
* Avoid putting business logic into the widget's variables or init method; that goes into the Notifier.

## Trigger
> "Create a consumer widget for ...", "Scaffold widget ...", "Refactor UI into independent widgets"
