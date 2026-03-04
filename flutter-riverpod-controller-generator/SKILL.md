---
id: skill_flutter_riverpod_controller_gen
name: Flutter Riverpod Controller Generator
version: 1.0.0
description: Scaffolds Riverpod 3.0 Notifier/AsyncNotifier controllers dedicated strictly to business logic and decoupled from UI.
tags: [flutter, riverpod, architecture, frontend]
permissions: [write_code]
---

# Flutter Riverpod Controller Generator

## Overview
Generates `@riverpod` annotated controller classes (Notifiers/AsyncNotifiers) to encapsulate feature business logic securely away from the frontend UI widgets.

## Rules Engine

### 1. The `@riverpod` Annotation
* **Required:** Must use the code-generation `@riverpod` annotation from `riverpod_annotation`.
* Ensure that the `part 'feature_name.g.dart';` statement is included at the top.

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medispherexr/features/some_feature/imports.dart';

part 'payment_controller.g.dart';
```

### 2. State Mapping
* **Required:** Logic must update a Freezed state class. The controller must extend `_$ClassName` and override the `build()` method to return the initial state.

```dart
@riverpod
class PaymentController extends _$PaymentController {
  @override
  PaymentState build() {
    return const PaymentState.initial();
  }
}
```

### 3. Full Decoupling
* **Forbidden:** Do not pass `BuildContext`, UI-specific types, or widget references into the controller's methods. The controller manages state purely.
* If a navigation route needs to happen post-action, the widget can listen to changes via `ref.listen` or the controller can return a generic success/failure boolean or enum type back to the widget.

### 4. Repositories and Services
* Methods should use `ref.read(repositoryProvider)` internally to interact with the backend API or data layer.
* Always wrap async operations in a `try/catch` and update the state to loading/error/loaded.

```dart
Future<void> submitPayment(double amount) async {
  state = const PaymentState.loading();
  try {
    final repo = ref.read(paymentRepositoryProvider);
    final result = await repo.processPayment(amount);
    state = PaymentState.loaded(result);
  } catch (e) {
    state = PaymentState.error(e.toString());
  }
}
```

## Trigger
> "Create a controller for ...", "Scaffold logic for ...", "Generate riverpod notifier"
