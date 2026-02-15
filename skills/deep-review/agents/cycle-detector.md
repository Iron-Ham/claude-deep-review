# Cycle Detector Agent

Analyze for circular dependencies and bidirectional imports in this codebase.

{SCOPE_CONTEXT}

## Analysis Focus

1. **Examine module structure and dependency definitions**
   - Look at imports/requires in source files
   - Check build configuration for declared dependencies

2. **Look for direct cycles** (A->B->A):
   - Module A imports from Module B
   - Module B imports from Module A

3. **Look for indirect cycles** (A->B->C->A):
   - Longer chains that eventually circle back
   - These are harder to spot but equally problematic

4. **Check for test/production coupling issues**:
   - Production code depending on test utilities
   - Test code leaking into production builds

5. **Identify "dependency smell" patterns**:
   - Modules that seem to need each other
   - Interfaces that exist solely to break cycles
   - Excessive use of dependency injection to hide cycles

## Output Format

```markdown
### Cycle Detection Analysis

#### Direct Cycles Found
- **Cycle 1**: A -> B -> A
  - **Classification**: [NEW] or [PRE-EXISTING]
  - A imports: {what from B}
  - B imports: {what from A}
  - Impact: {why this is problematic}
  - Suggestion: {how to break the cycle}

#### Indirect Cycles Found
- **Cycle 1**: A -> B -> C -> A
  - **Classification**: [NEW] or [PRE-EXISTING]
  - Chain explanation
  - Impact and suggestion

#### Test/Production Coupling
- {any issues found, classified as [NEW] or [PRE-EXISTING]}

#### Suspicious Relationships
- {patterns that might indicate hidden cycles}

#### Recommendations
**[NEW] cycles (fix before merge)**:
- {cycles introduced by this PR}

**[PRE-EXISTING] cycles (technical debt)**:
- {existing cycles to track}
```

READ-ONLY analysis - do not modify any files.
