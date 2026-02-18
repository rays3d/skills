---
name: organize_documentation
description: Reorganizes a documentation folder into a standardized, navigable structure with consistent naming and metadata.
---

# Organize Documentation Skill

This skill guides you through the process of auditing, restructuring, and standardizing a documentation directory. Use this when a project's documentation has become cluttered, inconsistent, or difficult to navigate.

## 1. Analysis Phase

Before moving any files, you must understand the current state of the documentation.

1.  **List all files**: Run a recursive list command to see the full depth of the `docs/` directory.
    -   *Windows*: `Get-ChildItem -Recurse -File -Path docs/`
    -   *Linux/Mac*: `find docs/ -type f`
2.  **Identify Categories**: robust documentation typically falls into these high-level buckets:
    -   `getting-started/`: Setup, installation, deployment, IDE config.
    -   `architecture/`: High-level design, patterns, diagrams, core systems.
    -   `features/`: Specific functionality (e.g., `auth/`, `billing/`, `admin/`).
    -   `testing/`: Test plans, standards, guides, coverage reports.
    -   `reports/`: Point-in-time audits, reviews, post-mortems.
    -   `archive/`: Deprecated or legacy content.
3.  **Check for Renaming**: Look for inconsistent naming (e.g., `My_File.md` vs `my-file.md`). The standard is **kebab-case** (`my-file-name.md`).

## 2. Planning Phase

Create a mapping of old paths to new paths.

1.  **Create a Plan**: Write a mapping list (e.g., in a temporary file or scratchpad).
    -   `old/path/weird_name.md` -> `new/category/clean-name.md`
2.  **Verify Destinations**: Ensure the new categories make sense for the content.
3.  **Review**: If listing a large number of moves, ask the user for a quick review of the high-level categories.

## 3. Execution Phase

Use a script to perform the moves to ensure consistency and prevent manual errors.

### Script Template (PowerShell)

Create a script named `organize_docs.ps1` with this structure:

### Script Template (PowerShell)

A template script is available at `scripts/organize_template.ps1`.

1.  **Copy the Script**: Copy `scripts/organize_template.ps1` to your project's `scripts/` directory or root.
2.  **Edit the Script**:
    -   Update `$baseDir` to point to your `docs/` folder.
    -   Update `$mapping` with your file moves.
3.  **Run the Script**: `.\organize_template.ps1`

## 4. Verification & Indexing Phase

1.  **Verify Structure**: Run the list command/tree command again to confirm the new layout.
2.  **Create Index**: Create or update `docs/README.md`.
    -   It should serve as a table of contents.
    -   Link to the high-level categories (e.g., `[Getting Started](./getting-started)`).
3.  **Fix Links**: Search for relative links (`[Link](../old/path)`) that might have broken.
    -   *Technique*: Use grep/search to find `](` patterns in markdown files.
    -   Update them to point to the new locations.
