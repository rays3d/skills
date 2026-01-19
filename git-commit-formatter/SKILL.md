---
name: git-commit-formatter
description: Formats git commit messages according to Conventional Commits specification. Trigger this when suggesting or executing git commits.
---

# Git Commit Formatter Skill

All commit messages must adhere to the Conventional Commits 1.0.0 specification, optimized for a Flutter/Laravel/React full-stack environment.

## Format

`<type>[optional scope]: <description>`

## Allowed Types

- **feat**: A new feature (e.g., a new Flutter widget or Laravel API endpoint).
- **fix**: A bug fix (e.g., fixing a Provider state leak or a PHP Enum mismatch).
- **docs**: Documentation only changes.
- **style**: Changes that do not affect the meaning of the code (formatting, missing semi-colons).
- **refactor**: A code change that neither fixes a bug nor adds a feature.
- **perf**: A code change that improves performance (e.g., implementing `Selector` in Flutter).
- **test**: Adding missing tests or correcting existing tests (Pest for Laravel, Widget tests for Flutter).
- **chore**: Changes to the build process, dependencies, or auxiliary tools (e.g., `pubspec.yaml` updates).

## Recommended Scopes

- **flutter**: UI, Widgets, Providers, or App-level changes.
- **laravel**: Controllers, Services, Migrations, or Resources.
- **react**: Components, Hooks, or Vite config.
- **deps**: Dependency updates (npm, composer, pub).
- **config**: Environment variables, Windows/Laragon setup.

## Instructions

1. **Analyze**: Review the `git diff` to determine the primary type.
2. **Scope**: Identify the layer (e.g., `feat(laravel-service)` or `fix(flutter-ui)`).
3. **Imperative Mood**: Use "add", "fix", "change" instead of "added", "fixes", "changed".
4. **Breaking Changes**: For breaking changes, append `!` after the type/scope and add a footer: `BREAKING CHANGE: <description>`.

## PowerShell 7 Execution Context

When suggesting a commit command to the user, format it for PowerShell 7:
`git commit -m "feat(scope): description"`

## Example

`feat(flutter): implement login screen using Provider`
`fix(laravel): update PatientResource to include enum status`
`chore(deps): bump dio from 5.4.0 to 5.5.0`
