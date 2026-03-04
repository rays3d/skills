---
id: skill_laravel_mailable_generator
name: Laravel Mailable Generator
version: 1.0.0
description: Scaffolds Mailable classes matching the project's Queueable, Envelope, Content, and ApiMessages integration conventions.
tags: [laravel, backend, mail, email]
permissions: [read_file, write_file, execute_terminal]
---

# Laravel Mailable Generator

## Overview

Generates Laravel Mailable classes that rigidly follow the `medispherexr` pattern for sending structured emails.

All mailables MUST implement `ShouldQueue` (queue by default), employ the `Envelope` and `Content` objects from Laravel 9+, pass variables to standard Blade views, and use constants from `ApiMessages` for subjects.

## Capabilities

### Scaffold New Mailable

**Trigger:** `/mailable <Name>`
**Prerequisites:** Familiarity with the `App\Constants\ApiMessages` class.

**Actions:**
1. Generates `app/Mail/<Name>.php`.
2. Extends `Mailable` and implements `ShouldQueue`.
3. Adds `use Queueable, SerializesModels;`.
4. Stubs the `__construct()` to accept injected models and variables via PHP 8 property promotion.
5. Injects `use App\Constants\ApiMessages;`.
6. Prompts user to define a new constant inside `ApiMessages::SUBJECT_*` if the subject is new.
7. Adds a `middleware()` method if rate limiting on the mailable is requested.

## Reference Template

```php
<?php

namespace App\Mail;

use App\Constants\ApiMessages;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
// use Illuminate\Queue\Middleware\RateLimited;
use Illuminate\Queue\SerializesModels;

// use App\Models\SomeModel;

class {{MailableName}} extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     */
    public function __construct(
        // public SomeModel $model,
        // public string $someString,
    ) {}

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: ApiMessages::SUBJECT_{{YOUR_UPPER_SNAKE_CASE_SUBJECT_VAR}},
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            view: 'emails.{{folder}}.{{name}}',
            with: [
                // 'model' => $this->model,
                // 'extraData' => $this->someString,
            ],
        );
    }

    /* Optional:
    public function middleware(): array
    {
        return [new RateLimited('auth-email')];
    }
    */
}
```
