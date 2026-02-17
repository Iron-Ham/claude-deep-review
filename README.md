# Claude Deep Review

A comprehensive code review skill for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that combines architecture analysis, code review, error handling audit, type design analysis, comment verification, test coverage analysis, accessibility audit, localization review, concurrency analysis, performance analysis, and code simplification into a single command.

## Features

- **45 specialized review agents** running in parallel via team-based orchestration
- **File-based data flow** — agent findings written to files, keeping context windows lightweight
- **Dedicated synthesis** — a separate agent merges all findings with a fresh context window
- **Flexible scope detection** — review PR changes, uncommitted work, or specific paths
- **Modular aspects** — run all agents or select specific review types
- **Prioritized output** — issues categorized as Critical, Important, or Suggestions
- **Architecture health assessment** — dependency mapping, cycle detection, hotspot analysis
- **Graceful partial failure** — if some agents fail, the report notes gaps without blocking
- **Standalone** — no dependencies on other plugins

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
# Full review with all cross-cutting agents (+ auto-detected platforms)
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

### Platform-Specific Reviews

```bash
# Explicitly include iOS reviewer
/deep-review ios --pr

# iOS + macOS reviewers
/deep-review apple --pr

# Both TypeScript frontend + backend reviewers
/deep-review ts --pr

# iOS + Android reviewers
/deep-review mobile --pr

# Next.js reviewer (Server Components, App Router)
/deep-review nextjs --pr

# Vue.js reviewer (Composition API, Nuxt)
/deep-review vue --pr

# Django reviewer (ORM, DRF, migrations)
/deep-review django --pr

# Angular reviewer (RxJS, DI, change detection)
/deep-review angular --pr

# Docker + Kubernetes reviewers
/deep-review containers --pr

# GraphQL reviewer (schema, resolvers, security)
/deep-review graphql --pr

# Terraform + Shell reviewers
/deep-review infra --pr

# Python and Rust reviewers
/deep-review python rust --pr
```

Platform reviewers are also **automatically included** when the changed files are relevant to a specific platform. For example, running `/deep-review` on a project with iOS Swift changes will include the iOS reviewer. The system uses its judgment to disambiguate — `.swift` files in a macOS project trigger the macOS reviewer (not iOS), `.vue` files trigger the Vue reviewer, `angular.json` projects trigger Angular, `Dockerfile` changes trigger Docker, K8s manifests trigger Kubernetes, `.graphql` files trigger GraphQL, `.github/workflows/*.yml` changes trigger GitHub Actions, and `.ts` files in an Express app trigger the backend reviewer (not the frontend one).

### Combined Examples

```bash
# Full review of PR changes (+ auto-detected platforms)
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
| `full` | All cross-cutting agents | All cross-cutting agents |
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

**Platform-specific aspects** (automatically included when relevant, or explicitly requested):

| Aspect | Description | Agents |
|--------|-------------|--------|
| `ios` | Swift/SwiftUI/UIKit lifecycle, ARC, Apple APIs | iOS Platform Reviewer |
| `android` | Activity/Fragment lifecycle, Compose, Android security | Android Platform Reviewer |
| `ts-frontend` | React/Vue/Angular state, SSR/hydration, browser APIs | TypeScript Frontend Reviewer |
| `ts-backend` | Node.js event loop, middleware, ORM, API design | TypeScript Backend Reviewer |
| `python` | Pythonic idioms, type hints, Django/FastAPI/Flask | Python Reviewer |
| `rust` | Ownership idioms, unsafe auditing, trait design | Rust Reviewer |
| `go` | Go idioms, interface design, context propagation | Go Reviewer |
| `rails` | Rails conventions, ActiveRecord, migration safety | Rails Reviewer |
| `flutter` | Widget design, state management, Dart idioms | Flutter Reviewer |
| `java` | Spring Boot, JPA/Hibernate, bean lifecycle | Java Reviewer |
| `dotnet` | ASP.NET Core, Entity Framework, LINQ, C# idioms | .NET Reviewer |
| `php` | Laravel, Composer, Eloquent, PHP 8+ features | PHP Reviewer |
| `cpp` | Modern C++ (11/14/17/20), memory safety, RAII | C/C++ Reviewer |
| `react-native` | Bridge perf, native modules, platform code paths | React Native Reviewer |
| `svelte` | Svelte reactivity, SvelteKit routing, compile-time | Svelte Reviewer |
| `elixir` | OTP/GenServer, Phoenix LiveView, BEAM concurrency | Elixir Reviewer |
| `kotlin-server` | Ktor, coroutines, Kotlin server-side idioms | Kotlin Server Reviewer |
| `scala` | Functional patterns, Akka/Spark, effect systems | Scala Reviewer |
| `macos` | AppKit, SwiftUI for macOS, sandboxing, XPC, notarization | macOS Platform Reviewer |
| `nextjs` | Server/Client Components, App Router, caching, Server Actions | Next.js Reviewer |
| `vue` | Vue 3 Composition API, Nuxt 3, Pinia, reactivity | Vue.js Reviewer |
| `django` | Django ORM, DRF, migrations, template security | Django Reviewer |
| `ruby` | Ruby idioms, metaprogramming safety, gem hygiene | Ruby Reviewer |
| `terraform` | HCL, state management, IAM security, module design | Terraform Reviewer |
| `shell` | Bash/POSIX sh quoting, error handling, portability | Shell/Bash Reviewer |
| `angular` | Angular DI, RxJS, change detection, signals, templates | Angular Reviewer |
| `docker` | Dockerfile layers, multi-stage builds, security, Compose | Docker Reviewer |
| `kubernetes` | K8s manifests, resource limits, RBAC, probes, Helm | Kubernetes Reviewer |
| `graphql` | Schema design, resolver N+1, query security, DataLoader | GraphQL Reviewer |
| `github-actions` | Workflow security, secret handling, action pinning | GitHub Actions Reviewer |
| `mobile` | iOS + Android combined | iOS + Android Platform Reviewers |
| `apple` | iOS + macOS combined | iOS + macOS Platform Reviewers |
| `ts` | TypeScript frontend + backend combined | Both TypeScript Reviewers |
| `jvm` | Java + Kotlin Server + Scala combined | All JVM Reviewers |
| `infra` | Infrastructure as Code | Terraform + Shell Reviewers |
| `containers` | Container orchestration | Docker + Kubernetes Reviewers |

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

### Platform-Specific Agents

These agents are automatically included when the team lead determines they are relevant to the changed files. They can also be explicitly requested.

- **iOS Platform Reviewer** - Reviews Swift/SwiftUI/UIKit code for lifecycle correctness, ARC memory management, Apple API usage, and App Store compliance.

- **macOS Platform Reviewer** - Reviews macOS code for AppKit lifecycle, SwiftUI for macOS patterns, sandboxing and entitlements, XPC service design, notarization, and desktop integration.

- **Android Platform Reviewer** - Reviews Kotlin/Java Android code for Activity/Fragment lifecycle, Jetpack Compose patterns, manifest configuration, and Play Store compliance.

- **TypeScript Frontend Reviewer** - Reviews React/Vue/Angular code for component design, state management, SSR/hydration correctness, and browser API usage.

- **TypeScript Backend Reviewer** - Reviews Node.js/TypeScript server code for event loop safety, middleware correctness, ORM usage, authentication patterns, and graceful shutdown.

- **Next.js Reviewer** - Reviews Next.js code for Server/Client Component boundaries, App Router patterns, caching strategies, Server Actions security, middleware, and performance optimizations.

- **Vue.js Reviewer** - Reviews Vue 3 code for Composition API patterns, reactivity correctness, Nuxt 3 conventions, Pinia state management, template safety, and component design.

- **Python Reviewer** - Reviews Python code for Pythonic idioms, type hint correctness, Django/FastAPI/Flask patterns, and packaging best practices.

- **Django Reviewer** - Reviews Django code for ORM query efficiency, migration safety, view security, Django REST Framework patterns, template security, and settings configuration.

- **Ruby Reviewer** - Reviews Ruby code for idiomatic patterns, metaprogramming safety, gem dependency hygiene, RSpec/Minitest testing patterns, and memory management.

- **Rust Reviewer** - Reviews Rust code for ownership/borrowing idioms, unsafe code auditing, error handling patterns, and trait design.

- **Go Reviewer** - Reviews Go code for idiomatic patterns, interface design, context propagation, goroutine safety, and module hygiene.

- **Rails Reviewer** - Reviews Ruby on Rails code for Rails conventions, ActiveRecord best practices, migration safety, and background job design.

- **Flutter Reviewer** - Reviews Flutter/Dart code for widget composition, state management patterns, platform channel integration, and Dart idioms.

- **Java Reviewer** - Reviews Java code for Spring Boot patterns, JPA/Hibernate usage, bean lifecycle correctness, concurrency safety, and enterprise architecture best practices.

- **C#/.NET Reviewer** - Reviews C#/.NET code for ASP.NET Core patterns, Entity Framework Core usage, async/await correctness, DI lifetime management, and LINQ best practices.

- **PHP Reviewer** - Reviews PHP code for Laravel patterns, Eloquent ORM usage, Composer dependency management, PHP 8+ idioms, and security best practices.

- **C/C++ Reviewer** - Reviews C/C++ code for modern C++ idioms, memory safety, RAII patterns, STL usage, template correctness, and undefined behavior prevention.

- **React Native Reviewer** - Reviews React Native code for bridge performance, native module integration, platform-specific code paths, and mobile-specific security patterns.

- **Svelte Reviewer** - Reviews Svelte/SvelteKit code for reactivity correctness, SvelteKit routing and data loading, compile-time patterns, and SSR/hydration issues.

- **Elixir Reviewer** - Reviews Elixir code for OTP design patterns, Phoenix/LiveView conventions, Ecto query correctness, BEAM concurrency, and fault tolerance.

- **Kotlin Server Reviewer** - Reviews server-side Kotlin code for coroutine correctness, Ktor/Spring patterns, structured concurrency, and Kotlin idioms.

- **Scala Reviewer** - Reviews Scala code for functional patterns, type system usage, effect system correctness, Akka/Spark patterns, and JVM concurrency safety.

- **Terraform Reviewer** - Reviews Terraform/HCL code for resource configuration correctness, state management safety, IAM and security posture, module design patterns, and blast radius control.

- **Shell/Bash Reviewer** - Reviews shell scripts for quoting correctness, error handling (`set -euo pipefail`), security (command injection), portability (Bash vs POSIX sh), and CI/CD script safety.

- **Angular Reviewer** - Reviews Angular code for dependency injection patterns, RxJS observable management, change detection strategy, template safety, signals migration, and routing configuration.

- **Docker Reviewer** - Reviews Dockerfiles and Compose files for layer ordering, multi-stage build patterns, security posture (non-root, secrets in layers), PID 1 signal handling, and image supply chain.

- **Kubernetes Reviewer** - Reviews Kubernetes manifests and Helm charts for resource limits, security contexts, RBAC configuration, health probes, pod disruption budgets, and deployment strategies.

- **GraphQL Reviewer** - Reviews GraphQL schemas and resolvers for N+1 query patterns, DataLoader usage, query depth/complexity security, field-level authorization, and schema evolution safety.

- **GitHub Actions Reviewer** - Reviews GitHub Actions workflows for security vulnerabilities (`pull_request_target`, expression injection, unpinned actions), secret handling, permissions scoping, and pipeline reliability.

## Output Format

The skill produces a synthesized report with:

1. **Executive Summary** - Scope, agents run, issue counts
2. **New Issues** (from this PR) - Critical, Important, Suggestions
3. **Pre-existing Issues** (technical debt) - Tracked separately, do not block merge
4. **Architecture Health** - Table of checks with pass/fail
5. **Strengths** - What's done well
6. **Action Plan** - Prioritized next steps

Individual agent findings are also available in `/tmp/deep-review-*/` for detailed inspection.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- Git (for scope detection)

## How It Works

1. **Scope Detection** — Determines which files to analyze based on flags (`--pr`, `--changes`) or path argument

2. **Platform Detection** — Examines changed files and project context to automatically include relevant platform-specific reviewers (e.g., Swift changes in an iOS project trigger the iOS reviewer)

3. **Agent Selection** — Selects which agents to run based on specified aspects and detected platforms

4. **Team Initialization** — Creates a team and results directory, then spawns all selected agents as teammates in parallel

5. **Parallel Analysis** — Each agent reads its instructions from a dedicated file, analyzes the code, and writes findings to its own output file in `/tmp/deep-review-*/`

6. **Synthesis** — A dedicated synthesis agent reads all output files and merges them into a unified, deduplicated report

7. **Report & Cleanup** — The final report is presented to the user and the team is cleaned up

## Project Structure

```
claude-deep-review/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest
│   └── marketplace.json         # Marketplace catalog
├── skills/
│   └── deep-review/
│       ├── SKILL.md             # Skill orchestration (6-phase team workflow)
│       └── agents/              # Agent definitions (pure instructions)
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
│           ├── performance-analyzer.md
│           ├── ios-platform-reviewer.md
│           ├── macos-platform-reviewer.md
│           ├── android-platform-reviewer.md
│           ├── ts-frontend-reviewer.md
│           ├── ts-backend-reviewer.md
│           ├── nextjs-reviewer.md
│           ├── vue-reviewer.md
│           ├── python-reviewer.md
│           ├── django-reviewer.md
│           ├── ruby-reviewer.md
│           ├── rust-reviewer.md
│           ├── go-reviewer.md
│           ├── rails-reviewer.md
│           ├── flutter-reviewer.md
│           ├── java-reviewer.md
│           ├── dotnet-reviewer.md
│           ├── php-reviewer.md
│           ├── cpp-reviewer.md
│           ├── react-native-reviewer.md
│           ├── svelte-reviewer.md
│           ├── elixir-reviewer.md
│           ├── kotlin-server-reviewer.md
│           ├── scala-reviewer.md
│           ├── terraform-reviewer.md
│           ├── shell-reviewer.md
│           ├── angular-reviewer.md
│           ├── docker-reviewer.md
│           ├── kubernetes-reviewer.md
│           ├── graphql-reviewer.md
│           ├── github-actions-reviewer.md
│           └── synthesizer.md
├── README.md
└── LICENSE
```

## Tips

- Run `/deep-review` before creating a PR to catch issues early
- Use `core` (default) for quick essential checks during development
- Use `full` before major merges or releases
- **Focus on [NEW] issues** - these must be fixed before merge
- **[PRE-EXISTING] issues** are technical debt to track, not PR blockers
- Platform reviewers are automatically included when relevant — no need to specify `ios`, `python`, etc. manually
- Use `mobile`, `apple`, `ts`, `jvm`, `infra`, `containers`, or explicit platform names to force platform reviewers when needed
- Re-run after fixes to verify resolution

## License

MIT

## Contributing

Contributions welcome! Please open an issue or PR.
