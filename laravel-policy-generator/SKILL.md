---
id: skill_laravel_policy_generator
name: Laravel Policy Generator
version: 1.0.0
description: Scaffolds Laravel authorization policies matching the project's ownership and role-based conventions.
tags: [laravel, backend, policy, authorization, security]
permissions: [read_file, write_file, execute_terminal]
---

# Laravel Policy Generator

## Overview

This skill generates Laravel Policy classes that strictly conform to the `medispherexr` authorization conventions.

Project policies do not use blanket `true` for modifications. They rely on explicit `$user->id === $model->user_id` checks for simple ownership, or a private `isOwnerOrAdmin(User $user, Model $model)` helper method when the model belongs to a Workspace or Team.

## Capabilities

### 1. Scaffold Simple Ownership Policy

**Trigger:** `/policy <ModelName>` or "Create a policy for <ModelName>"
**Prerequisites:** Assumes the model has a `user_id` column.

**Actions:**
1. Generates `app/Policies/<ModelName>Policy.php`.
2. Implements standard CRUD methods (`viewAny`, `view`, `create`, `update`, `delete`, `restore`, `forceDelete`).
3. Enforces the strict rule: `viewAny` returns `false` or `true` based on context, while mutations check `$user->id === $model->user_id`.

### 2. Scaffold Workspace/Team Policy

**Trigger:** `/policy_workspace <ModelName>` or "Create a workspace-aware policy for <ModelName>"
**Prerequisites:** Assumes the model can have members or admins.

**Actions:**
1. Generates `app/Policies/<ModelName>Policy.php`.
2. Injects a private `isOwnerOrAdmin` method.
3. Implements extended workspace methods (e.g., `addMember`, `removeMember`, `assignAdmin`).

## Reference Templates

### Standard Ownership Policy Template

```php
<?php

namespace App\Policies;

use App\Models\User;
use App\Models\{{ModelName}};

class {{ModelName}}Policy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return false;
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, {{ModelName}} ${{modelNameCamel}}): bool
    {
        return $user->id === ${{modelNameCamel}}->user_id;
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return true;
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, {{ModelName}} ${{modelNameCamel}}): bool
    {
        return $user->id === ${{modelNameCamel}}->user_id;
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, {{ModelName}} ${{modelNameCamel}}): bool
    {
        return $user->id === ${{modelNameCamel}}->user_id;
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, {{ModelName}} ${{modelNameCamel}}): bool
    {
        return $user->id === ${{modelNameCamel}}->user_id;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, {{ModelName}} ${{modelNameCamel}}): bool
    {
        return $user->id === ${{modelNameCamel}}->user_id;
    }
}
```

### Workspace/Role Helper

When scaffolded with Workspace/Team rules, inject this helper at the bottom of the class and use it for mutation methods instead of the simple `$user->id` check:

```php
    private function isOwnerOrAdmin(User $user, {{ModelName}} ${{modelNameCamel}}): bool
    {
        if (${{modelNameCamel}}->user_id === $user->id) {
            return true;
        }

        return ${{modelNameCamel}}->members()
            ->where('user_id', $user->id)
            ->whereIn('role', ['admin', 'owner'])
            ->exists();
    }
```
