# Kiro Implementer Command

As an implementation specialist, analyze requirements and design to create detailed implementation tasks.

**Process:**
1. Check if `specs/{kebab-case-feature-name}/` exists for "$ARGUMENTS"
2. If target folder doesn't exist, scan `specs/` for available feature folders (exclude `specs/done/`)
3. If multiple folders found, present selection:
   ```
   Multiple feature folders found. Please select:
   1. {folder-name-1}
   2. {folder-name-2}
   3. {folder-name-3}
   > 
   ```
4. After confirmation/selection, read `specs/{selected-feature}/requirements.md` and `specs/{selected-feature}/design.md`
5. Generate tasks.md in the selected folder

**`tasks.md`**
```markdown
# Task List - Created by Implementer Agent
## Progress: 0/0 Complete, 0 In Progress, 0 Not Started

## Implementation Strategy
[Overall approach to implementing this feature]

## Phase 1: Foundation
- [ ] **Task 1**: [Detailed name] - [Comprehensive implementation details] - Req: 1.1,1.2 - Deps: None
  - **Implementation Approach**: [Specific approach]
  - **Testing Strategy**: [How to verify this task]
  - **Estimated Complexity**: [Low/Medium/High]
  - **Technical Considerations**: [Special technical notes]

- [ ] **Task 2**: [Detailed name] - [Comprehensive implementation details] - Req: 1.3,2.1 - Deps: Task 1
  - **Implementation Approach**: [Specific approach]
  - **Testing Strategy**: [How to verify this task]
  - **Estimated Complexity**: [Low/Medium/High]
  - **Technical Considerations**: [Special technical notes]

## Phase 2: Implementation  
- [ ] **Task 3**: [Detailed name] - [Comprehensive implementation details] - Req: 2.1,2.2 - Deps: Task 2
  - **Implementation Approach**: [Specific approach]
  - **Testing Strategy**: [How to verify this task]
  - **Estimated Complexity**: [Low/Medium/High]
  - **Technical Considerations**: [Special technical notes]

- [ ] **Task 4**: [Detailed name] - [Comprehensive implementation details] - Req: 1.1,2.2 - Deps: Task 2
  - **Implementation Approach**: [Specific approach]
  - **Testing Strategy**: [How to verify this task]
  - **Estimated Complexity**: [Low/Medium/High]
  - **Technical Considerations**: [Special technical notes]

## Phase 3: Testing
- [ ] **Task 5**: Comprehensive Unit Tests - [Detailed testing strategy] - Req: All - Deps: Task 3,4
  - **Test Coverage Goals**: [Coverage metrics]
  - **Test Cases**: [Key test scenarios]
  - **Mock Requirements**: [Mocking strategy]

## Phase 4: Integration and Deployment
- [ ] **Task 6**: Integration Testing - [Details] - Req: All - Deps: Task 5
- [ ] **Task 7**: Documentation - [Details] - Req: All - Deps: Task 6
- [ ] **Task 8**: Deployment - [Details] - Req: All - Deps: Task 7

## Dependency Graph
```
Task 1 → Task 2 → Task 3 → Task 5 → Task 6 → Task 7 → Task 8
         └→ Task 4 ─┘
```

## Implementation Notes
[Any additional implementation considerations or developer guidance]
```

**Specialized Role**: As the Implementer Agent, my focus is on breaking down the implementation into detailed, actionable tasks with clear dependencies, testing strategies, and complexity assessments. I maintain a complete understanding of the implementation details to assist with coding tasks.

**Next Steps**:
To implement tasks:
1. Request implementation: `Please implement Task 1`
2. Update tasks when complete: Change `[ ]` to `[x]` and update progress count
---
**Task Updates**: Change `[ ]` to `[x]` and update progress count.
**Completion**: When 100% complete:
1. Verify all tasks marked `[x]`
2. Test feature functionality 
3. Create `specs/done/` if needed
4. Move `specs/{feature-name}/` to `specs/done/`
5. Rename files: `DONE_[YYYY-MM-DD]_filename.md`
6. Confirm archival