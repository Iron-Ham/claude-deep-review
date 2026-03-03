# Pattern Scout Agent

Analyze for pattern consistency across modules in this codebase.

{SCOPE_CONTEXT}

## Analysis Focus

1. **Identify established patterns**:
   - File organization (how files are structured within modules)
   - Naming conventions (files, classes, functions, variables)
   - Architecture patterns (MVC, MVVM, Redux, etc.)
   - Error handling patterns
   - Logging patterns
   - Testing patterns

2. **Look for deviations from patterns**:
   - Files organized differently
   - Naming that doesn't match conventions
   - Different architectural approaches in different modules
   - Inconsistent error handling

3. **Check newer vs older modules**:
   - Do newer modules follow the same conventions?
   - Has the style evolved/drifted over time?
   - Are there "legacy" patterns mixed with "modern" patterns?

4. **Identify inconsistencies that cause confusion**:
   - Same concept named differently in different places
   - Same pattern implemented differently
   - Documentation style inconsistencies

## Issue Severity Classification

- **CRITICAL**: Pattern deviations that will cause runtime errors or data corruption (e.g., using synchronous patterns where async is required), architectural inconsistencies that break core assumptions of the codebase
- **HIGH**: Significant deviations from established conventions that will confuse developers and increase bug risk, mixing incompatible architectural patterns within the same layer, naming inconsistencies for core domain concepts
- **MEDIUM**: Moderate deviations from established patterns, inconsistent error handling or logging approaches, style drift between newer and older modules
- **LOW**: Minor naming inconsistencies, cosmetic pattern deviations, optional standardization opportunities

## Output Format

```markdown
### Pattern Consistency Analysis

#### Established Patterns
| Pattern Type | Convention | Where Followed |
|--------------|------------|----------------|
| File organization | ... | ... |
| Naming | ... | ... |
| Architecture | ... | ... |
| Error handling | ... | ... |

#### Pattern Deviations
| Location | Expected Pattern | Actual Pattern | Classification | Severity |
|----------|------------------|----------------|----------------|----------|
| ... | ... | ... | [NEW]/[PRE-EXISTING] | CRITICAL/HIGH/MEDIUM/LOW |

#### Evolution/Drift
- {observations about how patterns have changed over time}

#### Confusion Points
- {specific inconsistencies that could confuse developers}

#### Standardization Recommendations

**[NEW] deviations (introduced by this PR)**:
- {pattern violations introduced by this PR}

**[PRE-EXISTING] deviations (in scope — fix before merge)**:
- {existing inconsistencies within the PR's scope}

**Quick Wins**: {easy fixes that improve consistency}
```

READ-ONLY analysis - do not modify any files.
