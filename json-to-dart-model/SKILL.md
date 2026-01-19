---
name: json-to-dart-model
description: Converts JSON data snippets into Flutter/Dart data models with JsonSerializable support.
---

# JSON to Dart Model Skill

This skill converts raw JSON data or API responses into structured, type-safe Dart classes compatible with the `json_serializable` and `provider` ecosystem.

## Instructions

1. **Analyze the Input**: Examine the JSON object provided.
2. **Map Types to Dart**:
   - `string` -> `String`
   - `number (integer)` -> `int`
   - `number (decimal)` -> `double`
   - `boolean` -> `bool`
   - `array` -> `List<Type>`
   - `null` -> `Type?` (Nullable)
   - Nested Objects -> Create separate classes.

3. **Structure the Output**:
   - Create a separate class for each nested object.
   - Use `@JsonSerializable(fieldRename: FieldRename.snake)` to handle Laravel backend responses automatically.
   - Include `factory Class.fromJson` and `Map<String, dynamic> toJson()` boilerplate.
   - Always include the `part 'filename.g.dart';` directive.

## Style Guidelines

- **Windows Environment**: Assume the user will run `dart run build_runner build` in PowerShell 7.
- **Immutability**: Use `final` for all fields (Provider compatibility).
- **Organization**: Follow Feature-First Layered Architecture (Models go in `data/models`).
