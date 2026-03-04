---
id: skill_laravel_enum_gen
name: Laravel Enum Generator
version: 1.0.0
description: Scaffolds PHP 8.1 backed string enums matching the project's convention — UPPER_CASE keys, label(), values(), and optional is*() helpers.
tags: [laravel, php, enum, scaffolding]
permissions: [write_code]
---

# Laravel Enum Generator

## Overview
Generates backed string enums in `app/Enums/` following the exact structure used by `CareerStage`, `Gender`, `UserRole`, etc.

## Rules Engine

### 1. File Location
* All enums **must** live in `app/Enums/`.
* Class name matches the file name in PascalCase (e.g., `PaymentStatus.php` → `PaymentStatus`).

### 2. Case Naming
* Enum keys use `UPPER_CASE` (e.g., `PENDING`, `COMPLETED`).
* Backed values use lowercase snake_case strings (e.g., `'pending'`, `'in_progress'`).

### 3. Required Methods
Every enum **must** include:

| Method     | Signature                                | Purpose                                        |
| ---------- | ---------------------------------------- | ---------------------------------------------- |
| `label()`  | `public function label(): string`        | Human-readable display name via `match`        |
| `values()` | `public static function values(): array` | Returns `array_column(self::cases(), 'value')` |

### 4. Optional `is*()` Helpers
If the enum has 2–4 cases, generate convenience boolean checkers:
```php
public function isPending(): bool
{
    return $this === self::PENDING;
}
```

### 5. PHPDoc
* Add a PHPDoc block on every method (single-line `/** ... */` is acceptable for simple helpers).

### 6. Model Cast Registration
* After creating the enum, remind the developer to add it to the model's `$casts` array or `casts()` method.

## Template

```php
<?php

namespace App\Enums;

enum PaymentStatus: string
{
    case PENDING = 'pending';
    case COMPLETED = 'completed';
    case FAILED = 'failed';

    /**
     * Check if status is pending.
     */
    public function isPending(): bool
    {
        return $this === self::PENDING;
    }

    /**
     * Check if status is completed.
     */
    public function isCompleted(): bool
    {
        return $this === self::COMPLETED;
    }

    /**
     * Check if status is failed.
     */
    public function isFailed(): bool
    {
        return $this === self::FAILED;
    }

    /**
     * Get display label.
     */
    public function label(): string
    {
        return match ($this) {
            self::PENDING => 'Pending',
            self::COMPLETED => 'Completed',
            self::FAILED => 'Failed',
        };
    }

    /**
     * Get all values.
     */
    public static function values(): array
    {
        return array_column(self::cases(), 'value');
    }
}
```

## Trigger
> "Create an enum for …", "Add a status enum", "scaffold enum …"
