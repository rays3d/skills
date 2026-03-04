---
id: skill_laravel_api_resource_gen
name: Laravel API Resource Generator
version: 1.0.0
description: Scaffolds Eloquent API Resources for standardizing output formatting, explicitly typing return schemas, and enforcing DateHelper usage.
tags: [laravel, resource, api, formatting]
permissions: [write_code]
---

# Laravel API Resource Generator

## Overview
Generates Laravel Eloquent API Resources in `app/Http/Resources/` to standardize data shapes returned to the frontend.

## Rules Engine

### 1. Explicit Array Shapes
* **Required:** The `toArray()` method must have an explicit return type hint: `public function toArray(Request $request): array`.
* Provide PHPDoc hinting above the `return` array to strictly enforce the output shape, catching discrepancies in Larastan.

```php
/**
 * Transform the resource into an array.
 *
 * @return array<string, mixed>
 */
public function toArray(Request $request): array
{
    // ...
}
```

### 2. Date Standardization
* **Forbidden:** Raw execution of `$this->created_at->format('Y-m-d')` or native Carbon strings (`$this->created_at->toDateTimeString()`).
* **Required:** Must use `App\Helpers\DateHelper` to format all dates to ensure platform consistency.

```php
use App\Helpers\DateHelper;

return [
    'id' => $this->id,
    'title' => $this->title,
    'created_at' => DateHelper::formatDateTime($this->created_at),
    'updated_at' => DateHelper::formatDateTime($this->updated_at),
];
```

### 3. Conditional Relationships
* Use `$this->whenLoaded('relationName')` to avoid N+1 queries when formatting relations. Ensure nested relations use their respective Resource class.

```php
'user' => new UserResource($this->whenLoaded('user')),
```

## Trigger
> "Create an API resource for ...", "Scaffold resource ...", "Format the X model output"
