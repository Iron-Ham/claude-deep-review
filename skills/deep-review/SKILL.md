---
name: deep-review
description: Run a comprehensive deep review combining architecture analysis, code review, error handling audit, type design analysis, comment verification, test coverage analysis, accessibility audit, localization review, concurrency analysis, performance analysis, and code simplification. Distinguishes between NEW issues (introduced by PR) and PRE-EXISTING issues (technical debt). Use when reviewing PR changes, before merging, or for thorough code quality assessment. Supports flags --pr, --branch, --changes for scope detection.
argument-hint: "[aspects] [--pr|--branch|--changes|path]"
---

# Deep Review Skill

Run a comprehensive deep review using parallel specialized agents covering architecture, code quality, error handling, types, comments, tests, accessibility, localization, concurrency, performance, and simplification.

## When to Use

- Before creating or merging a PR
- After completing a feature branch
- For thorough code quality assessment
- To identify technical debt and architectural issues
- When you want a complete picture of code health

## Issue Classification

When reviewing PR changes, all issues are classified as:

- **[NEW]**: Issues in code **added or modified** by this PR. These must be addressed before merge.
- **[PRE-EXISTING]**: Issues in code **not changed** by this PR. These are technical debt observations that should not block the PR but are valuable to track.

This distinction helps reviewers focus on what's actionable for the current PR while still surfacing important context about surrounding code quality.

## Scope Detection

Determine the analysis scope from flags or arguments:

1. **If `--pr` or `--branch` flag provided**:
   - Detect base branch: check for `main`, then `master`, or use `git merge-base`
   - Run `git diff --name-only <base>...HEAD` to get all files changed in this branch
   - Analyze those files and their immediate dependencies

2. **If `--changes` flag provided**:
   - Run `git diff --name-only HEAD` and `git diff --name-only --cached` for uncommitted changes
   - Analyze those files and their immediate dependencies

3. **If path argument provided** (e.g., `/deep-review src/features`):
   - Analyze only that path

4. **If no arguments**:
   - Default to `--pr` behavior (analyze current branch changes)

## Review Aspects

Select which aspects to review. Default is `core` (code + errors + arch).

| Aspect | Description |
|--------|-------------|
| `code` | CLAUDE.md compliance, bugs, code quality |
| `errors` | Silent failures, catch blocks, error handling |
| `arch` | Dependencies, cycles, hotspots, patterns, scale |
| `types` | Type invariants, encapsulation, design quality |
| `comments` | Comment accuracy, rot, maintainability |
| `tests` | Test coverage, quality, critical gaps |
| `simplify` | Code clarity, refactoring opportunities |
| `a11y` | WCAG compliance, ARIA, keyboard nav, screen readers |
| `l10n` | Hardcoded strings, i18n readiness, locale handling, RTL |
| `concurrency` | Race conditions, deadlocks, thread safety, async pitfalls |
| `perf` | Algorithmic complexity, allocations, caching, rendering, N+1 queries |
| `core` | code + errors + arch (default) |
| `full` | All aspects |

**Usage examples:**
```
/deep-review                    # core review of PR changes
/deep-review --pr               # explicit PR scope
/deep-review --changes          # uncommitted changes only
/deep-review full --pr          # all agents on PR changes
/deep-review code errors        # specific aspects only
/deep-review types tests --pr   # type and test analysis of PR
/deep-review a11y --pr          # accessibility audit of PR
/deep-review l10n --pr          # localization review of PR
/deep-review concurrency --pr   # concurrency analysis of PR
/deep-review perf --pr          # performance analysis of PR
/deep-review src/features       # analyze specific path
```

## Instructions

### Phase 1: Determine Scope

1. Parse arguments to extract:
   - Scope flag: `--pr`, `--branch`, `--changes`, or path
   - Aspects: list of aspects or `core`/`full`

2. Get changed files based on scope:
   ```bash
   # For --pr/--branch (detect base branch first)
   BASE=$(git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null || echo "HEAD~10")
   git diff --name-only $BASE...HEAD

   # For --changes
   git diff --name-only HEAD
   git diff --name-only --cached
   ```

3. **Get detailed diff with line numbers** (for distinguishing new vs pre-existing issues):
   ```bash
   # Get the unified diff showing which lines were added/modified
   git diff $BASE...HEAD --unified=0 | grep -E '^@@|^diff --git'
   ```
   This output shows the exact line ranges that were changed. Parse it to build a map of `{file: [changed_line_ranges]}`.

4. Build the scope context string:
   ```
   SCOPE: Focus analysis on these files and their direct dependencies:
   {list of changed files}

   CHANGED LINE RANGES (for classifying issues):
   {file1}: lines {start1}-{end1}, {start2}-{end2}, ...
   {file2}: lines {start1}-{end1}, ...

   IMPORTANT - Issue Classification:
   When reporting issues, you MUST classify each issue as one of:
   - **[NEW]**: Issue is in code that was ADDED or MODIFIED in this PR (within the changed line ranges above)
   - **[PRE-EXISTING]**: Issue is in code that was NOT changed by this PR (outside the changed line ranges)

   This distinction is critical for PR review. New issues should be fixed before merge.
   Pre-existing issues are technical debt to track but should not block the PR.
   ```

### Phase 2: Determine Which Agents to Launch

Based on selected aspects:

| Aspect | Agents to Launch |
|--------|-----------------|
| `core` | Code Reviewer, Silent Failure Hunter, all 5 Architecture agents |
| `full` | All agents below |
| `code` | Code Reviewer |
| `errors` | Silent Failure Hunter |
| `arch` | Dependency Mapper, Cycle Detector, Hotspot Analyzer, Pattern Scout, Scale Assessor |
| `types` | Type Design Analyzer |
| `comments` | Comment Analyzer |
| `tests` | Test Analyzer |
| `simplify` | Code Simplifier |
| `a11y` | Accessibility Scanner |
| `l10n` | Localization Scanner |
| `concurrency` | Concurrency Analyzer |
| `perf` | Performance Analyzer |

### Phase 3: Launch Parallel Agents

Launch all applicable agents in parallel using the Task tool. Include the scope context in each prompt.

For each agent, read its definition from the corresponding file in the `agents/` directory to get the Task tool parameters and prompt:

| Agent | Definition |
|-------|------------|
| Code Reviewer | [agents/code-reviewer.md](agents/code-reviewer.md) |
| Silent Failure Hunter | [agents/silent-failure-hunter.md](agents/silent-failure-hunter.md) |
| Dependency Mapper | [agents/dependency-mapper.md](agents/dependency-mapper.md) |
| Cycle Detector | [agents/cycle-detector.md](agents/cycle-detector.md) |
| Hotspot Analyzer | [agents/hotspot-analyzer.md](agents/hotspot-analyzer.md) |
| Pattern Scout | [agents/pattern-scout.md](agents/pattern-scout.md) |
| Scale Assessor | [agents/scale-assessor.md](agents/scale-assessor.md) |
| Type Design Analyzer | [agents/type-design-analyzer.md](agents/type-design-analyzer.md) |
| Comment Analyzer | [agents/comment-analyzer.md](agents/comment-analyzer.md) |
| Test Analyzer | [agents/test-analyzer.md](agents/test-analyzer.md) |
| Code Simplifier | [agents/code-simplifier.md](agents/code-simplifier.md) |
| Accessibility Scanner | [agents/accessibility-scanner.md](agents/accessibility-scanner.md) |
| Localization Scanner | [agents/localization-scanner.md](agents/localization-scanner.md) |
| Concurrency Analyzer | [agents/concurrency-analyzer.md](agents/concurrency-analyzer.md) |
| Performance Analyzer | [agents/performance-analyzer.md](agents/performance-analyzer.md) |

---

## Phase 4: Synthesize Results

After all agents complete, create a unified report:

```markdown
## Deep Review: {branch-name or scope}

### Executive Summary
- **Scope**: {X files analyzed}
- **Agents Run**: {list}
- **New Issues (from this PR)**: {critical count} critical, {important count} important
- **Pre-existing Issues (technical debt)**: {critical count} critical, {important count} important

---

## 🆕 NEW ISSUES (Introduced by this PR)

These issues are in code that was added or modified in this PR. **Address before merge.**

### Critical Issues (must fix)

#### 🔴 {Issue Title}
- **Source**: {agent-name}
- **Location**: `{file:line}`
- **Details**: {description}
- **Fix**: {recommendation}

### Important Issues (should fix)

#### 🟠 {Issue Title}
- **Source**: {agent-name}
- **Location**: `{file:line}`
- **Details**: {description}
- **Fix**: {recommendation}

### Suggestions

#### 🟡 {Suggestion Title}
- **Source**: {agent-name}
- **Location**: `{file:line}`
- **Details**: {description}

---

## 📋 PRE-EXISTING ISSUES (Technical Debt)

These issues exist in code that was **not changed** by this PR. They are important to track but **should not block merge**.

### Critical (track for future fix)

#### 🔴 {Issue Title}
- **Source**: {agent-name}
- **Location**: `{file:line}`
- **Details**: {description}
- **Suggested fix**: {recommendation}

### Important (track for future fix)

#### 🟠 {Issue Title}
- **Source**: {agent-name}
- **Location**: `{file:line}`
- **Details**: {description}

---

### Architecture Health

| Check | Status | Notes |
|-------|--------|-------|
| No circular dependencies | ✅ / ❌ | ... |
| Clean layer boundaries | ✅ / ❌ | ... |
| No god modules | ✅ / ❌ | ... |
| Consistent patterns | ✅ / ❌ | ... |
| Scalable structure | ✅ / ❌ | ... |
| Accessibility | ✅ / ❌ | ... |
| Localization readiness | ✅ / ❌ | ... |
| Concurrency safety | ✅ / ❌ | ... |
| Performance efficiency | ✅ / ❌ | ... |

---

### Strengths
- {What's done well in this code}

---

### Action Plan

1. **Before merge** (new critical/important issues):
   - {specific fixes needed for code introduced by this PR}

2. **Technical debt to track** (pre-existing issues):
   - {critical pre-existing issues to create tickets for}
   - {important pre-existing issues to address in future work}

3. **Nice to have** (suggestions):
   - {improvements for later}
```

## Tips

- Run `/deep-review --pr` before creating a PR to catch issues early
- Use `core` (default) for quick essential checks
- Use `full` for comprehensive review before major merges
- **Focus on [NEW] issues** - these must be fixed before merge
- **[PRE-EXISTING] issues** are technical debt to track, not PR blockers
- Re-run after fixes to verify resolution
- Use specific aspects (e.g., `types tests`) when you know the concern
- Create follow-up tickets for critical pre-existing issues discovered during review
