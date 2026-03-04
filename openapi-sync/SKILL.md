---
id: skill_openapi_sync
name: OpenAPI Sync
version: 1.0.0
description: Keeps openapi.yaml in sync with routes/api.php. Detects undocumented endpoints, orphaned spec entries, and response schema drift.
tags: [openapi, api, documentation, sync]
permissions: [read_code, write_code]
---

# OpenAPI Sync

## Overview
Cross-references `routes/api.php` with `openapi.yaml` to surface drift between the live API and its documentation.

## Rules Engine

### 1. Route Extraction
* Parse `routes/api.php` for all `Route::get|post|put|patch|delete` calls.
* Respect route prefixes (`web`, `mobile`) to build full paths like `/api/web/login`.
* Respect middleware groups to determine auth requirements (`auth:sanctum` → `bearerAuth` security scheme).

### 2. Spec Cross-Reference
For each route extracted:
* **Missing from spec** → Flag as "Undocumented endpoint".
* **Present in spec but not in routes** → Flag as "Orphaned spec path — endpoint removed?".

### 3. Response Schema Enforcement
All API responses must follow the `ResponseHelper` envelope:

**Success:**
```yaml
type: object
properties:
  success:
    type: boolean
    example: true
  message:
    type: string
  data:
    type: object
```

**Paginated:**
```yaml
data:
  type: object
  properties:
    items:
      type: array
    pagination:
      type: object
      properties:
        total: { type: integer }
        perPage: { type: integer }
        currentPage: { type: integer }
        lastPage: { type: integer }
        from: { type: integer }
        to: { type: integer }
        hasMore: { type: boolean }
```

**Error:**
```yaml
type: object
properties:
  success:
    type: boolean
    example: false
  message:
    type: string
  errors:
    type: object
```

### 4. Request Body Validation
* Cross-reference `FormRequest::rules()` with the spec's `requestBody.content.application/json.schema.properties`.
* Flag fields present in one but not the other.

## Workflow
1. Run the sync check and produce a report listing: undocumented, orphaned, and schema mismatches.
2. For undocumented endpoints, generate a YAML stub matching the `ResponseHelper` envelope.
3. For orphaned paths, suggest removal from the spec.

## Trigger
> "Sync my OpenAPI spec", "Check API docs", "Are my API docs up to date?"
