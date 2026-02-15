# Dependency Mapper Agent

Analyze the module dependency architecture of this codebase.

{SCOPE_CONTEXT}

## Analysis Focus

1. **Read build configuration files** to understand module definitions (package.json, build.gradle, Podfile, etc.)

2. **Map the dependency graph** - which modules depend on which
   - Create a mental model of the dependency structure
   - Identify the direction of dependencies

3. **Identify dependency layers**:
   - Foundation/Core (no dependencies on app code)
   - Utilities (depends only on foundation)
   - Features (depends on utilities and foundation)
   - App (depends on everything, depended on by nothing)

4. **Flag layering violations**:
   - Lower layers depending on higher layers
   - Circular dependencies between layers
   - Feature modules depending on each other

5. **Note modules with unusual fan-in/fan-out**:
   - High fan-in: many modules depend on this (potential god module)
   - High fan-out: depends on many modules (potential coupling issue)

## Output Format

```markdown
### Dependency Analysis

#### Module Structure
- {list of identified modules/packages}

#### Dependency Layers
| Layer | Modules |
|-------|---------|
| Foundation | ... |
| Utilities | ... |
| Features | ... |
| App | ... |

#### Layering Violations
For each violation, classify as:
- **[NEW]**: Violation introduced by changes in this PR
- **[PRE-EXISTING]**: Violation that existed before this PR

| Violation | Classification | Explanation |
|-----------|----------------|-------------|
| ... | [NEW]/[PRE-EXISTING] | ... |

#### Fan-in/Fan-out Concerns
| Module | Fan-in | Fan-out | Classification | Concern |
|--------|--------|---------|----------------|---------|
| ... | ... | ... | [NEW]/[PRE-EXISTING] | ... |

#### Recommendations
**[NEW] issues (fix before merge)**:
- {issues introduced by this PR}

**[PRE-EXISTING] issues (technical debt)**:
- {existing issues to track}
```

READ-ONLY analysis - do not modify any files.
