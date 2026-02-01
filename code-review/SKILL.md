---
id: skill_code_review
name: code-review
version: 1.0.0
description: Reviews code changes for bugs, style issues, and best practices. Use when reviewing PRs or checking code quality.
tags: [code_quality, review, best_practices]
permissions: [read_code]
---

# Code Review Skill

When reviewing code, follow these steps:

## Review checklist

1. **Correctness**: Does the code do what it's supposed to?
2. **Edge cases**: Are error conditions handled?
3. **Style**: Does it follow project conventions and `very_good_analysis`?
4. **Stack Alignment**:
    *   **Riverpod** only (No `Provider` package).
    *   **GoRouter** only (No `Navigator` push/pop).
    *   **Laravel 12**: Ensure `Service` layer usage (No logic in Controllers).
5. **Performance**: Are there obvious inefficiencies?

## How to provide feedback

- Be specific about what needs to change
- Explain why, not just what
- Suggest alternatives when possible
