First, use the project context stored in CLAUDE.md to understand the existing implementation. Then create a directory for the feature based on the user's request, "$ARGUMENTS". The directory name should be a clean `kebab-case` version of the feature name (lowercase, spaces to hyphens). For example, "Create a TODO app" becomes "create-a-todo-app". Place this new directory inside the `specs/` folder.

Then, for the "$ARGUMENTS" feature, please create the following specification files inside the new `specs/{feature-name}/` directory:

1.  **`specs/{feature-name}/requirements.md`**
    ```markdown
    # Requirements Document

    ## Project Overview
    
    [Brief description of the feature and its business value]
    
    ## User Stories
    
    ### Story 1: [Feature Name]
    
    **As a** [User Type]  
    **I want** [Purpose]  
    **So that** [Benefit]
    
    **Acceptance Criteria:**
    - [ ] [Criterion 1]
    - [ ] [Criterion 2]
    - [ ] [Criterion 3]
    
    ### Story 2: [Feature Name]
    
    **As a** [User Type]  
    **I want** [Purpose]  
    **So that** [Benefit]
    
    **Acceptance Criteria:**
    - [ ] [Criterion 1]
    - [ ] [Criterion 2]
    
    ## Non-functional Requirements
    
    - **Performance**: [Requirements]
    - **Security**: [Requirements]
    - **Usability**: [Requirements]
    ```

2.  **`specs/{feature-name}/design.md`**
    ```markdown
    # Design Document
    
    ## Architecture Overview
    
    [System architecture description for this feature]
    
    ## Technology Stack
    
    - **Language**: [e.g., TypeScript]
    - **Framework**: [e.g., React]
    - **Database**: [e.g., PostgreSQL]
    - **Others**: [Required tools]
    
    ## Component Structure
    
    ```
    [Component diagram]
    ├── Component A
    │   └── Role: [Description]
    ├── Component B
    │   └── Role: [Description]
    └── Component C
        └── Role: [Description]
    ```
    
    ## Data Flow
    
    1. [Flow 1]
    2. [Flow 2]
    3. [Flow 3]
    
    ## API Design
    
    ### Endpoint List
    
    - `GET /api/[resource]` - [Description]
    - `POST /api/[resource]` - [Description]
    - `PUT /api/[resource]/:id` - [Description]
    - `DELETE /api/[resource]/:id` - [Description]
    
    ## Database Schema
    
    ### Table: [Table Name]
    
    | Column Name | Type | Description |
    |-------------|------|-------------|
    | id | INTEGER | Primary Key |
    | name | VARCHAR | [Description] |
    ```

3.  **`specs/{feature-name}/tasks.md`**
    ```markdown
    # Task List
    
    ## Progress Tracking
    
    - Completed: 0/0
    - In Progress: 0
    - Not Started: 0
    
    ## Phase 1: Foundation Building
    
    - [ ] **Task 1**: [Task Name]
      - [Details]
      - Dependencies: None
    
    - [ ] **Task 2**: [Task Name]
      - [Details]
      - Dependencies: Task 1
    
    ## Phase 2: Core Feature Implementation
    
    - [ ] **Task 3**: [Task Name]
      - [Details]
      - Dependencies: Task 2
    
    - [ ] **Task 4**: [Task Name]
      - [Details]
      - Dependencies: Task 2
    
    ## Phase 3: Testing and Quality Assurance
    
    - [ ] **Task 5**: Unit Test Creation
      - [Details]
      - Dependencies: Task 3, 4
    ```

Please create and confirm the `requirements.md` file first before creating the other files.

---

**Task Completion Tracking**

When a task is completed:
1. Update the task status in tasks.md from `[ ]` to `[x]`
2. Update the Progress Tracking section at the top of the file:
   ```
   ## Progress Tracking
   
   - Completed: 1/5
   - In Progress: 1
   - Not Started: 3
   ```

---

**Completion and Archiving**

When all tasks in the `tasks.md` checklist for a feature are marked as complete (`[x]`), please:

1.  **Verify completion**: Confirm all tasks are marked with `[x]` and the Progress Tracking shows 100% completion.

2.  **Verification**: Test the implemented feature to ensure it works correctly.
    * Review `specs/{feature-name}/tasks.md` to understand the implementation details
    * Suggest appropriate testing methods based on the project type (unit tests, manual testing, etc.)
    * If issues are found, analyze them in context of the specific tasks implemented
    * Match issues to specific tasks in the tasks.md file where possible
    * Suggest targeted solutions based on the implementation details
    * Ask user to confirm corrections before implementing them
    * Only proceed with archiving if verification succeeds

3.  **Create `specs/done` directory**: If it doesn't exist already, create a new directory named `done` inside the `specs/` folder.

4.  **Move the feature directory**: Move `specs/{feature-name}/` to `specs/done/`.

5.  **Rename files with completion date**: Inside the new `specs/done/{feature-name}/` directory, rename the three specification files by adding a `DONE_[YYYY-MM-DD]_` prefix:
    *   `requirements.md` becomes `DONE_[YYYY-MM-DD]_requirements.md`
    *   `design.md` becomes `DONE_[YYYY-MM-DD]_design.md`
    *   `tasks.md` becomes `DONE_[YYYY-MM-DD]_tasks.md`

6.  **Confirm**: Inform the user that verification and archiving were successful.
