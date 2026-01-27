---
id: skill_flutter_router_medisphere
name: Medisphere Router Manager
version: 2.0.0
description: Manages the GoRouter configuration for Medisphere. Automates adding routes across `route_names.dart`, `app_router.dart`, and `auth_guard.dart` to enforce security and naming conventions.
tags: [flutter, go_router, navigation, architecture]
permissions: [read_file, write_file, analyze_code]
---

# Medisphere Router Manager

## Overview
This skill acts as the gatekeeper for the `lib/core/routes/` directory. It ensures that every new route is strictly typed (via constants), properly nested, and secured with the correct `AuthGuard` rules.

## Rules Engine

### 1. The "Three-File" Protocol
Every new route must be registered in three places simultaneously to avoid magic strings:
1.  **`RoutePath`**: The URL segment (e.g., `'details/:id'`).
2.  **`RouteName`**: The specific key for navigation (e.g., `'patientDetails'`).
3.  **`AppRouter`**: The actual `GoRoute` definition.

### 2. Relative Path Enforcement
* **Root Routes:** Must start with `/` (e.g., `/dashboard`).
* **Nested Routes:** Must **NOT** start with `/`. The skill will strip leading slashes from children.

### 3. Security Context
* **Public:** Added to `_authRoutes` or explicitly whitelisted in `AuthGuard`.
* **Protected:** Default. Added to `_dashboardRoutes` or `_workspaceRoutes`.
* **Admin:** Added to `_adminRoutes` and flagged for role checks.

## Prompts

### `add_route`
**Trigger:** `/route add <name> <path> [parent]`
**Example:** `/route add patient_details :id dashboard`

**Action Chain:**

**Step 1: Update `lib/core/routes/route_names.dart`**
* Appends `static const {{name}}Path = '{{path}}';` to `RoutePath`.
* Appends `static const {{name}} = '{{name}}';` to `RouteName`.
* *Validation:* Checks for duplicate names or paths.

**Step 2: Generate `GoRoute` Code**
* Generates the widget import statement.
* Creates the `GoRoute` block:
    ```dart
    GoRoute(
      path: RoutePath.{{name}}Path,
      name: RouteName.{{name}},
      builder: (context, state) {
        // Auto-extract params if path contains ':'
        final id = state.pathParameters['id']!;
        return {{PageWidget}}(id: id);
      },
    ),
    ```

**Step 3: Insert into `lib/core/routes/app_router.dart`**
* Locates the parent route's `routes: []` list (e.g., finding the `GoRoute` named `RouteName.dashboard`).
* Injects the new code block into the list.

### `audit_router`
**Trigger:** `/route audit` or File Save on `app_router.dart`.
**Logic:**
1.  **Orphan Check:** Are there routes defined in `AppRouter` that use raw strings instead of `RouteName` constants?
2.  **Guard Check:** Is there a new route in `_adminRoutes` that isn't covered by `AuthGuard` logic?
3.  **Web Optimization:** Checks if `pageBuilder` is used with transitions instead of `builder` (warns about performance on Web).

## Usage Examples

**1. Create a simple sub-page:**
User: "Add a 'Settings' page under Dashboard."
Skill:
1.  Adds `settings = 'settings'` to `RoutePath` / `RouteName`.
2.  Injects `GoRoute` into the `_dashboardRoutes` list in `AppRouter`.

**2. Create a secure Workspace sub-page:**
User: "Add 'Edit Workspace' under Workspace Details with ID param."
Skill:
1.  Adds `editWorkspaceRelative = 'edit'` to `RoutePath`.
2.  Adds `editWorkspace = 'editWorkspace'` to `RouteName`.
3.  Injects into `AppRouter` as a child of `workspaceIDRelative`:
    ```dart
    GoRoute(
      path: RoutePath.editWorkspaceRelative,
      name: RouteName.editWorkspace,
      builder: (context, state) => EditWorkspacePage(),
    )
    ```

## Template: New Route Block
```dart
GoRoute(
  path: RoutePath.{{variableName}}Path, // e.g. myPatientsRelative
  name: RouteName.{{variableName}},     // e.g. myPatients
  builder: (context, state) {
    {{param_extraction}}
    return const {{PageName}}({{params}});
  },
)