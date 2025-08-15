**Context**: Review CLAUDE.md for project context first.

Create `specs/{kebab-case-feature-name}/` directory for "$ARGUMENTS" and generate:

1.  **`requirements.md`**
    ```markdown
    # Requirements Document
    ## Project Overview
    [Feature description and business value]
    
    ## Requirements
    ### Requirement 1: [Name]
    **As a** [User] **I want** [Goal] **So that** [Benefit]
    **Acceptance Criteria:**
    1.1. WHEN [condition] THEN [system] SHALL [response]
    1.2. WHEN [condition] THEN [system] SHALL [response]
    
    ### Requirement 2: [Name]
    **As a** [User] **I want** [Goal] **So that** [Benefit]
    **Acceptance Criteria:**
    2.1. WHEN [condition] THEN [system] SHALL [response]
    2.2. WHEN [condition] THEN [system] SHALL [response]
    
    ## Non-functional Requirements
    - **Performance**: [Requirements]
    - **Security**: [Requirements]
    - **Usability**: [Requirements]
    ```

2.  **`design.md`**
    ```markdown
    # Design Document
    ## Architecture Overview
    [How feature integrates with existing system]
    
    ## Technology Stack
    - **Language**: [e.g., TypeScript]
    - **Framework**: [e.g., React]
    - **Database**: [e.g., PostgreSQL]
    
    ## Components and Interfaces
    ### Modified: [ExistingComponent] - [Changes needed]
    ### New: [NewComponent] - [Purpose]
    
    ```typescript
    // Key implementation structure
    ```
    
    ## Data Flow
    1. [Step 1]
    2. [Step 2] 
    3. [Step 3]
    
    ## API Design
    - `GET /api/[resource]` - [Description]
    - `POST /api/[resource]` - [Description]
    
    ## Database Schema
    | Column | Type | Description |
    |--------|------|-------------|
    | id | INTEGER | Primary Key |
    ```

3.  **`tasks.md`**
    ```markdown
    # Task List
    ## Progress: 0/0 Complete, 0 In Progress, 0 Not Started
    
    ## Phase 1: Foundation
    - [ ] **Task 1**: [Name] - [Details] - Req: 1.1,1.2 - Deps: None
    - [ ] **Task 2**: [Name] - [Details] - Req: 1.3,2.1 - Deps: Task 1
    
    ## Phase 2: Implementation  
    - [ ] **Task 3**: [Name] - [Details] - Req: 2.1,2.2 - Deps: Task 2
    - [ ] **Task 4**: [Name] - [Details] - Req: 1.1,2.2 - Deps: Task 2
    
    ## Phase 3: Testing
    - [ ] **Task 5**: Unit Tests - [Details] - Req: All - Deps: Task 3,4
    ```

Create requirements.md first, then design.md, then tasks.md.

---

**Task Updates**: Change `[ ]` to `[x]` and update progress count.

**Completion**: When 100% complete:
1. Verify all tasks marked `[x]`
2. Test feature functionality 
3. Create `specs/done/` if needed
4. Move `specs/{feature-name}/` to `specs/done/`
5. Rename files: `DONE_[YYYY-MM-DD]_filename.md`
6. Confirm archival
