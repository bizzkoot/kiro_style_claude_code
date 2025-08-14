First, create a directory for the feature based on the user's request, "$ARGUMENTS". The directory name should be a clean `kebab-case` version of the feature name:
- Convert to lowercase
- Replace spaces with hyphens
- Remove special characters

For example, "Create a TODO app" becomes "create-a-todo-app". Place this new directory inside the `specs/` folder.

Then, for the "$ARGUMENTS" feature, please create the following specification files inside the new `specs/{feature-name}/` directory:

1.  **`specs/{feature-name}/requirements.md`**
    *   **Introduction**: Start with a clear summary of the feature and its business value.
    *   **User Stories**: Format each as:
       ```
       ### Story 1: [Brief Title]
       As a [user role], I want [goal] so that [benefit].
       ```
    *   **Acceptance Criteria**: For each story, provide a numbered list using EARS format:
       ```
       #### Acceptance Criteria:
       1. WHEN [event] THEN [system] SHALL [response].
       2. IF [condition] THEN [system] SHALL [response].
       ```

2.  **`specs/{feature-name}/design.md`**
    *   **Overview**: Briefly describe the technical approach.
    *   **Architecture**: Describe how the feature fits into the existing system. Include a simple Mermaid diagram if helpful.
    *   **Components**: List new or modified components and their interactions.
    *   **Data Models**: Detail any new data structures or schema changes.
    *   **API Endpoints**: Document any new or modified API endpoints if applicable.

3.  **`specs/{feature-name}/tasks.md`**
    *   **Implementation Plan**: Provide a brief overview of the implementation strategy.
    *   **Task Checklist**: Create a detailed numbered checklist using `[ ]` for concrete implementation steps:
       ```
       ## Frontend Tasks
       - [ ] 1. Create component structure
       - [ ] 2. Implement form validation
       
       ## Backend Tasks
       - [ ] 3. Define database schema
       - [ ] 4. Create API endpoint
       ```
    *   **Dependencies**: Note any dependencies between tasks (e.g., "Task 4 depends on Task 3").

Please create and confirm the `requirements.md` file first before creating the other files.

---

**4. Completion**

When all tasks in the `tasks.md` checklist for a feature are marked as complete (`[x]`), please perform the following archival steps:

1.  **Create `specs/done` directory**: If it does not already exist, create a new directory named `done` inside the `specs/` folder.
2.  **Move the feature directory**: Move the entire directory for the completed feature (e.g., `specs/{feature-name}/`) into the `specs/done/` directory.
3.  **Rename the specification files**: Inside the new `specs/done/{feature-name}/` directory, rename the three specification files by adding a `DONE_` prefix and completion date:
    *   `requirements.md` becomes `DONE_[YYYY-MM-DD]_requirements.md`
    *   `design.md` becomes `DONE_[YYYY-MM-DD]_design.md`
    *   `tasks.md` becomes `DONE_[YYYY-MM-DD]_tasks.md`
4.  **Create summary**: Add a brief completion summary at the top of each archived file indicating when it was completed.
5.  **Confirm Archival**: Inform the user that the feature's specifications have been successfully archived.4.  **Confirm Archival**: Inform the user that the feature's specifications have been successfully archived.
