---
id: skill_react_hook_extract
name: react-hook-extractor
version: 1.0.0
description: Extracts business or state logic from a component into a reusable custom hook.
tags: [refactor, hooks, clean-code]
permissions: [run_command]
---

# React Hook Extractor Skill

## Goal
To enforce "Thin Views" by moving state management and API calls from components into `use<Feature>` hooks.

## Instructions
1.  **Analyze**: Identify `useState`, `useEffect`, or API calls inside the provided component code.
2.  **Extraction**:
    * Create a new file `use<ComponentName>.ts` in a `hooks` or `logic` folder.
    * Move all identified logic into this hook.
    * Return only the necessary states and functions.
3.  **Refactor**:
    * Update the original component to call the new custom hook.
    * Destructure the returned values.
4.  **Verification**: Ensure no `useEffect` or complex logic remains in the `tsx` file except for event mapping.

## Example
* *Before*: `LoginForm.tsx` has 50 lines of validation and API logic.
* *After*: `useLoginForm.ts` contains the logic; `LoginForm.tsx` only contains the JSX and a call to the hook.