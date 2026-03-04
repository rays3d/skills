---
id: skill_api_message_manager
name: API Message Manager
version: 1.0.0
description: Enforces the centralized ApiMessages constant class convention instead of using raw strings in responses or logs.
tags: [laravel, backend, constants, convention]
permissions: [read_file, write_file, execute_terminal]
---

# API Message Manager

## Overview

In `medispherexr`, the `App\Constants\ApiMessages` class acts as the single source of truth for all API response strings, logging statements, and email subjects.

**Raw string literals MUST NOT be used in controllers, services, policies, or event handlers when returning JSON responses via `ResponseHelper` or logging failures.**

## Capabilities

### Update `ApiMessages` For a New Entity

**Trigger:** The user generates a new feature or controller, or explicitly asks "/apimessages <Entity>"
**Prerequisites:** None.

**Actions:**
1. Opens `app/Constants/ApiMessages.php`.
2. Locates the correct section or adds a new headed comment block (`// <Entity> Messages`).
3. Appends the standard checklist of success, failure, and logging strings.

## Standard Action String Rules

When adding strings for an entity (e.g., `Device`), append the following standard formats to `app/Constants/ApiMessages.php`:

```php
    // Device Messages
    public const string DEVICES_RETRIEVED = 'Devices retrieved successfully';

    public const string DEVICE_RETRIEVED = 'Device fetched successfully';
    public const string DEVICE_RETRIEVE_FAILED = 'Failed to retrieve device';

    public const string DEVICE_CREATED = 'Device created successfully';
    public const string DEVICE_CREATE_FAILED = 'Failed to create device';

    public const string DEVICE_UPDATED = 'Device updated successfully';
    public const string DEVICE_UPDATE_FAILED = 'Failed to update device';

    public const string DEVICE_DELETED = 'Device deleted successfully';
    public const string DEVICE_DELETE_FAILED = 'Failed to delete device';

    public const string DEVICE_NOT_FOUND = 'Device not found';
    public const string DEVICE_ACCESS_DENIED = 'You do not have access to this device';

    // Logging only (never exposed to user)
    public const string LOG_DEVICE_CREATE_FAILED = 'Device creation failed';
    public const string LOG_DEVICE_UPDATE_FAILED = 'Device update failed';
    public const string LOG_DEVICE_DELETE_FAILED = 'Device deletion failed';
```

## Guardrails

- Ensure variables are named in `UPPER_SNAKE_CASE`.
- Do not repeat `string` multiple times in a single declaration or declare without access modifiers. Always use `public const string` (PHP 8.3 Typed Class Constants).
