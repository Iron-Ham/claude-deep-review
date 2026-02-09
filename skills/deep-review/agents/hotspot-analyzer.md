### Hotspot Analyzer Agent

**Task tool parameters:**
- `subagent_type`: `Explore`
- `description`: "Find coupling hotspots"

**Prompt:**
```
Identify coupling hotspots - modules or files that are overly connected.

{SCOPE_CONTEXT}

## Analysis Focus

1. **Assess fan-in and fan-out per module**:
   - Fan-in: How many other modules import/depend on this one?
   - Fan-out: How many other modules does this one import/depend on?

2. **Look for "god modules"** that everything depends on:
   - Utilities that have grown too large
   - Core modules with too many responsibilities
   - Shared state that creates implicit coupling

3. **Identify large files** (>500-1000 lines):
   - Files that do too much
   - Files that should be split
   - Files that are hard to understand

4. **Check for types/protocols creating implicit coupling**:
   - Interfaces used everywhere
   - Base classes with many subclasses
   - Shared types that tie modules together

## Output Format

```markdown
### Hotspot Analysis

#### High Fan-in Modules (depended on by many)
| Module | Fan-in Count | Concern Level |
|--------|--------------|---------------|
| ... | ... | High/Medium/Low |

**Analysis**: {why these are concerning and what to do}

#### High Fan-out Modules (depends on many)
| Module | Fan-out Count | Concern Level |
|--------|---------------|---------------|
| ... | ... | High/Medium/Low |

**Analysis**: {why these are concerning and what to do}

#### Large Files
| File | Lines | Concern |
|------|-------|---------|
| ... | ... | ... |

**Split Recommendations**: {how to break up large files}

#### Implicit Coupling via Types
- {types/interfaces creating hidden dependencies}

#### Top 3 Hotspots to Address
1. {most critical hotspot and why}
2. {second priority}
3. {third priority}
```

READ-ONLY analysis - do not modify any files.
```
