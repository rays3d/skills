---
id: skill_react_lint_fix
name: react-lint-fix
version: 1.0.0
description: Automatically detects and fixes React/JS linting issues using ESLint. Triggers when the user says "lint", "fix styles", or "clean up code".
tags: [eslint, react, productivity, quality]
permissions: [run_command]
---

# React Lint Fixer Skill

## Goal
To maintain code health and consistency by automatically resolving "fixable" ESLint violations according to project standards.

## Instructions
1.  **Environment Check**: Verify if `node_modules` and `.eslintrc` files exist.
2.  **Lint Analysis**: Run `npx eslint .` to identify current errors and warnings.
3.  **Auto-Correction**:
    * Execute `npx eslint . --fix` to resolve standard violations (spacing, quotes, semicolons, etc.).
    * If specific files are mentioned (e.g., "fix linting in Navbar.tsx"), run `npx eslint <path_to_file> --fix`.
4.  **Verification**:
    * Run `npx eslint .` again after the fix command.
    * **Pass**: If no errors remain, report: "Codebase cleaned successfully."
    * **Fail**: If errors persist (e.g., complex React Hook violations), list the remaining files and issues for manual intervention.
5.  **Review Summary**:
    * Briefly state how many files were modified.
    * Highlight any critical errors that the `--fix` flag could not handle (e.g., `useEffect` missing dependencies).

## Example
* *Trigger:* "Clean up the linting issues in my project."
* *Action:* Runs `npx eslint . --fix`.
* *Output:* "Applied 12 automatic fixes across 3 files. Remaining: 1 error in `AuthService.ts` (unused variable)."