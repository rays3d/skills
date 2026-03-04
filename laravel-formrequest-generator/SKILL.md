---
id: skill_laravel_formrequest_generator
name: Laravel FormRequest Generator
version: 1.0.0
description: Scaffolds FormRequest validation classes matching project conventions (string-rules, Rule::exists scoping).
tags: [laravel, backend, validation, request]
permissions: [read_file, write_file, execute_terminal]
---

# Laravel FormRequest Generator

## Overview

Generates custom FormRequest classes under `App\Http\Requests\<Domain>\` to keep Laravel controllers lean.

This skill enforces string-based rules separated by pipes (`|`), standardizing validation and preventing chaotic array-based declarations. It also ensures specific patterns for checking database existence queries constrained by ownership (`Rule::exists()->where()`).

## Capabilities

### Scaffold Form Request

**Trigger:** `/request <Name> <Domain>` (e.g. `/request StorePatientRequest Patient`)
**Prerequisites:** Identification of the expected validated fields.

**Actions:**
1. Generates `app/Http/Requests/<Domain>/<Name>.php`.
2. Sets `authorize()` to `true` by default (allowing the `Policy` logic run in the controller to handle access).
3. Adds `rules()` method using string-based piping.
4. If checking relations, includes `use Illuminate\Validation\Rule;` to ensure appropriate `where` conditions target user scopes.

## Reference Template

```php
<?php

namespace App\Http\Requests\{{Domain}};

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class {{RequestName}} extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $userId = $this->user()->id;

        return [
            // Standard string-based piping
            'name' => 'required|string|max:255',
            'is_active' => 'nullable|boolean',

            // Relational checks mapped to the active authorized user
            'category_id' => [
                'required',
                Rule::exists('categories', 'id')->where('user_id', $userId),
            ],

            // File validation using PHP extensions (Laravel 11+ syntax)
            'images' => 'nullable|array',
            'images.*.file' => 'nullable|file|mimes:jpg,jpeg,png,webp|max:20480',

            // Document/Model validation
            'models' => 'nullable|array',
            'models.*.file' => 'nullable|file|extensions:obj,fbx,glb,stl|max:20480',
        ];
    }
}
```
