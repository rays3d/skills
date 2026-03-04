---
id: skill_laravel_middleware_gen
name: Laravel Middleware Generator
version: 1.0.0
description: Scaffolds custom middleware classes following project conventions — ResponseHelper-based denials, PHPDoc blocks, and bootstrap/app.php registration reminders.
tags: [laravel, middleware, scaffolding, auth]
permissions: [write_code]
---

# Laravel Middleware Generator

## Overview
Creates middleware classes in `app/Http/Middleware/` matching the patterns of `AdminMiddleware` and `VerifiedMiddleware`.

## Rules Engine

### 1. File Location
* All middleware live in `app/Http/Middleware/`.
* Class name ends with `Middleware` suffix (e.g., `RateLimitMiddleware`).

### 2. Method Signature
```php
public function handle(Request $request, Closure $next): Response
```

### 3. Denial Pattern
* **Forbidden:** Using `abort(403)` or `throw new HttpException`.
* **Required:** Use `ResponseHelper::forbidden('...')` for API middleware.
* For web-only middleware, `redirect()->route('login')` is acceptable.

### 4. PHPDoc
* Add a class-level PHPDoc explaining what the middleware enforces.

### 5. Registration Reminder
After creating the middleware, always remind the developer:
> Register this middleware in `bootstrap/app.php` using `->withMiddleware()`.
> Laravel 12 does not use `app/Http/Kernel.php`.

## Template

```php
<?php

namespace App\Http\Middleware;

use App\Helpers\ResponseHelper;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Ensures the authenticated user has the required role.
 */
class RoleMiddleware
{
    public function handle(Request $request, Closure $next, string $role): Response
    {
        if ($request->user()?->role?->value !== $role) {
            return ResponseHelper::forbidden('You do not have the required role.');
        }

        return $next($request);
    }
}
```

## Post-Scaffold Checklist
1. Register in `bootstrap/app.php`:
   ```php
   ->withMiddleware(function (Middleware $middleware) {
       $middleware->alias([
           'role' => \App\Http\Middleware\RoleMiddleware::class,
       ]);
   })
   ```
2. Apply to routes: `Route::middleware(['role:admin'])->group(...)`
3. Write a feature test asserting the middleware blocks unauthorized access.

## Trigger
> "Create middleware for …", "Add a middleware that checks …", "scaffold middleware"
