---
id: skill_laravel_model_gen
name: Laravel Model Generator
version: 1.0.0
description: Scaffolds Eloquent Models adhering strictly to Laravel 12+ standards, enforcing `casts()` methods, precise relationship return types, and associated factories/seeders.
tags: [laravel, model, database, architecture]
permissions: [write_code]
---

# Laravel Model Generator

## Overview
Generates Laravel Eloquent models that strictly comply with the latest Laravel 12 standards and project conventions.

## Rules Engine

### 1. Casts Method
* **Forbidden:** Do not use the legacy `protected $casts = [];` array property.
* **Required:** Must define casts using the `protected function casts(): array` method.
* **Typing:** Use appropriate PHPDoc array shapes when casting JSON or array columns.

```php
protected function casts(): array
{
    /** @var array{id: int, name: string} */
    return [
        'is_active' => 'boolean',
        'metadata' => 'array',
        'published_at' => 'datetime',
    ];
}
```

### 2. Relationship Methods
* **Required:** Every Eloquent relationship method (e.g., `hasMany()`, `belongsTo()`) **must** have an explicit return type hint from `Illuminate\Database\Eloquent\Relations\*`.
* **Forbidden:** Omitting return types or typing them generally as `Builder` or `Relation`.

```php
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

public function user(): BelongsTo
{
    return $this->belongsTo(User::class);
}

public function orders(): HasMany
{
    return $this->hasMany(Order::class);
}
```

### 3. Mass Assignment
* Typically, it is preferred to use `protected $guarded = ['id'];` or explicitly list `$fillable`. Follow existing sibling models.

### 4. Companion Classes (Factories & Seeders)
* When scaffolding a model, ALWAYS remind or auto-generate its corresponding Factory and Seeder.
* Tell the user to use `php artisan make:model ModelName -mfs` if invoking via command line, but ensure the resulting files are updated to follow these strict rules.

## Trigger
> "Create a model for ...", "Scaffold model ...", "Generate model and migration for ..."
