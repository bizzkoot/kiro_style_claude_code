First, use the project context stored in CLAUDE.md to understand the existing implementation. Then create a directory for the feature based on the user's request, "$ARGUMENTS". The directory name should be a clean `kebab-case` version of the feature name (lowercase, spaces to hyphens). For example, "Create a TODO app" becomes "create-a-todo-app". Place this new directory inside the `specs/` folder.

Then, for the "$ARGUMENTS" feature, please create the following specification files inside the new `specs/{feature-name}/` directory:

1.  **`specs/{feature-name}/requirements.md`**
    *   **Introduction**: Clear summary of the feature and its value.
    *   **User Stories**: Format as "As a [user], I want [goal] so that [benefit]".
    *   **Acceptance Criteria**: For each story, list criteria using EARS format: "WHEN [event] THEN [system] SHALL [response]".
    *   Align requirements with the project architecture described in CLAUDE.md.

2.  **`specs/{feature-name}/design.md`**
    *   **Overview**: Brief technical approach description.
    *   **Architecture**: How the feature fits into the existing system.
    *   **Components**: New or modified components and interactions.
    *   **Data Models**: New data structures or schema changes.
    *   **API Endpoints**: Any new or modified endpoints (if applicable).

3.  **`specs/{feature-name}/tasks.md`**
    *   **Implementation Plan**: Brief overview of strategy.
    *   **Progress**: Track completed vs. total tasks at the top.
    *   **Task Checklist**: Numbered tasks using `[ ]` format.
       ```
       # Progress: 0/4 tasks completed
       
       ## Frontend
       - [ ] 1. Create component structure
       - [ ] 2. Implement form validation
       
       ## Backend
       - [ ] 3. Define database schema
       - [ ] 4. Create API endpoint
       ```
    *   When a task is completed, update status to `[x]` and update the progress counter.

Please create and confirm the `requirements.md` file first before creating the other files.

---

**4. Completion**

When all tasks in the `tasks.md` checklist for a feature are marked as complete (`[x]`), please:

1.  **Verify completion**: Confirm all tasks are marked with `[x]`.
2.  **Build verification**: Run a test build of the feature to check for errors.
    * Review `specs/{feature-name}/tasks.md` to understand the implementation details
    * Suggest appropriate build/test commands based on the project type
    * If errors occur, analyze them in context of the specific tasks implemented
    * Match errors to specific tasks in the tasks.md file where possible
    * Suggest targeted solutions based on the implementation details
    * Ask user to confirm corrections before implementing them
    * Only proceed with archiving if build succeeds
3.  **Create `specs/done` directory**: If it doesn't exist already.
4.  **Move the feature directory**: Move `specs/{feature-name}/` to `specs/done/`.
5.  **Rename files with completion date**: Add `DONE_[YYYY-MM-DD]_` prefix to all files.
6.  **Confirm**: Inform the user that verification and archiving were successful.
