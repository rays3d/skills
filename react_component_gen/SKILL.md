---
id: skill_react_component_gen
name: react-component-generator
version: 1.0.0
description: Generates a React component folder with a functional component, styles, and a test file.
tags: [react, scaffolding, productivity]
permissions: [run_command]
---

# React Component Generator Skill

## Goal
To maintain a consistent "Feature-First" architecture by scaffolding component folders instead of single files.

## Instructions
1.  **Path Resolution**: Determine the target directory (default to `src/presentation/components` if not specified).
2.  **Naming**: Convert the user's name to PascalCase (e.g., "login form" -> `LoginForm`).
3.  **File Creation**: Create a folder named `<ComponentName>` containing:
    * `<ComponentName>.tsx`: A functional component using `React.FC`.
    * `<ComponentName>.module.css` (or `.scss`): Scoped styles.
    * `<ComponentName>.test.tsx`: A basic Vitest/Jest render test.
4.  **Boilerplate**:
    * Use **Functional Components** with hooks.
    * Ensure all UI logic is extracted to separate helper classes or hooks if complex.
5.  **Summary**: Report the directory structure created.

## Example
* *Input*: "Create a button component in the shared folder."
* *Action*: Creates `src/presentation/components/shared/Button/` with all three files.