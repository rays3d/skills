---
id: skill_laravel_controller_gen
name: Laravel Controller Generator
version: 1.0.0
description: Scaffolds Skinny Controllers enforcing Model-Service-Controller (MSC) constraints, prohibiting inline validation and direct DB access.
tags: [laravel, controller, architecture, msc]
permissions: [write_code]
---

# Laravel Controller Generator

## Overview
Generates controller classes in `app/Http/Controllers/` that strictly adhere to the Model-Service-Controller and Request-Policy-Resource (MSC+RPR) architecture pattern.

## Rules Engine

### 1. The "Skinny Controller" Rule
* **Forbidden:** Direct DB queries (e.g., `User::where(...)`), inline validation logic, loops, calculation logic, or raw `response()->json()`.
* **Required:** Must inject a **Service** to handle logic. Must return `ResponseHelper` wrapping an **Eloquent API Resource**.

### 2. Dependency Injection
* Must use PHP 8 constructor property promotion to inject single or multiple services.
* **Note:** Route Model Binding can be used in method signatures, but validation must happen via dedicated Form Requests.

```php
public function __construct(
    protected PaymentService $paymentService
) {}
```

### 3. Validation via Form Requests
* Controllers must **never** use `$request->validate([...])`.
* Required: Inject custom Form Request objects (e.g., `StorePaymentRequest $request`).

### 4. Standardization Hooks & Responses
* **Listings (Index):** Must use `PaginationHelper::paginate($query)` rather than native `$query->paginate()`, unless standard `$query->simplePaginate()` matches project norms. Always wrap results in `ResponseHelper::success`.
* **Single Items:** Must return via `ResponseHelper::success(new FeatureResource($item))`.
* **Errors:** Logic failures are handled by the Service layer, which returns standard arrays `['success' => false, 'message' => ...]`. Controllers check this boolean constraint.

## Template Example

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Payment\StorePaymentRequest;
use App\Http\Resources\PaymentResource;
use App\Services\PaymentService;
use App\Helpers\ResponseHelper;
use Illuminate\Http\JsonResponse;

class PaymentController extends Controller
{
    public function __construct(
        protected PaymentService $paymentService
    ) {}

    public function store(StorePaymentRequest $request): JsonResponse
    {
        $result = $this->paymentService->processPayment(
            $request->user()->id,
            $request->validated('amount')
        );

        if (! $result['success']) {
            return ResponseHelper::error($result['message'], 400);
        }

        return ResponseHelper::created(
            'Payment processed successfully',
            new PaymentResource($result['data']['payment'])
        );
    }
}
```

## Trigger
> "Create a controller for ...", "Scaffold controller ...", "Add a controller connecting to X service"
