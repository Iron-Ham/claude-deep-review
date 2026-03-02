#!/usr/bin/env bash
# standalone-review.sh — Run deep-review agents as parallel headless processes
#
# Usage:
#   ./scripts/standalone-review.sh                  # core agents, PR scope
#   ./scripts/standalone-review.sh full             # all cross-cutting agents
#   ./scripts/standalone-review.sh code errors      # specific aspects
#   ./scripts/standalone-review.sh code ios         # mix aspects and platforms
#   ./scripts/standalone-review.sh code-reviewer    # direct agent ID
#   ./scripts/standalone-review.sh apple            # group alias (ios + macos)
#
# Each agent runs as a separate `claude -p` process. The shell `wait` builtin
# handles synchronization — no polling overhead, no shared context.

set -euo pipefail

# Allow launching headless claude processes from within a Claude Code session.
# These are independent processes, not nested sessions.
unset CLAUDECODE 2>/dev/null || true

REVIEW_DIR="/tmp/deep-review-$(uuidgen | tr '[:upper:]' '[:lower:]')"
mkdir -p "$REVIEW_DIR"
SKILL_DIR="$(cd "$(dirname "$0")/../skills/deep-review" && pwd)"

# --- Scope detection ---

BASE=$(git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null || git rev-list --max-parents=0 HEAD | head -1)
CHANGED_FILES=$(git diff --name-only "$BASE"...HEAD)
CHANGED_LINES=$(git diff "$BASE"...HEAD --unified=0 | grep -E '^@@|^diff --git' || true)

if [ -z "$CHANGED_FILES" ]; then
  echo "No changed files detected (base: $BASE). Nothing to review."
  exit 0
fi

SCOPE_CONTEXT="SCOPE: Focus analysis on these files and their direct dependencies:
${CHANGED_FILES}

CHANGED LINE RANGES (for classifying issues):
${CHANGED_LINES}

IMPORTANT - Issue Classification:
- [NEW]: Issue is in code ADDED or MODIFIED in this PR (within the changed line ranges above)
- [PRE-EXISTING]: Issue is in code NOT changed by this PR (outside the changed line ranges)"

# --- Agent selection ---

CORE_AGENTS=("code-reviewer" "silent-failure-hunter" "dependency-mapper" "cycle-detector"
             "hotspot-analyzer" "pattern-scout" "scale-assessor")

FULL_AGENTS=("${CORE_AGENTS[@]}" "type-design-analyzer" "comment-analyzer" "test-analyzer"
             "code-simplifier" "accessibility-scanner" "localization-scanner"
             "concurrency-analyzer" "performance-analyzer")

agents_for_aspect() {
  case "$1" in
    # Cross-cutting aspects
    code)        echo "code-reviewer" ;;
    errors)      echo "silent-failure-hunter" ;;
    arch)        echo "dependency-mapper cycle-detector hotspot-analyzer pattern-scout scale-assessor" ;;
    types)       echo "type-design-analyzer" ;;
    comments)    echo "comment-analyzer" ;;
    tests)       echo "test-analyzer" ;;
    simplify)    echo "code-simplifier" ;;
    a11y)        echo "accessibility-scanner" ;;
    l10n)        echo "localization-scanner" ;;
    concurrency) echo "concurrency-analyzer" ;;
    perf)        echo "performance-analyzer" ;;
    # Platform aspects
    ios)            echo "ios-platform-reviewer" ;;
    macos)          echo "macos-platform-reviewer" ;;
    android)        echo "android-platform-reviewer" ;;
    ts-frontend)    echo "ts-frontend-reviewer" ;;
    ts-backend)     echo "ts-backend-reviewer" ;;
    nextjs)         echo "nextjs-reviewer" ;;
    vue)            echo "vue-reviewer" ;;
    python)         echo "python-reviewer" ;;
    django)         echo "django-reviewer" ;;
    ruby)           echo "ruby-reviewer" ;;
    rust)           echo "rust-reviewer" ;;
    go)             echo "go-reviewer" ;;
    rails)          echo "rails-reviewer" ;;
    flutter)        echo "flutter-reviewer" ;;
    java)           echo "java-reviewer" ;;
    dotnet)         echo "dotnet-reviewer" ;;
    php)            echo "php-reviewer" ;;
    cpp)            echo "cpp-reviewer" ;;
    react-native)   echo "react-native-reviewer" ;;
    svelte)         echo "svelte-reviewer" ;;
    elixir)         echo "elixir-reviewer" ;;
    kotlin-server)  echo "kotlin-server-reviewer" ;;
    scala)          echo "scala-reviewer" ;;
    terraform)      echo "terraform-reviewer" ;;
    shell)          echo "shell-reviewer" ;;
    angular)        echo "angular-reviewer" ;;
    docker)         echo "docker-reviewer" ;;
    kubernetes)     echo "kubernetes-reviewer" ;;
    graphql)        echo "graphql-reviewer" ;;
    github-actions) echo "github-actions-reviewer" ;;
    sql)            echo "sql-reviewer" ;;
    swift-data)     echo "swift-data-reviewer" ;;
    agent-instructions) echo "agent-instructions-reviewer" ;;
    # Group aliases
    mobile)     echo "ios-platform-reviewer android-platform-reviewer" ;;
    ts)         echo "ts-frontend-reviewer ts-backend-reviewer" ;;
    jvm)        echo "java-reviewer kotlin-server-reviewer scala-reviewer" ;;
    apple)      echo "ios-platform-reviewer macos-platform-reviewer" ;;
    infra)      echo "terraform-reviewer shell-reviewer" ;;
    containers) echo "docker-reviewer kubernetes-reviewer" ;;
    *)          return 1 ;;
  esac
}

# Check if an argument is a direct agent ID (has a matching .md file)
is_agent_id() {
  [ -f "${SKILL_DIR}/agents/${1}.md" ]
}

AGENTS=()
if [ $# -eq 0 ]; then
  set -- core
fi

for arg in "$@"; do
  case "$arg" in
    core) AGENTS+=("${CORE_AGENTS[@]}") ;;
    full) AGENTS+=("${FULL_AGENTS[@]}") ;;
    *)
      if aspect_agents=$(agents_for_aspect "$arg"); then
        read -ra agent_list <<< "$aspect_agents"
        AGENTS+=("${agent_list[@]}")
      elif is_agent_id "$arg"; then
        AGENTS+=("$arg")
      else
        echo "Unknown aspect or agent: $arg (skipping)"
      fi
      ;;
  esac
done

# Deduplicate
DEDUPED=$(printf '%s\n' "${AGENTS[@]}" | sort -u)
AGENTS=()
while IFS= read -r line; do
  [ -n "$line" ] && AGENTS+=("$line")
done <<< "$DEDUPED"

if [ ${#AGENTS[@]} -eq 0 ]; then
  echo "No agents to run."
  exit 1
fi

echo "Review dir: $REVIEW_DIR"
echo "Base: $BASE"
echo "Changed files: $(echo "$CHANGED_FILES" | wc -l | tr -d ' ')"
echo "Agents: ${AGENTS[*]}"
echo ""

# --- Launch agents ---

PIDS=()
for agent in "${AGENTS[@]}"; do
  claude -p "You are a specialized code analysis agent.

## Your Task
1. Read your analysis instructions from: ${SKILL_DIR}/agents/${agent}.md
2. Analyze the code following those instructions
3. Write your complete findings to: ${REVIEW_DIR}/${agent}.md

## Scope Context
${SCOPE_CONTEXT}

Note: Your analysis instructions reference \`{SCOPE_CONTEXT}\`.
This refers to the Scope Context provided directly above — use it as-is.

## Output File Format
Write your findings as a markdown file. Start with a heading identifying the agent,
then list all findings using the output format specified in your analysis instructions.

## Classification Rules
When classifying issues as [NEW] or [PRE-EXISTING], use the changed line ranges
provided in the Scope Context above. Issues in changed lines are [NEW]; all others
are [PRE-EXISTING].

## Important
- Do NOT modify any source code files — this is a READ-ONLY analysis
- Write findings ONLY to the output file path specified above
- Be thorough but focused — quality over quantity" \
    --allowedTools "Bash,Read,Write,Glob,Grep" &
  PIDS+=($!)
  echo "Launched ${agent} (PID $!)"
done

echo ""
echo "Waiting for ${#AGENTS[@]} agents..."

FAILED=()
i=0
for pid in "${PIDS[@]}"; do
  if ! wait "$pid"; then
    FAILED+=("${AGENTS[$i]}")
    echo "FAILED: ${AGENTS[$i]}"
  else
    echo "Done: ${AGENTS[$i]}"
  fi
  i=$((i + 1))
done

echo ""

if [ ${#FAILED[@]} -gt 0 ]; then
  echo "WARNING: Failed agents: ${FAILED[*]}"
fi

# --- Synthesize ---

EXPECTED=$(printf '%s.md ' "${AGENTS[@]}")
echo "Launching synthesizer..."

claude -p "Read your synthesis instructions from: ${SKILL_DIR}/agents/synthesizer.md

Review directory: ${REVIEW_DIR}
Expected output files: ${EXPECTED}
Failed agents: ${FAILED[*]+"${FAILED[*]}"}
Scope: PR changes (${BASE}...HEAD)

Read all agent output files, deduplicate findings, and write the final report to: ${REVIEW_DIR}/REPORT.md" \
  --allowedTools "Bash,Read,Write,Glob,Grep"

echo ""
echo "========================================="
echo "Report ready: ${REVIEW_DIR}/REPORT.md"
echo "Individual findings: ${REVIEW_DIR}/"
echo "========================================="
echo ""
cat "${REVIEW_DIR}/REPORT.md"
