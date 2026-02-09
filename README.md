# Claude Deep Review

A comprehensive code review skill for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that combines architecture analysis, code review, error handling audit, type design analysis, comment verification, test coverage analysis, accessibility audit, localization review, concurrency analysis, performance analysis, and code simplification into a single command.

## Features

- **15 specialized review agents** running in parallel for thorough analysis
- **Flexible scope detection** - review PR changes, uncommitted work, or specific paths
- **Modular aspects** - run all agents or select specific review types
- **Prioritized output** - issues categorized as Critical, Important, or Suggestions
- **Architecture health assessment** - dependency mapping, cycle detection, hotspot analysis
- **Standalone** - no dependencies on other plugins

## Installation

### Option 1: Plugin marketplace (recommended)

```bash
# Add the marketplace
/plugin marketplace add Iron-Ham/claude-deep-review

# Install the plugin
/plugin install deep-review@claude-deep-review
```

To update later:

```bash
/plugin marketplace update
```

### Option 2: Clone to skills directory

```bash
# Clone to your global skills directory
git clone https://github.com/Iron-Ham/claude-deep-review.git ~/.claude/skills/deep-review
```

### Option 3: Project-specific installation

```bash
# Clone to a specific project's skills directory
git clone https://github.com/Iron-Ham/claude-deep-review.git /path/to/your/project/.claude/skills/deep-review
```

## Usage

### Basic Usage

```bash
# Review current PR/branch changes (default)
/deep-review

# Explicit PR scope
/deep-review --pr

# Review uncommitted changes only
/deep-review --changes

# Review a specific path
/deep-review src/features
```

### Selecting Review Aspects

```bash
# Full review with all 15 agents
/deep-review full

# Code quality + error handling only
/deep-review code errors

# Type design + test coverage analysis
/deep-review types tests

# Architecture analysis only
/deep-review arch

# Performance analysis
/deep-review perf

# Code simplification suggestions
/deep-review simplify
```

### Combined Examples

```bash
# Full review of PR changes
/deep-review full --pr

# Quick core review of uncommitted changes
/deep-review --changes

# Type and test analysis of specific directory
/deep-review types tests src/models

# Accessibility audit of PR
/deep-review a11y --pr

# Performance analysis of PR
/deep-review perf --pr
```

## Review Aspects

| Aspect | Description | Agents |
|--------|-------------|--------|
| `core` | Essential quality checks (default) | Code Reviewer, Silent Failure Hunter, 5 Architecture agents |
| `full` | Complete comprehensive review | All 15 agents |
| `code` | CLAUDE.md compliance, bugs, quality | Code Reviewer |
| `errors` | Silent failures, catch blocks | Silent Failure Hunter |
| `arch` | Dependencies, cycles, hotspots, patterns, scale | 5 Architecture agents |
| `types` | Type invariants, encapsulation | Type Design Analyzer |
| `comments` | Comment accuracy, rot detection | Comment Analyzer |
| `tests` | Test coverage, quality, gaps | Test Analyzer |
| `simplify` | Code clarity, refactoring | Code Simplifier |
| `a11y` | WCAG compliance, ARIA, keyboard nav, screen readers | Accessibility Scanner |
| `l10n` | Hardcoded strings, i18n readiness, locale handling, RTL | Localization Scanner |
| `concurrency` | Race conditions, deadlocks, thread safety, async pitfalls | Concurrency Analyzer |
| `perf` | Algorithmic complexity, allocations, caching, rendering, N+1 queries | Performance Analyzer |

## Agents

### Code Quality Agents

- **Code Reviewer** - Reviews code against project guidelines (CLAUDE.md), detects bugs, security vulnerabilities, and quality issues. Only reports issues with confidence ≥80%.

- **Silent Failure Hunter** - Audits error handling for silent failures, inadequate catch blocks, and missing user feedback. Zero tolerance for swallowed errors.

### Architecture Agents

- **Dependency Mapper** - Maps module dependencies, identifies layers, flags violations and high fan-in/fan-out modules.

- **Cycle Detector** - Finds circular dependencies and bidirectional imports that create maintenance nightmares.

- **Hotspot Analyzer** - Identifies coupling hotspots, "god modules," and files that are too large.

- **Pattern Scout** - Checks for consistency in conventions across modules, identifies drift.

- **Scale Assessor** - Identifies scalability risks as the codebase grows.

### Specialized Agents

- **Type Design Analyzer** - Evaluates type designs for invariant strength, encapsulation, and enforcement. Rates each aspect 1-10.

- **Comment Analyzer** - Verifies comment accuracy, identifies rot, and flags misleading documentation.

- **Test Analyzer** - Reviews test coverage quality, identifies critical gaps, and flags anti-patterns.

- **Code Simplifier** - Suggests simplifications for clarity and maintainability while preserving functionality.

- **Accessibility Scanner** - Audits code for WCAG 2.2 compliance, ARIA correctness, keyboard navigation, screen reader support, and assistive technology compatibility.

- **Localization Scanner** - Identifies hardcoded strings, locale-unsafe operations, broken pluralization, and i18n/l10n gaps that would degrade the experience for international users.

- **Concurrency Analyzer** - Detects race conditions, deadlocks, thread-safety violations, async/await pitfalls, and concurrency model mismatches across languages and frameworks.

- **Performance Analyzer** - Identifies algorithmic complexity issues, excessive allocations, N+1 queries, rendering bottlenecks, bundle bloat, and missed caching/parallelization opportunities.

## Output Format

The skill produces a synthesized report with:

1. **Executive Summary** - Scope, agents run, issue counts
2. **New Issues** (from this PR) - Critical (🔴), Important (🟠), Suggestions (🟡)
3. **Pre-existing Issues** (technical debt) - Tracked separately, do not block merge
4. **Architecture Health** - Table of checks with pass/fail
5. **Strengths** - What's done well
6. **Action Plan** - Prioritized next steps

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- Git (for scope detection)

## How It Works

1. **Scope Detection** - Determines which files to analyze based on flags (`--pr`, `--changes`) or path argument

2. **Agent Selection** - Selects which agents to run based on specified aspects

3. **Parallel Execution** - Launches all applicable agents simultaneously using Claude Code's Task tool

4. **Synthesis** - Aggregates results from all agents into a prioritized, actionable report

## Project Structure

```
claude-deep-review/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest
│   └── marketplace.json         # Marketplace catalog
├── skills/
│   └── deep-review/
│       ├── SKILL.md             # Skill orchestration
│       └── agents/              # Agent definitions (loaded on-demand)
│           ├── code-reviewer.md
│           ├── silent-failure-hunter.md
│           ├── dependency-mapper.md
│           ├── cycle-detector.md
│           ├── hotspot-analyzer.md
│           ├── pattern-scout.md
│           ├── scale-assessor.md
│           ├── type-design-analyzer.md
│           ├── comment-analyzer.md
│           ├── test-analyzer.md
│           ├── code-simplifier.md
│           ├── accessibility-scanner.md
│           ├── localization-scanner.md
│           ├── concurrency-analyzer.md
│           └── performance-analyzer.md
├── README.md
└── LICENSE
```

## Tips

- Run `/deep-review` before creating a PR to catch issues early
- Use `core` (default) for quick essential checks during development
- Use `full` before major merges or releases
- **Focus on [NEW] issues** - these must be fixed before merge
- **[PRE-EXISTING] issues** are technical debt to track, not PR blockers
- Re-run after fixes to verify resolution

## License

MIT

## Contributing

Contributions welcome! Please open an issue or PR.
