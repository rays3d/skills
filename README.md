# Google Antigravity IDE Skills for Flutter & Laravel Apps

Welcome to the Google Antigravity IDE Skills repository! This folder contains a collection of skills designed to enhance your development experience for Flutter and Laravel applications.

> **Stack Enforcement**
> This repository strictly enforces the following technology stack:
> *   **Flutter**: Riverpod (State Management), GoRouter (Navigation), Very Good Analysis (Linting).
> *   **Laravel**: Version 12, Service-Layer Architecture, Pest Testing.
> *   Legacy patterns (Provider, Navigator 1.0, Controllers with logic) are flagged as violations.

## Table of Contents
- [Overview](#overview)
- [Skills](#skills)
  - [API Contract Sync](#api-contract-sync)
  - [Barrel Enforcer](#barrel-enforcer)
  - [Build Runner Sentinel](#build-runner-sentinel)
  - [Code Review](#code-review)
  - [Database Schema Validator](#database-schema-validator)
  - [Doc Generator](#doc-generator)
  - [Doc Updater](#doc-updater)
  - [Env Variable Guard](#env-variable-guard)
  - [Feature Interrogator](#feature-interrogator)
  - [Feature Scaffold](#feature-scaffold)
  - [Flutter Asset Registrar](#flutter-asset-registrar)
  - [Flutter Auditor](#flutter-auditor)
  - [Flutter Consumer Widget Generator](#flutter-consumer-widget-generator)
  - [Flutter Riverpod Controller Generator](#flutter-riverpod-controller-generator)
  - [Flutter Very Good Analysis](#flutter-very-good-analysis)
  - [Git Smart Commit (Flutter & Laravel)](#git-smart-commit-flutter--laravel)
  - [Git Smart Commit (React)](#git-smart-commit-react)
  - [Inertia Page Scaffold](#inertia-page-scaffold)
  - [JSON to Dart Model](#json-to-dart-model)
  - [Laravel API Resource Generator](#laravel-api-resource-generator)
  - [Laravel Controller Generator](#laravel-controller-generator)
  - [Laravel Date Standardizer](#laravel-date-standardizer)
  - [Laravel Enum Generator](#laravel-enum-generator)
  - [Laravel Log Bridge](#laravel-log-bridge)
  - [Laravel Middleware Generator](#laravel-middleware-generator)
  - [Laravel Model Generator](#laravel-model-generator)
  - [Laravel MSC Architecture](#laravel-msc-architecture)
  - [Laravel Response Standardizer](#laravel-response-standardizer)
  - [Laravel Service Generator](#laravel-service-generator)
  - [Laravel to Flutter Bridge](#laravel-to-flutter-bridge)
  - [Laravel Test Generator](#laravel-test-generator)
  - [License Header Adder](#license-header-adder)
  - [Migration Safety Checker](#migration-safety-checker)
  - [OpenAPI Sync](#openapi-sync)
  - [Organize Docs](#organize-docs)
  - [Previous Task](#previous-task)
  - [Production Prep](#production-prep)
  - [React Component Generator](#react-component-generator)
  - [React Hook Extractor](#react-hook-extractor)
  - [React Lint Fixer](#react-lint-fixer)
  - [Resource Extractor](#resource-extractor)
  - [Router Generator](#router-generator)
  - [Theme Manager](#theme-manager)
- [Contributing](#contributing)
- [License](#license)

## Overview
This repository is a collection of skills designed to assist developers working on Flutter and Laravel applications. Each skill is located in its own folder and contains a `SKILL.md` file that provides detailed information about the skill, its purpose, and how to use it.

## Skills

### API Contract Sync
Synchronize API contracts between your frontend and backend to ensure consistency and reduce errors.

### Barrel Enforcer
Automatically manage and enforce barrel files in your project for better module organization.

### Build Runner Sentinel
Monitor and manage build_runner tasks in your Flutter projects.

### Code Review
Streamline the code review process with tools that enforce **Riverpod**, **GoRouter**, and **Very Good Analysis** standards.

### Database Schema Validator
Validate your database schema to ensure it adheres to best practices and project requirements.

#### Scripts
- `validate_schema.py`: A Python script to validate database schemas.

### Doc Generator
Generate documentation for your projects automatically.

### Doc Updater
Keep your documentation up-to-date with this handy tool.

### Env Variable Guard
Ensure your environment variables are properly configured and secure.

### Feature Interrogator
Analyze and interrogate features in your codebase for better understanding and maintenance.

### Feature Scaffold
Quickly scaffold new features using a strict **Riverpod** + **GoRouter** Clean Architecture structure.

### Flutter Asset Registrar
Manage and register Flutter assets efficiently.

### Flutter Auditor
Audit your Flutter projects for legacy code violations (e.g., usage of `Provider` or `Navigator.push`).

### Flutter Consumer Widget Generator
Scaffolds UI components enforcing Riverpod 3.0 rules, forbidding StatelessWidget if watching state, and maximizing widget extraction.

### Flutter Riverpod Controller Generator
Scaffolds Riverpod 3.0 Notifier/AsyncNotifier controllers dedicated strictly to business logic and decoupled from UI.

### Flutter Very Good Analysis
Enforces "Very Good Analysis" rules and standard formatting (100 char limit) for Flutter projects.

### Git Smart Commit (Flutter & Laravel)
Enhance your Git commit workflow with smart commit messages and automation for Flutter and Laravel framesworks.

### Git Smart Commit (React)
Staging and committing React project changes using Conventional Commits.

### Inertia Page Scaffold
Scaffolds Inertia/React pages and components matching the project's exact directory layout, shared layouts, and centralized API endpoint registry.

### JSON to Dart Model
Easily convert JSON objects to Dart models for use in your Flutter applications.

### Laravel API Resource Generator
Scaffolds Eloquent API Resources for standardizing output formatting, explicitly typing return schemas, and enforcing DateHelper usage.

### Laravel Controller Generator
Scaffolds Skinny Controllers enforcing Model-Service-Controller (MSC) constraints, prohibiting inline validation and direct DB access.

### Laravel Date Standardizer
Standardize date formats across your Laravel applications.

### Laravel Enum Generator
Scaffolds PHP 8.1 backed string enums matching the project's convention — UPPER_CASE keys, label(), values(), and optional is*() helpers.

### Laravel Log Bridge
Integrate and manage logging in your Laravel projects.

### Laravel Middleware Generator
Scaffolds custom middleware classes following project conventions — ResponseHelper-based denials, PHPDoc blocks, and bootstrap/app.php registration reminders.

### Laravel Model Generator
Scaffolds Eloquent Models adhering strictly to Laravel 12+ standards, enforcing `casts()` methods, precise relationship return types, and associated factories/seeders.

### Laravel MSC Architecture
Implement the Model-Service-Controller (MSC) architecture in your Laravel 12 applications.

#### Examples
- `Product.php`: Example of a model.
- `ProductController.php`: Example of a controller.
- `ProductPolicy.php`: Example of a policy.
- `ProductResource.php`: Example of a resource.
- `ProductService.php`: Example of a service.
- `StoreProductRequest.php`: Example of a request.

### Laravel Response Standardizer
Standardize API responses in your Laravel applications.

### Laravel Service Generator
Scaffolds service classes following the project's result-array pattern — constructor injection, try/catch with ResponseHelper::logError, and Log audit trails.

### Laravel to Flutter Bridge
Bridge the gap between Laravel and Flutter applications by regenerating **Riverpod AsyncNotifiers** from Laravel Resources.

### Laravel Test Generator
Generate high-performance tests for Laravel applications using Pest PHP conventions. This skill ensures compliance with Laravel's testing standards and optimizes test performance.

### License Header Adder
Automatically add license headers to your source files.

### Migration Safety Checker
Validates migration files for Laravel 12 pitfalls — column modification attribute re-declaration, FK naming, and reversibility.

### OpenAPI Sync
Keeps openapi.yaml in sync with routes/api.php. Detects undocumented endpoints, orphaned spec entries, and response schema drift.

### Organize Docs
Reorganize documentation folders into a standardized, navigable structure.

### Previous Task
A utility to manage and revisit previous tasks in your project.

### Production Prep
Automates final preparations for Flutter apps, including splash screens, launcher icons, package renaming, dependency upgrades, and asset cleanup.

### React Component Generator
Generates a React component folder with a functional component, styles, and a test file.

### React Hook Extractor
Extracts business or state logic from a component into a reusable custom hook.

### React Lint Fixer
Automatically detects and fixes React/JS linting issues using ESLint.

### Resource Extractor
Extract and manage resources from your projects efficiently.

### Router Generator
Generate and manage strict **GoRouter** configurations for your applications.

### Theme Manager
Manage and apply themes in your Flutter applications.

## Contributing
We welcome contributions! Please refer to the `CONTRIBUTING.md` file for guidelines on how to contribute to this repository.

## License
This repository is licensed under the MIT License. See the `LICENSE` file for more details.