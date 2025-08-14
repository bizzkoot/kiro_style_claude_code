First, create a directory for the feature based on the user's request, "$ARGUMENTS". The directory name should be a `kebab-case` version of the feature name. For example, "Create a TODO app" becomes "create-a-todo-app". Place this new directory inside the `specs/` folder.

Then, for the "$ARGUMENTS" feature, please create the following specification files inside the new `specs/{feature-name}/` directory:

1.  **`specs/{feature-name}/requirements.md`**
    *   **Introduction**: Start with a clear summary of the feature.
    *   **User Stories**: Use the format: "As a [user], I want [goal] so that [benefit]".
    *   **Acceptance Criteria**: For each story, provide a numbered list of criteria, preferably in EARS format (e.g., "WHEN [event] THEN [system] SHALL [response]").

2.  **`specs/{feature-name}/design.md`**
    *   **Overview**: Briefly describe the technical approach.
    *   **Architecture**: Describe how the feature fits into the existing system. Include a Mermaid diagram if it helps clarity.
    *   **Components and Interfaces**: List new or modified components (UI, API, database) and their interactions.
    *   **Data Models**: Detail any new data structures or schema changes.

3.  **`specs/{feature-name}/tasks.md`**
    *   **Implementation Plan**: Provide a brief overview of the strategy.
    *   **Task Checklist**: Create a detailed checklist using `[ ]` for small, concrete steps (e.g., "Create login form UI").
    *   **Grouping**: Group related tasks under subheadings (e.g., "Frontend," "Backend").
*   **Dependencies**: Specify any dependencies between tasks.

Please create and confirm the `requirements.md` file first before creating the other files.

---

**4. Completion**

When all tasks in the `tasks.md` checklist for a feature are marked as complete (`[x]`), please perform the following archival steps:

1.  **Create `specs/done` directory**: If it does not already exist, create a new directory named `done` inside the `specs/` folder.
2.  **Move the feature directory**: Move the entire directory for the completed feature (e.g., `specs/{feature-name}/`) into the `specs/done/` directory.
3.  **Rename the specification files**: Inside the new `specs/done/{feature-name}/` directory, rename the three specification files by adding a `DONE_` prefix:
    *   `requirements.md` becomes `DONE_requirements.md`
    *   `design.md` becomes `DONE_design.md`
    *   `tasks.md` becomes `DONE_tasks.md`
4.  **Confirm Archival**: Inform the user that the feature's specifications have been successfully archived.