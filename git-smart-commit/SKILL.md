---
id: skill_git_smart_commit
name: Git Smart Committer
version: 2.1.0
description: Intelligent git assistant that analyzes staged changes (diffs) to generate semantic, Conventional Commit messages automatically. Optimized for Flutter/Laravel monorepos.
tags: [git, automation, conventional-commits, version-control]
permissions: [read_file_diff, execute_terminal]
---

# Git Smart Committer

## Overview
This skill acts as your Release Manager. It doesn't just "save" code; it ensures your project history is a clean, readable change log. It understands the context of your tech stack (Flutter Widgets vs. Laravel Services) to categorize changes accurately.

## Triggers
* **Phrases:** "Commit this", "Save progress", "Push updates", "Checkpoint".
* **Context:** User has finished a logical unit of work (e.g., after `json-to-dart` generation or `router` update).

## Rules Engine: Conventional Commits 1.0.0

### 1. Type Detection Strategy
The skill analyzes the file extensions and content of `git diff --staged` to select the type:

| Type       | Condition (Regex/Logic)                                                  | Example                                       |
| :--------- | :----------------------------------------------------------------------- | :-------------------------------------------- |
| `feat`     | New files in `lib/features`, `app/Services`, or new logical blocks.      | `feat(auth): add login controller`            |
| `fix`      | Logic corrections, `bugfix` branches, re-enabling code.                  | `fix(api): resolve null check on user id`     |
| `ui`       | Changes in `build()` methods, CSS, or `assets/` only.                    | `ui(home): adjust padding on header card`     |
| `refactor` | Moving files, renaming variables, extracting widgets/methods.            | `refactor(core): extract safe_date_converter` |
| `perf`     | `const` additions, `RepaintBoundary`, Eloquent eager loading (`with()`). | `perf(list): optimize scroll rendering`       |
| `test`     | Changes in `test/` (Flutter) or `tests/` (Laravel).                      | `test(unit): add product service coverage`    |
| `chore`    | `pubspec.yaml`, `composer.json`, `.gitignore`, `readme.md`.              | `chore(deps): bump flutter_bloc to 8.0`       |

### 2. Scope Inference
The skill parses the file path to determine the scope automatically.
* **Flutter:** `lib/features/<scope>/...` -> `feat(<scope>)`
* **Laravel:** `app/Http/Controllers/<Scope>Controller.php` -> `fix(<scope-controller>)`
* **Core:** `lib/core/routes/` -> `feat(router)`

## Prompts & Execution Flow

### `smart_commit`
**Trigger:** `/commit [optional_message_hint]`
**Logic:**
1.  **Stage:** Check if anything is staged. If not, run `git add .` (or ask user).
2.  **Analyze:** Run `git diff --cached --name-only` and `git diff --cached`.
3.  **Draft:** Generate the message.
4.  **Confirm:** Present the message to the user for approval/editing.
5.  **Execute:** Run `git commit -m "..."`.

**Example Session:**
* **User:** "/commit fixed the login crash"
* **Antigravity Analysis:** Saw changes in `auth_repository.dart` handling a null token.
* **Generated Message:** `fix(auth): handle null token response to prevent crash`
* **Action:** Commits automatically if confidence is high, or asks for confirmation.

## PowerShell 7 Compatibility
Ensures commands are escaped correctly for your specific shell environment.
* **Command:** `git commit -m "feat(auth): implement google sign-in"`
* **Handling Multi-line:**
  ```powershell
  git commit -m "feat(auth): implement google sign-in`n`n- Added GoogleSignInProvider`n- Updated AuthGuard"