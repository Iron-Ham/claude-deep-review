### Pattern Scout Agent

**Task tool parameters:**
- `subagent_type`: `Explore`
- `description`: "Check pattern consistency"

**Prompt:**
```
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
| Location | Expected Pattern | Actual Pattern | Classification | Impact |
|----------|------------------|----------------|----------------|--------|
| ... | ... | ... | [NEW]/[PRE-EXISTING] | High/Medium/Low |

#### Evolution/Drift
- {observations about how patterns have changed over time}

#### Confusion Points
- {specific inconsistencies that could confuse developers}

#### Standardization Recommendations

**[NEW] deviations (fix before merge)**:
- {pattern violations introduced by this PR}

**[PRE-EXISTING] deviations (technical debt)**:
- {existing inconsistencies to track}

**Quick Wins**: {easy fixes that improve consistency}
```

READ-ONLY analysis - do not modify any files.
```
