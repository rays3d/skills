---
id: skill_git_smart_commit_react
name: git-smart-commit-react
version: 1.1.0
description: Staging and committing React project changes using Conventional Commits. Triggers on "commit", "save work", or "git save".
tags: [git, react, workflow, productivity]
permissions: [run_command]
---

# Smart Committer Skill (React Optimized)

## Goal
To maintain a professional, searchable git history by adhering to **Conventional Commits** specifically tailored for React and modern frontend ecosystems.

## Instructions
1.  **Status Check**: Run `git status` to identify modified files (TSX, CSS, hooks).
2.  **Staging**:
    * If files are specified (e.g., "commit the navbar"), `git add` those specifically.
    * If unspecified, ask: "Stage all changes?" or run `git add .` if intent is a full save.
3.  **Diff Analysis**: Run `git diff --staged` to analyze JSX, Hook logic, or Style changes.
4.  **Message Generation**:
    * **Format**: `<type>(<scope>): <description>`
    * **Types**:
        * `feat`: New components, hooks, or pages.
        * `fix`: Resolving UI bugs, logic errors, or broken hooks.
        * `style`: Changes that do not affect logic (CSS/SCSS, Prettier formatting).
        * `refactor`: Extracting logic to hooks or splitting components.
        * `perf`: Improvements to re-render cycles or bundle size.
        * `test`: Adding or updating Vitest/Jest files.
        * `chore`: Updating `package.json`, `eslint`, or build configs.
    * **Scope**: The specific area affected (e.g., `hooks`, `ui`, `auth`, `api`, `deps`).
    * **Description**: Lowercase, imperative mood (e.g., "add", "remove", "fix").
5.  **Execution**: Run `git commit -m "..."`.

## Example
* **Change**: Extracted API call from `Profile.tsx` to `useUser.ts`.
* **Command**: `git commit -m "refactor(hooks): extract profile fetching logic to useUser hook"`

* **Change**: Fixed a flexbox alignment issue in the Header.
* **Command**: `git commit -m "style(ui): fix header navigation alignment"`