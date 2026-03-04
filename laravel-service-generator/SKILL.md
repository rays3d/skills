---
id: skill_laravel_service_gen
name: Laravel Service Generator
version: 1.0.0
description: Scaffolds service classes following the project's result-array pattern — constructor injection, try/catch with ResponseHelper::logError, and Log audit trails.
tags: [laravel, service, scaffolding, architecture]
permissions: [write_code]
---

# Laravel Service Generator

## Overview
Creates service classes in `app/Services/` matching the exact conventions of `AuthService`, `UserService`, `AffiliationService`, etc.

## Rules Engine

### 1. File Location
* All services live in `app/Services/`.
* Class name ends with `Service` suffix (e.g., `PaymentService`).

### 2. Constructor
* Use PHP 8 constructor property promotion for dependency injection.
* Inject other services or models as needed — **never** inject `Request` or `Response`.

```php
public function __construct(
    protected TokenService $tokenService,
    protected MailService $mailService
) {}
```

### 3. Return Type — The Result Array Pattern
All public methods that represent operations (not simple getters) **must** return:

```php
/** @return array{success: bool, message: string, data?: mixed} */
```

**Success example:**
```php
return [
    'success' => true,
    'message' => 'Operation completed',
    'data' => [...],
];
```

**Failure example:**
```php
return [
    'success' => false,
    'message' => 'Something went wrong',
];
```

### 4. Error Handling
* Wrap every public method body in `try/catch(Exception $e)`.
* Inside `catch`: call `ResponseHelper::logError('Context message', $e)`.
* Return a failure result array from `catch` — **never** re-throw unless the caller expects it.

### 5. Audit Logging
* Use `Log::info(...)` for successful operations with `['user_id' => ...]` context.
* Use `Log::warning(...)` for expected failures (invalid credentials, not found, etc.).
* Do **not** use `Log::error(...)` directly — that's handled by `ResponseHelper::logError`.

### 6. HTTP Isolation
Services must **never** reference:
* `Illuminate\Http\Request`
* `Illuminate\Http\JsonResponse`
* `ResponseHelper::success/error/created` (that's the Controller's job)
* Any Resource class

Services receive **primitives, arrays, or Models** as parameters and return **arrays, Models, or Collections**.

### 7. Simple Getters
Methods that only retrieve data may return a `Model`, `Collection`, or `Builder` directly:

```php
public function getUserById(int $id): ?User
{
    return User::with([...])->find($id);
}

public function getAllUsers(): Builder
{
    return User::query()->with([...])->orderBy('name', 'asc');
}
```

## Template

```php
<?php

namespace App\Services;

use App\Helpers\ResponseHelper;
use App\Models\Payment;
use Exception;
use Illuminate\Support\Facades\Log;

class PaymentService
{
    public function __construct(
        protected TokenService $tokenService
    ) {}

    /**
     * Process a payment.
     *
     * @return array{success: bool, message: string, data?: mixed}
     */
    public function processPayment(int $userId, float $amount): array
    {
        try {
            $payment = Payment::create([
                'user_id' => $userId,
                'amount' => $amount,
                'status' => 'pending',
            ]);

            Log::info('Payment created', ['payment_id' => $payment->id, 'user_id' => $userId]);

            return [
                'success' => true,
                'message' => 'Payment processed successfully',
                'data' => [
                    'payment' => $payment,
                ],
            ];
        } catch (Exception $e) {
            ResponseHelper::logError('Payment processing failed', $e);

            return [
                'success' => false,
                'message' => 'An error occurred while processing payment',
            ];
        }
    }
}
```

## Post-Scaffold Checklist
1. Inject the new service into the relevant Controller via constructor promotion.
2. Create a corresponding feature test in `tests/Feature/Services/`.
3. Ensure the Controller delegates to this service and wraps responses with `ResponseHelper`.

## Trigger
> "Create a service for …", "Add a service class", "scaffold service …"
