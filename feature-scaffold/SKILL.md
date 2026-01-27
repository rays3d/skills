---
name: feature-scaffold
description: Generates the directory structure and boilerplate files for a new Flutter feature using Clean Architecture. Trigger this when the user says "create a new feature" or "scaffold X".
---

# Feature Scaffolding Skill

## Goal
Create a standardized folder structure for a new feature to ensure separation of concerns.

## Instructions
1.  **Identify Feature Name**: Extract the feature name from the prompt (e.g., "Login", "Profile"). Snake_case it (e.g., `user_profile`).
2.  **Create Directories**:
    * `lib/features/<name>/data/datasources`
    * `lib/features/<name>/data/repositories`
    * `lib/features/<name>/domain/entities`
    * `lib/features/<name>/domain/repositories`
    * `lib/features/<name>/presentation/bloc` (or `providers`)
    * `lib/features/<name>/presentation/pages`
    * `lib/features/<name>/presentation/widgets`
3.  **Generate Files**:
    * Create a clean Dart file in each directory.
    * **Domain Entity**: Must be a pure Dart class with `equatable`.
    * **Repository Interface**: Abstract class in `domain/repositories`.
    * **Implementation**: Concrete class in `data/repositories` implementing the domain interface.
4.  **Barrel Files**: Create a `path.dart` export file for the feature if the project uses them.

## Example
User: "Create a chat feature."
Action: Agent creates `lib/features/chat/...` following the structure above.