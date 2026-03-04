---
id: skill_inertia_page_scaffold
name: Inertia Page Scaffold
version: 1.0.0
description: Scaffolds Inertia/React pages and components matching the project's exact directory layout, shared layouts, and centralized API endpoint registry.
tags: [react, inertia, laravel, scaffolding, frontend]
permissions: [write_code]
---

# Inertia Page Scaffold

## Overview
Creates page and component files in the correct project directories, wired into existing layouts and utilities.

## Rules Engine

### 1. Directory Structure
| Type               | Path                                                    |
| ------------------ | ------------------------------------------------------- |
| Pages              | `resources/js/pages/<Feature>/<PageName>.jsx`           |
| Shared Components  | `resources/js/Components/<ComponentName>.jsx`           |
| Feature Components | `resources/js/Components/<Feature>/<ComponentName>.jsx` |
| Services           | `resources/js/services/<service-name>.js`               |
| Utilities          | `resources/js/utils/<util-name>.js`                     |

### 2. Page Template Rules
* Import `{ Head, Link }` or `{ Head, usePage, router }` from `@inertiajs/react`.
* Use shared layouts (e.g., `AuthLayout`) where appropriate.
* Export default the page component as a named function.
* Include JSDoc comment documenting props — **never** use `PropTypes` (disabled per ESLint config).
* Use Tailwind CSS v4 utility classes for styling.

### 3. API Endpoint Registration
When a page calls the backend:
* **Never** hardcode API URLs inline.
* Add new paths to `resources/js/utils/api-endpoints.js` following the existing pattern:
  ```js
  const WEB = '/api/web';
  const API = {
      newEndpoint: `${WEB}/new-endpoint`,
      newEndpointById: (id) => `${WEB}/new-endpoint/${id}`,
  };
  ```

### 4. Component Conventions
* Functional components only — no class components.
* Extract sub-widgets into separate component files (no `_build*` helpers inside a component).
* Use hooks for state and side effects.
* File names use PascalCase for components, kebab-case for services and utils.

### 5. Layout Usage
Existing shared layouts:
* `AuthLayout` — Gradient background with glass card, used for login/signup/reset pages.
* `Dashboard/DashboardLayout` — Sidebar + content area for authenticated pages.

When creating a new page, ask: "Does this page belong behind auth (Dashboard) or is it a public/auth page (AuthLayout)?"

## Page Template

```jsx
import { Head } from '@inertiajs/react';

/**
 * Feature description page.
 *
 * @param {object} props - Inertia page props.
 * @param {Array} props.items - List of items from the server.
 */
export default function FeaturePage({ items }) {
    return (
        <div className="min-h-screen bg-gray-50">
            <Head title="Feature Page" />
            <div className="max-w-4xl mx-auto py-12 px-4">
                <h1 className="text-2xl font-bold text-gray-900">Feature</h1>
                {/* Page content */}
            </div>
        </div>
    );
}
```

## Post-Scaffold Checklist
1. Create the Laravel controller method returning `Inertia::render('Feature/PageName', [...])`.
2. Add the web route in `routes/web.php`.
3. Register any new API endpoints in `resources/js/utils/api-endpoints.js`.

## Trigger
> "Create a page for …", "Add a dashboard page", "scaffold an Inertia page for …"
