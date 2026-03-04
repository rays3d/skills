---
id: skill_migration_safety
name: Migration Safety Checker
version: 1.0.0
description: Validates migration files for Laravel 12 pitfalls — column modification attribute re-declaration, FK naming, and reversibility.
tags: [laravel, migration, database, safety]
permissions: [read_code]
---

# Migration Safety Checker

## Overview
Scans migration files in `database/migrations/` for common pitfalls that silently break schemas, especially under Laravel 12's stricter column modification behavior.

## Rules Engine

### 1. Column Modification Rule (Critical)
**Laravel 12 behavior:** When modifying a column with `->change()`, any attributes not explicitly re-stated are **silently dropped**.

**Detected pattern:**
```php
$table->string('name', 100)->change();
```

**Required:** Before writing `->change()`, check the existing column definition and re-declare **all** of: type, length, nullable, default, comment, unsigned, etc.

```php
// WRONG — drops nullable and default if they were set
$table->string('name', 200)->change();

// RIGHT — preserves all existing attributes
$table->string('name', 200)->nullable()->default('N/A')->change();
```

**Action:** When a `->change()` call is detected:
1. Query the current schema using `database-schema` tool (with `include_column_details: true`).
2. Compare existing attributes against the migration code.
3. Flag any missing attributes that will be silently dropped.

### 2. Foreign Key Naming
* FK names must follow `{table}_{column}_foreign` convention.
* Prefer `->constrained()` shorthand over manual `->references('id')->on('table')` when the column follows `{table}_id` naming.
* Always include `->onDelete('cascade')` or `->onDelete('set null')` — never leave the default `restrict` without an explicit choice.

### 3. Down Method Reversibility
* **Warning** if `down()` is empty or missing.
* **Error** if `down()` drops a table but `up()` only modifies columns.
* The `down()` method should be the exact inverse of `up()`.

### 4. Index Naming
* Composite indexes should have descriptive names: `{table}_{col1}_{col2}_index`.
* Unique constraints: `{table}_{column}_unique`.

### 5. Nullable Flag Safety
* When adding a new column to an existing table with data, it **must** be `->nullable()` or have a `->default(...)` — otherwise the migration will fail on tables with existing rows.

## Workflow
1. Scan the target migration file.
2. For any `->change()` calls, cross-reference with the live schema.
3. Produce a report:
   - ✅ Safe modifications
   - ⚠️ Missing attribute re-declarations (with suggested fix)
   - ⚠️ Missing `down()` method
   - ❌ New non-nullable columns without defaults on existing tables

## Integration
* Works alongside `database-schema-validator` skill (which handles naming conventions).
* This skill focuses on **runtime safety**, not naming.

## Trigger
> "Check my migration", "Is this migration safe?", "Review migration for …"
