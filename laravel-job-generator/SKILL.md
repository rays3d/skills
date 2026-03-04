---
id: skill_laravel_job_generator
name: Laravel Job Generator
version: 1.0.0
description: Scaffolds queued jobs matching the project's ShouldQueue, logging, and injection conventions.
tags: [laravel, backend, job, queue, async]
permissions: [read_file, write_file, execute_terminal]
---

# Laravel Job Generator

## Overview

This skill generates Laravel Job classes that tightly follow the `medispherexr` queueing conventions.

All jobs must implement `ShouldQueue`, use the four standard traits, promote constructor properties (PHP 8), inject dependent services directly into `handle()`, and wrap execution in a `try/catch` with detailed `Log` statements.

## Capabilities

### Scaffold New Job

**Trigger:** `/job <JobName>` or "Create a background job for <Action>"
**Prerequisites:** None.

**Actions:**
1. Generates `app/Jobs/<JobName>.php`.
2. Applies standard class shell (traits + interface).
3. Adds `Log::info` to track job start and completion.
4. Wraps `handle()` logic in a `catch (Exception $e)` block that uses `Log::error`.
5. Prompts the user about whether to add `$this->release(60)` for automatic retries.

## Reference Template

Use the following exact structure when generating new Jobs. Replace the placeholders appropriately.

```php
<?php

namespace App\Jobs;

use Exception;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

// Replace target services if needed
use App\Services\YourService;

class {{JobName}} implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     */
    public function __construct(
        public string $someParameter // Use PHP 8 Constructor Property Promotion
    ) {}

    /**
     * Execute the job.
     * Service injection occurs here, not in the constructor.
     */
    public function handle(YourService $yourService): void
    {
        try {
            Log::info("Starting {{JobName}} for: {$this->someParameter}");

            // TODO: Execute service logic
            // $yourService->processSomething($this->someParameter);

            Log::info("{{JobName}} completed for: {$this->someParameter}");
        } catch (Exception $e) {
            Log::error("{{JobName}} failed: " . $e->getMessage());

            // Optionally release the job back to the queue to retry
            // $this->release(60);
        }
    }
}
```
