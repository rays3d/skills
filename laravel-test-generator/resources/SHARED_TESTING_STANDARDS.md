# Testing Standards for Laravel + Pest PHP

> **Portable Guide** — Adopt these standards for any Laravel backend project.
> Requires **PHP 8.4+**, **Laravel 12+**, and **Pest PHP 4.x**.

---

## Table of Contents

1. [Setup](#1-setup)
2. [Directory Structure](#2-directory-structure)
3. [Configuration](#3-configuration)
4. [Pest Style Guide](#4-pest-style-guide)
5. [Assertions](#5-assertions)
6. [Datasets](#6-datasets)
7. [Mocking & Fakes](#7-mocking--fakes)
8. [Architecture Rules](#8-architecture-rules)
9. [Factories & Fixtures](#9-factories--fixtures)
10. [Best Practices](#10-best-practices)
11. [TestCase Helpers](#11-testcase-helpers)
12. [Running Tests](#12-running-tests)
13. [CI/CD Integration](#13-cicd-integration)
14. [PR Checklist](#14-pr-checklist)

---

## 1. Setup

### Install Pest

```bash
composer require pestphp/pest --dev --with-all-dependencies
composer require pestphp/pest-plugin-laravel --dev
```

> **Note**: Pest 4.x auto-configures itself on install — no `pest:install` command needed.

### Create Tests with Artisan

```bash
# Feature test (default)
php artisan make:test --pest UserRegistrationTest

# Unit test
php artisan make:test --pest --unit CalculatorTest
```

---

## 2. Directory Structure

We enforce strict separation based on the **Pure vs. Impure** principle.

```
tests/
├── Feature/                  # Integration tests — HTTP, services, DB flows
│   ├── Api/                  # API endpoint tests
│   ├── Web/                  # Web portal / Inertia tests
│   ├── Services/             # Service layer tests
│   ├── Jobs/                 # Queue job tests
│   ├── Mail/                 # Mailable tests
│   ├── Console/              # Artisan command tests
│   └── ArchTest.php          # Architecture enforcement rules
├── Unit/                     # Pure unit tests — NO database, NO HTTP
├── Pest.php                  # Pest configuration & custom expectations
└── TestCase.php              # Base test class with shared helpers
```

### When does a test go where?

| Directory  | Type        | Database Access? | Mocking             |
| ---------- | ----------- | ---------------- | ------------------- |
| `Unit/`    | Pure Unit   | ❌ **FORBIDDEN**  | Mock everything     |
| `Feature/` | Integration | ✅ Allowed        | Fakes (Mail, Queue) |

> **Rule**: If a test needs `RefreshDatabase`, it belongs in `tests/Feature`.

---

## 3. Configuration

### `tests/Pest.php` — Starter File

```php
<?php

// Bind TestCase + auto-apply RefreshDatabase for all Feature tests
pest()->extend(Tests\TestCase::class)
    ->use(Illuminate\Foundation\Testing\RefreshDatabase::class)
    ->in('Feature');

// Custom expectations (optional)
expect()->extend('toBeOne', fn () => $this->toBe(1));
```

### `phpunit.xml` — Recommended Environment Overrides

Add these inside the `<php>` block to isolate tests from real infrastructure:

```xml
<env name="APP_ENV" value="testing"/>
<env name="DB_CONNECTION" value="sqlite"/>
<env name="DB_DATABASE" value=":memory:"/>
<env name="DB_FOREIGN_KEYS" value="true"/>
<env name="CACHE_STORE" value="array"/>
<env name="MAIL_MAILER" value="array"/>
<env name="QUEUE_CONNECTION" value="sync"/>
<env name="SESSION_DRIVER" value="array"/>
<env name="BCRYPT_ROUNDS" value="4"/>
```

> **Why?** SQLite in-memory is 10–20× faster than MySQL for tests. Array drivers prevent side-effects.

---

## 4. Pest Style Guide

### A. Use `it()` and `test()`

```php
it('creates a new post', function () {
    // Test body
});

test('guest cannot access dashboard', function () {
    // Test body
});
```

### B. Group Related Tests with `describe()`

```php
describe('post creation', function () {
    beforeEach(function () {
        $this->user = User::factory()->create();
    });

    it('authenticated user can create a post', function () {
        $this->actingAs($this->user)
            ->postJson('/api/posts', ['title' => 'Hello World'])
            ->assertCreated();
    });

    it('guest cannot create a post', function () {
        $this->postJson('/api/posts', ['title' => 'Hello World'])
            ->assertUnauthorized();
    });
});
```

### C. Use `beforeEach()` for Shared Fixtures

```php
beforeEach(function () {
    $this->user = User::factory()->create();
    $this->category = Category::factory()->create();
});
```

> **Rule**: Never use PHPUnit's `setUp()` method; always use `beforeEach()`.

### D. Follow Arrange–Act–Assert

```php
it('publishes a draft post', function () {
    // Arrange
    $post = Post::factory()->draft()->create();

    // Act
    $post->publish();

    // Assert
    expect($post->fresh()->status)->toBe('published');
});
```

---

## 5. Assertions

### Pest `expect()` API

Prefer Pest's `expect()` for value assertions:

```php
expect($user->is_active)->toBeTrue();
expect($result)->toBe(42);
expect($collection)->toHaveCount(5);

// Chained assertions
expect($post->status)->toBe('published')
    ->and($post->is_featured)->toBeFalse();

// Higher-order expectations
expect($users)->each->toBeInstanceOf(User::class);
```

### Laravel HTTP Assertions

For HTTP responses, use Laravel's fluent assertion methods:

```php
$response->assertOk()
    ->assertJson([
        'success' => true,
        'message' => 'Post created successfully',
    ])
    ->assertJsonPath('data.title', 'Hello World')
    ->assertJsonStructure([
        'data' => ['id', 'title', 'created_at'],
    ]);
```

### Database Assertions

```php
// Record exists
$this->assertDatabaseHas('posts', ['title' => 'Hello World']);

// Record missing
$this->assertDatabaseMissing('posts', ['id' => $post->id]);

// Soft delete
$this->assertSoftDeleted($post);
```

### Validation Errors

```php
$response->assertStatus(422)
    ->assertJsonValidationErrors(['name', 'email']);
```

### Exception Testing

```php
it('throws on division by zero', function () {
    expect(fn () => divide(10, 0))->toThrow(DivisionByZeroError::class);
});
```

---

## 6. Datasets

Use Datasets to test multiple variations without duplicating test code:

```php
it('validates email format', function (string $email, bool $isValid) {
    $rule = new ValidEmailRule();

    expect($rule->passes('email', $email))->toBe($isValid);
})->with([
    ['user@example.com', true],
    ['invalid-email', false],
    ['missing-tld@domain', false],
]);
```

### Inline Datasets for Simple Cases

```php
it('validates required fields', function (string $field) {
    $this->actingAs($this->user)
        ->postJson('/api/posts')
        ->assertJsonValidationErrorFor($field);
})->with(['title', 'body', 'category_id']);
```

### Named Datasets for Complex Cases

```php
dataset('valid users', [
    'admin'  => [fn () => User::factory()->admin()->make()],
    'editor' => [fn () => User::factory()->editor()->make()],
]);

it('allows authorized users', function (User $user) {
    $this->actingAs($user)
        ->getJson('/api/admin/dashboard')
        ->assertOk();
})->with('valid users');
```

---

## 7. Mocking & Fakes

### Facade Fakes (Preferred)

Laravel's built-in fakes prevent real side-effects:

```php
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Facades\Notification;

it('sends a welcome email on registration', function () {
    Mail::fake();

    // ... trigger registration action

    Mail::assertQueued(WelcomeEmail::class);
});

it('dispatches processing job', function () {
    Queue::fake();

    // ... trigger action

    Queue::assertPushed(ProcessUploadJob::class);
});
```

### Service Mocking with `mock()`

```php
it('handles external API failure gracefully', function () {
    $mock = mock(PaymentGateway::class)
        ->shouldReceive('charge')
        ->once()
        ->andThrow(new ConnectionException())
        ->getMock();

    app()->instance(PaymentGateway::class, $mock);

    $this->actingAs($this->user)
        ->postJson('/api/checkout', ['amount' => 100])
        ->assertServiceUnavailable();
});
```

### HTTP Client Fakes

```php
use Illuminate\Support\Facades\Http;

it('retries failed API calls', function () {
    Http::fake([
        'api.example.com/*' => Http::sequence()
            ->push(['error' => 'timeout'], 500)
            ->push(['data' => 'success'], 200),
    ]);

    $result = app(ExternalService::class)->fetch();

    expect($result)->toBe('success');
    Http::assertSentCount(2);
});
```

---

## 8. Architecture Rules

Enforce code quality constraints automatically using Pest's Arch plugin. Create a `tests/Feature/ArchTest.php` file:

```php
<?php

// 1. No debugging leftovers anywhere in the codebase
arch('no debugging statements')
    ->expect(['dd', 'dump', 'ray', 'env'])
    ->not->toBeUsed();

// 2. Controllers must use FormRequest — not inline Validator
arch('controllers use form requests')
    ->expect('App\Http\Controllers')
    ->not->toUse('Illuminate\Support\Facades\Validator');

// 3. Models must extend Eloquent base
arch('models extend eloquent')
    ->expect('App\Models')
    ->toExtend('Illuminate\Database\Eloquent\Model');

// 4. Models should not use HTTP layer
arch('models have no http dependency')
    ->expect('App\Models')
    ->not->toUse('Illuminate\Http\Request');

// 5. Resources extend JsonResource
arch('resources extend json resource')
    ->expect('App\Http\Resources')
    ->toExtend('Illuminate\Http\Resources\Json\JsonResource');
```

### Additional Rules to Consider

```php
// Controllers should be invokable or suffixed
arch('controllers are final')
    ->expect('App\Http\Controllers')
    ->toBeFinal();

// No direct env() usage outside config files
arch('no env outside config')
    ->expect('env')
    ->not->toBeUsed();

// Strict types declaration
arch('strict types')
    ->expect('App')
    ->toUseStrictTypes();
```

> **Tip**: Start with a few rules and expand as the codebase matures. Overly strict rules on a new project add friction.

---

## 9. Factories & Fixtures

### Always Use Factories

```php
// ✅ Good — Uses factory with states
$user = User::factory()->verified()->create();
$post = Post::factory()->draft()->for($user)->create();

// ✅ Good — Factory with relationship
$post = Post::factory()
    ->for(User::factory())
    ->has(Comment::factory()->count(3))
    ->create();

// ❌ Bad — Manual model creation when factory exists
$user = new User();
$user->name = 'Test';
$user->save();
```

### Define Useful Factory States

```php
// database/factories/PostFactory.php
public function draft(): static
{
    return $this->state(fn (array $attributes) => [
        'status' => 'draft',
        'published_at' => null,
    ]);
}

public function published(): static
{
    return $this->state(fn (array $attributes) => [
        'status' => 'published',
        'published_at' => now(),
    ]);
}
```

### Use Factories in Relationships

```php
// Create with belongsTo
$post = Post::factory()->for(User::factory())->create();

// Create with hasMany
$user = User::factory()
    ->has(Post::factory()->count(3))
    ->create();
```

---

## 10. Best Practices

### Use Enums, Not Strings

```php
// ✅ Good
Order::create(['status' => OrderStatus::Pending]);

// ❌ Bad
Order::create(['status' => 'pending']);
```

### Use Constants for API Messages

Define a central constants class or enum and reference it in both production code and tests:

```php
// app/Constants/ApiMessages.php
final class ApiMessages
{
    public const POST_CREATED = 'Post created successfully';
    public const POST_DELETED = 'Post deleted successfully';
    public const UNAUTHORIZED = 'You are not authorized to perform this action';
}

// In tests:
$response->assertJsonPath('message', ApiMessages::POST_CREATED);
```

> **Why?** A typo in a hard-coded string won't break the test but will break production assertions silently. Constants catch those errors at compile time.

### Keep Tests Focused

Each test should verify **one behaviour**:

```php
// ✅ Good — one assertion per concern
it('creates a post', function () { /* ... */ });
it('returns validation errors for missing title', function () { /* ... */ });

// ❌ Bad — too many concerns in one test
it('creates a post and validates and checks permissions', function () { /* ... */ });
```

### Use Named Routes

```php
// ✅ Good
$this->getJson(route('posts.index'));

// ❌ Bad — brittle if URL changes
$this->getJson('/api/v1/posts');
```

### Test Authorization Separately

Create dedicated policy test files:

```php
// tests/Feature/PostPolicyTest.php

it('author can update their own post', function () {
    $user = User::factory()->create();
    $post = Post::factory()->for($user)->create();

    expect($user->can('update', $post))->toBeTrue();
});

it('non-author cannot update post', function () {
    $author = User::factory()->create();
    $stranger = User::factory()->create();
    $post = Post::factory()->for($author)->create();

    expect($stranger->can('update', $post))->toBeFalse();
});
```

---

## 11. TestCase Helpers

Define reusable helpers in `tests/TestCase.php` to reduce duplication:

```php
<?php

namespace Tests;

use App\Models\User;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;

abstract class TestCase extends BaseTestCase
{
    /**
     * Create a verified, active user.
     */
    protected function createVerifiedUser(array $attributes = []): User
    {
        return User::factory()->create(array_merge([
            'is_active' => true,
            'email_verified_at' => now(),
        ], $attributes));
    }

    /**
     * Create an admin user.
     */
    protected function createAdminUser(array $attributes = []): User
    {
        return User::factory()->admin()->create($attributes);
    }
}
```

Use these helpers in your tests:

```php
beforeEach(function () {
    $this->user = $this->createVerifiedUser();
});
```

> **Tip**: Keep helpers in `TestCase.php` for cross-file reuse. For file-scoped helpers, define them directly in `beforeEach()`.

---

## 12. Running Tests

### Standard Run

```bash
# All tests with compact output
php artisan test --compact

# OR use Pest directly
./vendor/bin/pest
```

### Filtering

```bash
# By file
php artisan test tests/Feature/Web/PostTest.php

# By name substring
php artisan test --filter="can create"

# By test suite
php artisan test --testsuite=Unit
php artisan test --testsuite=Feature

# Only Architecture tests
php artisan test --filter=Arch

# Only previously failing tests
php artisan test --only-failing
```

### Coverage

```bash
# Requires Xdebug or PCOV
php artisan test --coverage

# Enforce minimum threshold
php artisan test --coverage --min=80
```

---

## 13. CI/CD Integration

### GitHub Actions Example

```yaml
name: Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  tests:
    runs-on: ubuntu-latest

    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: password
          MYSQL_DATABASE: testing
        ports:
          - 3306:3306
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3

    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'  # Minimum 8.4+
          extensions: mbstring, pdo, pdo_mysql, sqlite3
          coverage: pcov

      - name: Install Dependencies
        run: composer install --no-interaction --prefer-dist

      - name: Run Tests with Coverage
        run: php artisan test --compact --coverage --min=80
        env:
          DB_CONNECTION: sqlite
          DB_DATABASE: ':memory:'

      - name: Run Pint (Code Style)
        run: vendor/bin/pint --test
```

### Coverage Thresholds

Set minimum coverage in your CI pipeline to prevent regressions:

```bash
php artisan test --coverage --min=80
```

> Start at your current coverage and increase the threshold by 1–2% per sprint.

---

## 14. PR Checklist

Before merging any pull request, every developer must verify:

- [ ] All tests pass (`php artisan test --compact`)
- [ ] New features have corresponding tests
- [ ] Tests use `it()` or `test()` syntax (not PHPUnit class-based tests)
- [ ] Tests use `beforeEach()` for setup (not `setUp()` method)
- [ ] Uses constant classes for response message assertions
- [ ] Uses enums for status/role fields
- [ ] No `dd()`, `dump()`, or `ray()` left in code
- [ ] Factories used for model creation where available
- [ ] Pint formatting passes (`vendor/bin/pint --test`)
- [ ] Coverage does not drop below the project threshold

---

## Quick Reference Card

| What                | How                                              |
| ------------------- | ------------------------------------------------ |
| Create feature test | `php artisan make:test --pest FeatureNameTest`   |
| Create unit test    | `php artisan make:test --pest --unit HelperTest` |
| Run all tests       | `php artisan test --compact`                     |
| Run one file        | `php artisan test tests/Feature/PostTest.php`    |
| Run by name         | `php artisan test --filter="can create"`         |
| Run coverage        | `php artisan test --coverage --min=80`           |
| Format code         | `vendor/bin/pint`                                |
| Architecture rules  | `php artisan test --filter=Arch`                 |

---

*Last Updated: 2026-02-12*
