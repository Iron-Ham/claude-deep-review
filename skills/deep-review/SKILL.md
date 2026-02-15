---
name: deep-review
description: Run a comprehensive deep review combining architecture analysis, code review, error handling audit, type design analysis, comment verification, test coverage analysis, accessibility audit, localization review, concurrency analysis, performance analysis, code simplification, and platform-specific reviews (iOS, Android, TypeScript, Python, Rust, Go, Rails, Flutter). Platform reviewers are automatically included when relevant. Distinguishes between NEW issues (introduced by PR) and PRE-EXISTING issues (technical debt). Use when reviewing PR changes, before merging, or for thorough code quality assessment. Supports flags --pr, --branch, --changes for scope detection.
argument-hint: "[aspects] [--pr|--branch|--changes|path]"
---

# Deep Review Skill

Run a comprehensive deep review using a team of specialized agents covering architecture, code quality, error handling, types, comments, tests, accessibility, localization, concurrency, performance, and simplification.

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
| `full` | All cross-cutting aspects (does not include platform-specific) |

**Platform-specific aspects** (automatically included when relevant, or explicitly requested):

| Aspect | Description |
|--------|-------------|
| `ios` | Swift/SwiftUI/UIKit lifecycle, ARC, Apple APIs, App Store compliance |
| `android` | Activity/Fragment lifecycle, Compose, manifest, Android security |
| `ts-frontend` | React/Vue/Angular state, SSR/hydration, component patterns, browser APIs |
| `ts-backend` | Node.js event loop, middleware, ORM, auth, graceful shutdown, API design |
| `python` | Pythonic idioms, type hints, Django/FastAPI/Flask, packaging |
| `rust` | Ownership idioms, unsafe auditing, error handling, trait design |
| `go` | Go idioms, interface design, context propagation, module hygiene |
| `rails` | Rails conventions, ActiveRecord, migration safety, background jobs |
| `flutter` | Widget design, state management, Dart idioms, platform channels |
| `mobile` | ios + android |
| `ts` | ts-frontend + ts-backend |

Platform reviewers are **automatically included** when the team lead determines they are relevant based on the changed files and project context. For example, changing `.swift` files in an iOS project will include the iOS reviewer. The team lead uses its judgment to disambiguate — `.swift` in a macOS project won't trigger iOS, `.kt` in a Ktor server won't trigger Android. Users can also explicitly request platform aspects (e.g., `/deep-review ios`). Platform aspects are never included in `core` or `full` unless detected or explicitly requested.

**Usage examples:**
```
/deep-review                    # core review of PR changes (+ auto-detected platforms)
/deep-review --pr               # explicit PR scope (+ auto-detected platforms)
/deep-review --changes          # uncommitted changes only (+ auto-detected platforms)
/deep-review full --pr          # all cross-cutting agents on PR (+ auto-detected platforms)
/deep-review code errors        # specific aspects only (+ auto-detected platforms)
/deep-review types tests --pr   # type and test analysis of PR (+ auto-detected platforms)
/deep-review a11y --pr          # accessibility audit of PR
/deep-review l10n --pr          # localization review of PR
/deep-review concurrency --pr   # concurrency analysis of PR
/deep-review perf --pr          # performance analysis of PR
/deep-review ios --pr           # explicitly include iOS reviewer
/deep-review ts --pr            # both TypeScript frontend + backend reviewers
/deep-review mobile --pr        # iOS + Android reviewers
/deep-review python rust --pr   # explicitly include Python and Rust reviewers
/deep-review src/features       # analyze specific path (+ auto-detected platforms)
```

## Agent Dispatch Table

| Agent ID | Aspect | Model | Agent File |
|----------|--------|-------|------------|
| code-reviewer | code | opus | agents/code-reviewer.md |
| silent-failure-hunter | errors | inherit | agents/silent-failure-hunter.md |
| dependency-mapper | arch | inherit | agents/dependency-mapper.md |
| cycle-detector | arch | inherit | agents/cycle-detector.md |
| hotspot-analyzer | arch | inherit | agents/hotspot-analyzer.md |
| pattern-scout | arch | inherit | agents/pattern-scout.md |
| scale-assessor | arch | inherit | agents/scale-assessor.md |
| type-design-analyzer | types | inherit | agents/type-design-analyzer.md |
| comment-analyzer | comments | inherit | agents/comment-analyzer.md |
| test-analyzer | tests | inherit | agents/test-analyzer.md |
| code-simplifier | simplify | opus | agents/code-simplifier.md |
| accessibility-scanner | a11y | inherit | agents/accessibility-scanner.md |
| localization-scanner | l10n | inherit | agents/localization-scanner.md |
| concurrency-analyzer | concurrency | inherit | agents/concurrency-analyzer.md |
| performance-analyzer | perf | inherit | agents/performance-analyzer.md |
| ios-platform-reviewer | ios | inherit | agents/ios-platform-reviewer.md |
| android-platform-reviewer | android | inherit | agents/android-platform-reviewer.md |
| ts-frontend-reviewer | ts-frontend | inherit | agents/ts-frontend-reviewer.md |
| ts-backend-reviewer | ts-backend | inherit | agents/ts-backend-reviewer.md |
| python-reviewer | python | inherit | agents/python-reviewer.md |
| rust-reviewer | rust | inherit | agents/rust-reviewer.md |
| go-reviewer | go | inherit | agents/go-reviewer.md |
| rails-reviewer | rails | inherit | agents/rails-reviewer.md |
| flutter-reviewer | flutter | inherit | agents/flutter-reviewer.md |

All teammates use `subagent_type: "general-purpose"` (needed for file writing).

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

4. Build the scope context string (referred to as `SCOPE_CONTEXT` below):
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

### Phase 1.5: Determine Platform Reviewers

After obtaining the list of changed files, determine which platform-specific reviewers to include. Available platform reviewers and what they cover:

| Aspect | Covers |
|--------|--------|
| `ios` | Swift/SwiftUI/UIKit lifecycle, ARC, Apple APIs, App Store compliance |
| `android` | Activity/Fragment lifecycle, Compose, manifest, Android security |
| `ts-frontend` | React/Vue/Angular state, SSR/hydration, component patterns, browser APIs |
| `ts-backend` | Node.js event loop, middleware, ORM, auth, graceful shutdown, API design |
| `python` | Pythonic idioms, type hints, Django/FastAPI/Flask, packaging |
| `rust` | Ownership idioms, unsafe auditing, error handling, trait design |
| `go` | Go idioms, interface design, context propagation, module hygiene |
| `rails` | Rails conventions, ActiveRecord, migration safety, background jobs |
| `flutter` | Widget design, state management, Dart idioms, platform channels |

**If the user explicitly requested platform aspects** (e.g., `/deep-review ios`, `/deep-review python rust`), use those directly.

**If the user did not request any platform aspects**, look at the changed files and the project context to decide which platform reviewers are relevant. Use your judgment — examine file extensions, imports, build files, and project structure to determine the right reviewers. Be precise: `.swift` files in a macOS project should not trigger the iOS reviewer, `.kt` files in a Ktor server should not trigger Android, `.ts` files in an Express app should trigger `ts-backend` not `ts-frontend`, etc. When genuinely uncertain, skip rather than guess wrong — the user can always request a platform reviewer explicitly.

**Group alias expansion**:
- `mobile` → `ios`, `android`
- `ts` → `ts-frontend`, `ts-backend`

**Merge behavior**:
- Platform aspects are **added to** whatever cross-cutting aspects the user requested
- Platform aspects are never included in `core` or `full` expansion — they only come from auto-detection or explicit request
- Deduplicate: if auto-detection finds `ts-frontend` and the user also typed `ts`, only include `ts-frontend` once

### Phase 2: Determine Which Agents to Launch

Based on selected aspects (including any auto-detected platform aspects from Phase 1.5):

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
| `ios` | iOS Platform Reviewer |
| `android` | Android Platform Reviewer |
| `ts-frontend` | TypeScript Frontend Reviewer |
| `ts-backend` | TypeScript Backend Reviewer |
| `python` | Python Reviewer |
| `rust` | Rust Reviewer |
| `go` | Go Reviewer |
| `rails` | Rails Reviewer |
| `flutter` | Flutter Reviewer |

### Phase 3: Initialize Team and Launch Teammates

1. **Create results directory**:
   ```bash
   mkdir -p /tmp/deep-review-$(uuidgen | tr '[:upper:]' '[:lower:]')/
   ```
   Store the path as `REVIEW_DIR`.

2. **Create the team**:
   Use `TeamCreate` with name `"deep-review"`.

3. **Create tasks** for each selected agent:
   Use `TaskCreate` for each agent with:
   - Subject: `"Run {agent-display-name} analysis"`
   - Description: includes the output file path `{REVIEW_DIR}/{agent-id}.md`

4. **Spawn all analysis teammates in parallel**:
   For each selected agent, use the Task tool:
   - `subagent_type`: `"general-purpose"`
   - `model`: from dispatch table (`opus` or omit for inherit)
   - `team_name`: `"deep-review"`
   - `name`: `"{agent-id}"` (e.g., `"code-reviewer"`, `"cycle-detector"`)
   - `prompt`: use the Teammate Prompt Template below, filled in with the agent's details

### Phase 4: Monitor Task Completion

1. Wait for summary messages from all teammates (they will send a brief message via SendMessage when done)
2. Verify via `TaskList` that all analysis tasks show `"completed"`
3. For any tasks that did not complete, check if the output file exists anyway (partial findings are still valuable)
4. Build a gap report string listing any agents that failed to produce output

### Phase 5: Launch Synthesis Teammate

1. **Create a synthesis task**:
   Use `TaskCreate` with subject `"Synthesize findings into unified report"`.

2. **Spawn the synthesis teammate**:
   - `subagent_type`: `"general-purpose"`
   - `team_name`: `"deep-review"`
   - `name`: `"synthesizer"`
   - `prompt`: Include the following in the prompt:
     - Path to the synthesis instructions file: `agents/synthesizer.md`
     - The `REVIEW_DIR` path
     - The list of expected output files (one per agent that was launched)
     - The gap report (if any agents failed)
     - The scope description (for the report header)
     - Instruction to write the final report to `{REVIEW_DIR}/REPORT.md`
     - Instruction to mark the synthesis task as completed and send a message to `"team-lead"` when done

3. Wait for the synthesis teammate to complete.

### Phase 6: Present Report and Cleanup

1. **Read the report**: Read `{REVIEW_DIR}/REPORT.md` and present its contents to the user
2. **Shutdown teammates**: Send shutdown requests to all teammates
3. **Clean up team**: Use `TeamDelete` to clean up team infrastructure
4. **Inform the user**: Let them know individual agent findings are available at `{REVIEW_DIR}/` for detailed inspection

## Teammate Prompt Template

This is the standardized prompt given to each analysis teammate. Fill in the placeholders before sending.

```
You are a specialized code analysis agent on the "deep-review" team.

## Your Task

1. Read your analysis instructions from: {AGENT_FILE_PATH}
   (This is relative to the skill directory. Use the Read tool to read the file.)
2. Analyze the code following those instructions
3. Write your complete findings to: {OUTPUT_FILE_PATH}
4. Mark your task as completed via TaskUpdate (task ID: {TASK_ID})
5. Send a brief summary to "team-lead" via SendMessage
   - Include only counts (e.g., "Found 3 critical, 2 important new issues; 5 pre-existing issues")
   - Do NOT include detailed findings in the message — they are in the output file

## Scope Context

{SCOPE_CONTEXT}

Note: Your analysis instructions reference `{SCOPE_CONTEXT}`.
This refers to the Scope Context provided directly above — use it as-is.

## Output File Format

Write your findings as a markdown file. Start with a heading identifying the agent,
then list all findings using the output format specified in your analysis instructions.

## Classification Rules

When classifying issues as [NEW] or [PRE-EXISTING], use the changed line ranges
provided in the Scope Context above. Issues in changed lines are [NEW]; all others
are [PRE-EXISTING].

## Error Handling

If you encounter errors during analysis (e.g., files not found, permission issues):
- Write partial findings to the output file along with an ERROR section describing what went wrong
- Mark the task as completed anyway (so the pipeline is not blocked)
- Note the error in your summary message to team-lead

## Important

- Do NOT modify any source code files — this is a READ-ONLY analysis
- Write your findings ONLY to the output file path specified above
- Be thorough but focused — quality over quantity
```

## Tips

- Run `/deep-review --pr` before creating a PR to catch issues early
- Use `core` (default) for quick essential checks
- Use `full` for comprehensive review before major merges
- **Focus on [NEW] issues** - these must be fixed before merge
- **[PRE-EXISTING] issues** are technical debt to track, not PR blockers
- Re-run after fixes to verify resolution
- Use specific aspects (e.g., `types tests`) when you know the concern
- Platform reviewers are automatically included when relevant — no need to specify them manually
- Use `mobile`, `ts`, or explicit platform names (e.g., `ios`, `python`) to force specific platform reviewers
- Create follow-up tickets for critical pre-existing issues discovered during review
- Individual agent findings are available in `/tmp/deep-review-*/` for detailed inspection
