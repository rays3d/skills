---
name: laravel-to-flutter-bridge
description: Translates Laravel Eloquent Resources and Enums into Flutter Dart Models and Providers.
---

# Laravel to Flutter Bridge Skill

This skill automates the creation of Flutter data structures based on Laravel backend definitions, following the "Feature-First" architecture.

## Instructions

1. **Analyze Laravel Input**: Identify the fields in the `toArray()` method of a Laravel Resource or the `$fillable` array in a Model.
2. **Handle Laravel Enums**: If a Laravel field uses a PHP Enum, create a matching `enum` in Dart.
3. **Map Logic**:
    - **Laravel ID** (`bigIncrements`) -> Dart `int`.
    - **Timestamps** -> Dart `DateTime`.
    - **Relationships** -> Map to nested Dart objects or `List<T>`.
    - **API Response Wrapper**: Wrap the result in a `Data` property if using Laravel's default resource wrapping.

## Output Requirements

### A. The Data Model (`lib/features/X/data/models/`)

- Use `@JsonSerializable(fieldRename: FieldRename.snake)` to automatically handle Laravel's `snake_case` to Dart's `camelCase`.
- Include `factory` constructors for JSON conversion.

### B. The Provider (`lib/features/X/presentation/providers/`)

- Create a `ChangeNotifier` class.
- Include a `loading` state, an `errorMessage` string, and the data object.
- Use `Dio` or `http` to fetch from the Laravel API endpoint.

## Style Guidelines

- **Paths**: Use project-relative paths (e.g., `lib/features/auth/...`).
- **Safety**: All fields from Laravel must be nullable (`?`) unless they are strictly required in the database schema.
