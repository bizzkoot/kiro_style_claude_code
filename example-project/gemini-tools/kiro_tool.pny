import pathlib
import re
import datetime
import hashlib
import uuid
from google.generativeai.function_calling import tool

# This model instance is a placeholder for the actual generative model
# that will be used by the Gemini CLI to execute the tool's logic.
# The tool's code itself doesn't call the model; it defines prompts
# that the calling model will use.
model = None 

def _kebab_case(name: str) -> str:
    """Converts a string to kebab-case."""
    name = re.sub(r'(?<!^)(?=[A-Z])', '-', name).lower()
    return re.sub(r'[\s_]+', '-', name)

def _generate_uuid():
    """Generates a short UUID (8 characters)."""
    return uuid.uuid4().hex[:8]

def _update_task_status(spec_path: pathlib.Path, task_id: str, status: str):
    """
    Updates the status of a specific task in tasks.md.
    
    Args:
        spec_path: Path to the specification directory
        task_id: ID of the task to update (e.g., 'TASK-123-001')
        status: New status ('done', 'in-progress', 'blocked')
    """
    tasks_file = spec_path / "tasks.md"
    content = tasks_file.read_text()
    
    # Update checkbox based on status
    if status.lower() == 'done':
        # Change [ ] to [x] for the specific task
        pattern = fr"- \[ \] ({task_id}:.*?)\n"
        replacement = fr"- [x] \1\n"
        updated_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    elif status.lower() == 'in-progress':
        # Change [ ] to [~] for the specific task
        pattern = fr"- \[ \] ({task_id}:.*?)\n"
        replacement = fr"- [~] \1\n"
        updated_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    elif status.lower() == 'blocked':
        # Change [ ] to [!] for the specific task
        pattern = fr"- \[ \] ({task_id}:.*?)\n"
        replacement = fr"- [!] \1\n"
        updated_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    
    # Update progress counts in the "Progress" line
    completed = len(re.findall(r"- \[x\]", updated_content))
    in_progress = len(re.findall(r"- \[~\]", updated_content))
    not_started = len(re.findall(r"- \[ \]", updated_content))
    blocked = len(re.findall(r"- \[!\]", updated_content))
    total = completed + in_progress + not_started + blocked
    
    progress_line = f"## Progress: {completed}/{total} Complete, {in_progress} In Progress, {not_started} Not Started, {blocked} Blocked"
    updated_content = re.sub(r"## Progress:.*", progress_line, updated_content)
    
    # Write updated content back to file
    tasks_file.write_text(updated_content)
    
    return f"✅ Task {task_id} updated to '{status}'. Progress: {completed}/{total} complete."

def _smart_completion(spec_path: pathlib.Path, model, feature_name: str):
    """
    Executes the smart completion process for a feature that's 100% complete.
    
    Args:
        spec_path: Path to the specification directory
        model: The generative model instance
        feature_name: The name of the feature
    """
    # Read all specification files
    req_content = (spec_path / "requirements.md").read_text()
    design_content = (spec_path / "design.md").read_text()
    tasks_content = (spec_path / "tasks.md").read_text()
    
    # 1. Auto-validate acceptance criteria
    validate_prompt = f"""
    You are a quality assurance AI. Review the completed feature specifications and validate 
    that all acceptance criteria have been satisfied by the completed tasks.
    
    **Requirements:**
    ---
    {req_content}
    ---
    
    **Design:**
    ---
    {design_content}
    ---
    
    **Tasks (Completed):**
    ---
    {tasks_content}
    ---
    
    For each acceptance criteria (AC-*) in the requirements, verify if there is corresponding 
    task evidence showing it has been implemented and tested. Generate a validation report.
    """
    print("🔍 Validating acceptance criteria...")
    validation_report = model.generate_content(validate_prompt).text
    print("   -> Done.")
    
    # 2. Generate quality metrics report
    metrics_prompt = f"""
    You are a software metrics AI. Generate a comprehensive quality metrics report 
    for the completed feature. Include:
    
    1. Requirements Satisfaction Score (how well implementation meets requirements)
    2. Code Quality Assessment (inferred from tasks and design)
    3. Test Coverage Analysis
    4. Risk Mitigation Effectiveness
    5. Final Feature Complexity Assessment
    
    **Requirements:**
    ---
    {req_content}
    ---
    
    **Design:**
    ---
    {design_content}
    ---
    
    **Tasks (Completed):**
    ---
    {tasks_content}
    ---
    """
    print("📊 Generating quality metrics...")
    metrics_report = model.generate_content(metrics_prompt).text
    print("   -> Done.")
    
    # 3. Generate retrospective
    retro_prompt = f"""
    You are a project retrospective AI. Analyze the completed feature and generate 
    a retrospective report that identifies:
    
    1. What went well
    2. What could be improved
    3. Lessons learned
    4. Recommendations for future features
    
    Base your analysis on the requirements, design, and completed tasks.
    
    **Requirements:**
    ---
    {req_content}
    ---
    
    **Design:**
    ---
    {design_content}
    ---
    
    **Tasks (Completed):**
    ---
    {tasks_content}
    ---
    """
    print("🔄 Creating retrospective...")
    retrospective = model.generate_content(retro_prompt).text
    print("   -> Done.")
    
    # 4. Archive the completed feature
    done_dir = pathlib.Path("specs/done")
    done_dir.mkdir(parents=True, exist_ok=True)
    
    # Generate a unique hash for the archive
    feature_hash = hashlib.md5(feature_name.encode()).hexdigest()[:8]
    today = datetime.date.today().strftime("%Y%m%d")
    
    # Create archive files
    print("📦 Archiving feature documentation...")
    (done_dir / f"DONE_{today}_{feature_hash}_requirements.md").write_text(req_content)
    (done_dir / f"DONE_{today}_{feature_hash}_design.md").write_text(design_content)
    (done_dir / f"DONE_{today}_{feature_hash}_tasks.md").write_text(tasks_content)
    (done_dir / f"DONE_{today}_{feature_hash}_validation.md").write_text(validation_report)
    (done_dir / f"DONE_{today}_{feature_hash}_metrics.md").write_text(metrics_report)
    (done_dir / f"DONE_{today}_{feature_hash}_retrospective.md").write_text(retrospective)
    print("   -> Done.")
    
    # Generate consolidated completion report
    completion_report = f"""
    # Completion Report: {feature_name}
    
    ## Feature Summary
    - Feature Name: {feature_name}
    - Completion Date: {datetime.date.today().strftime("%Y-%m-%d")}
    - Archive ID: {feature_hash}
    
    ## Validation Summary
    {validation_report[:500]}... [full report in validation.md]
    
    ## Quality Metrics
    {metrics_report[:500]}... [full report in metrics.md]
    
    ## Retrospective Highlights
    {retrospective[:500]}... [full report in retrospective.md]
    
    ## Archival Information
    All feature documentation has been archived in specs/done/ with prefix DONE_{today}_{feature_hash}_
    """
    
    return completion_report

def _comprehensive_verification(feature_name, requirements_content, design_content, tasks_content, model):
    """
    Performs a comprehensive verification of the generated specifications.
    """
    verification_prompt = f"""
    You are a project governance AI specializing in traceability analysis. Perform a 
    comprehensive verification of the specifications for the feature "{feature_name}".
    
    **Requirements:**
    ---
    {requirements_content}
    ---
    
    **Design:**
    ---
    {design_content}
    ---
    
    **Tasks:**
    ---
    {tasks_content}
    ---
    
    Perform these verification steps:
    
    1. Traceability Analysis:
       - Forward Traceability: Verify each requirement traces to design elements and tasks
       - Backward Traceability: Verify each task traces back to requirements
       - Bi-directional Traceability: Verify complete chains exist in both directions
    
    2. Gap Analysis:
       - Missing Coverage: Identify requirements without design elements or tasks
       - Orphaned Elements: Identify design elements or tasks not linked to requirements
       - Incomplete Chains: Identify broken traceability chains
    
    3. Confidence Scoring:
       - Requirements Clarity: Score 0-100%
       - Design Completeness: Score 0-100%
       - Task Specificity: Score 0-100%
       - Overall Traceability: Score 0-100%
    
    4. Risk Assessment:
       - Identify high-risk elements based on complexity and gaps
       - Provide risk mitigation recommendations
    
    Provide your verification results in this format: 
    
    ## Traceability Verification
    - Status: PASSED/FAILED
    - Forward Traceability: X/Y requirements fully traced (Z%)
    - Backward Traceability: X/Y tasks properly traced (Z%)
    - Bi-directional Traceability: X/Y complete chains (Z%)
    
    ## Gap Analysis
    - Missing Coverage: [List requirements without full traceability]
    - Orphaned Elements: [List design elements or tasks without requirements]
    - Incomplete Chains: [List broken traceability chains]
    
    ## Confidence Scores
    - Requirements Clarity: X%
    - Design Completeness: X%
    - Task Specificity: X%
    - Overall Traceability: X%
    
    ## Risk Assessment
    - High-Risk Elements: [List with reasons]
    - Mitigation Recommendations: [List specific recommendations]
    
    ## Improvement Suggestions
    [List specific actions to improve the specifications]
    """
    
    return model.generate_content(verification_prompt).text

def _gemini_md_update_assessment(feature_name, requirements_content, design_content, tasks_content, model):
    """
    Performs a detailed assessment of whether GEMINI.md needs updating
    based on the new feature specifications.
    """
    assessment_prompt = f"""
    You are a project governance AI. Assess whether the parent GEMINI.md file needs 
    updating based on this new feature "{feature_name}".
    
    Carefully examine these triggers for a GEMINI.md update:
    1. New technology stack (framework, database, architecture pattern)
    2. Major architectural decisions that change project direction
    3. New domain concepts or business logic that affects project context
    4. Significant changes to development approach or constraints
    
    **Requirements:**
    ---
    {requirements_content}
    ---
    
    **Design:**
    ---
    {design_content}
    ---
    
    **Tasks:**
    ---
    {tasks_content}
    ---
    
    Assessment Process:
    1. Compare the generated design.md ADRs against current GEMINI.md project context
    2. Identify semantic gaps between new requirements and existing project description
    3. Check if new NFRs introduce constraints not reflected in GEMINI.md
    
    Provide your assessment in this format:
    - Update Needed: YES/NO
    - Reason: [Explain why update is or isn't needed]
    - If update needed, list specific changes required:
      * [Change 1]
      * [Change 2]
      * [Change 3]
    """
    
    return model.generate_content(assessment_prompt).text

@tool
def kiro(command: str, feature_name: str, **kwargs):
    """
    Manages the Traceable Agentic Development (TAD) process.
    
    Args:
        command (str): The action to perform. Options:
            - 'call': Generate new feature specifications
            - 'resume': Reconstruct context for an existing feature
            - 'update': Update task progress status
            - 'complete': Run smart completion process
        feature_name (str): The descriptive name of the feature.
        **kwargs: Additional arguments specific to each command.
            - For 'update': task_id (str), status (str)
    """
    global model
    if not model:
        # In a real scenario, the model is provided by the execution environment.
        # This is a fallback for direct script execution simulation.
        print("Model not initialized. Please run within the Gemini CLI.")
        # Configure a dummy model if needed for local testing
        # import google.generativeai as genai
        # genai.configure(api_key="YOUR_API_KEY")
        # model = genai.GenerativeModel('gemini-1.5-pro-latest')
        # if not model:
        return "Error: Model not available."

    feature_slug = _kebab_case(feature_name)
    spec_path = pathlib.Path(f"specs/{feature_slug}")

    # --- CALL COMMAND: GENERATE NEW FEATURE SPECS ---
    if command.lower() == 'call':
        spec_path.mkdir(parents=True, exist_ok=True)

        print(f"✅ Initialized Kiro TAD process for '{feature_name}' in '{spec_path}/'")

        # --- Phase 1: Generation Sequence ---

        # 1. Generate requirements.md
        requirements_prompt = f"""
        You are a world-class principal software engineer. Your task is to generate the complete content for a `requirements.md` file for the feature named "{feature_name}".
        You must strictly adhere to the following template, filling in all placeholders with plausible, detailed, and semantically coherent information.
        Generate unique UUIDs where required. The parent context is 'GEMINI.md'.

        ```markdown
        # Requirements: {feature_name}
        ## Meta-Context
        - Feature UUID: FEAT-{{generate a unique 8-char hash}}
        - Parent Context: [GEMINI.md]
        - Dependency Graph: {{auto-detect and list potential dependencies, e.g., 'User Service', 'Database Module'}}

        ## Functional Requirements
        ### REQ-{{generate a UUID}}-001: {{A concise name for the primary requirement}}
        Intent Vector: {{AI-generated semantic summary of the requirement}}
        As a [User Persona] I want [Goal] So that [Benefit]
        Business Value: {{1-10}} | Complexity: {{XS/S/M/L/XL}}

        Acceptance Criteria:
        - AC-{{REQ-ID}}-01: GIVEN [context] WHEN [action] THEN [outcome] {{confidence: generate a score, e.g., 95%}}
        - AC-{{REQ-ID}}-02: GIVEN [context] WHEN [action] THEN [outcome] {{confidence: generate a score, e.g., 90%}}

        Validation Hooks: {{list testable assertions, e.g., 'user.is_authenticated() == true'}}
        Risk Factors: {{auto-identify potential risks, e.g., 'Credential stuffing attack'}}

        ## Non-functional Requirements
        - NFR-{{generate a UUID}}-PERF-001: {{a measurable performance target, e.g., 'API response time < 200ms'}}
        - NFR-{{generate a UUID}}-SEC-001: {{a security constraint, e.g., 'Passwords must be hashed using bcrypt'}}
        - NFR-{{generate a UUID}}-UX-001: {{a usability metric, e.g., 'Login flow completion rate > 99%'}}

        ## Traceability Manifest
        Upstream: [{{list dependencies}}] | Downstream: [{{list potential impacts on other features}}] | Coverage: [{{AI-calculated percentage}}]
        ```
        """
        print("📝 Generating requirements.md...")
        requirements_content = model.generate_content(requirements_prompt).text
        (spec_path / "requirements.md").write_text(requirements_content)
        print("   -> Done.")

        # 2. Generate design.md
        design_prompt = f"""
        You are a world-class software architect. Given the following `requirements.md` for the feature "{feature_name}", generate the corresponding `design.md` file.
        Ensure every design decision, component, and API endpoint traces directly back to the provided requirements and acceptance criteria.
        Use the exact IDs (REQ-..., AC-..., NFR-...) from the requirements content.

        **Requirements Context:**
        ---
        {requirements_content}
        ---

        **Your Task:**
        Generate the `design.md` file using this EXACT template:

        ```markdown
        # Design: {feature_name}
        ## ADRs (Architectural Decision Records)
        ### ADR-001: {{A key architectural decision}}
        Status: Proposed | Context: {{background for the decision}} | Decision: {{the chosen approach}} | Rationale: {{why this approach was chosen}}
        Requirements: {{Link to specific REQ-ID(s)}} | Confidence: {{generate a score, e.g., 95%}} | Alternatives: [{{list rejected options}}]

        ## Components
        ### Modified: [{{Name of an existing component to be changed}}] → Fulfills: {{Link to specific AC-ID(s)}}
        Changes: {{specific modifications to be made}}

        ### New: [{{Name of a new component}}] → Responsibility: {{requirement-linked purpose}}
        Interface:
        ```typescript
        interface NewComponent {{
          // Link methods to specific acceptance criteria
          method1(): Promise<T> // Fulfills: AC-...-01
          method2(input: I): O  // Fulfills: AC-...-02
        }}
        ```

        ## API Matrix
        | Endpoint | Method | Requirements | Test Strategy | Errors |
        |----------|--------|--------------|---------------|--------|
        | /api/x   | POST   | {{Link to AC-IDs}} | Unit+Integration | {{auto-suggest potential errors}} |

        ## Data Flow + Traceability
        {{Briefly describe the data flow, linking steps to NFRs and REQs}}
        1. Input Validation → {{Link to NFR-SEC-ID}}
        2. Business Logic → {{Link to REQ-ID}}
        3. Output → {{Link to AC-ID}}

        ## Quality Gates
        - ADRs: >80% confidence to requirements
        - Interfaces: trace to acceptance criteria
        - NFRs: measurable test plans
        ```
        """
        print("🗄️ Generating design.md...")
        design_content = model.generate_content(design_prompt).text
        (spec_path / "design.md").write_text(design_content)
        print("   -> Done.")

        # 3. Generate tasks.md
        tasks_prompt = f"""
        You are an expert technical project manager. Based on the provided requirements and design for the feature "{feature_name}", generate a `tasks.md` execution blueprint.
        Break down the work into logical, actionable tasks. Ensure every task traces back to specific elements in the design and requirements documents.
        Use the exact IDs from the provided context.

        **Requirements Context:**
        ---
        {requirements_content}
        ---

        **Design Context:**
        ---
        {design_content}
        ---

        **Your Task:**
        Generate the `tasks.md` file using this EXACT template:

        ```markdown
        # Tasks: {feature_name}
        ## Metadata
        Complexity: {{AI-calculated S/M/L}} | Critical Path: {{sequence of crucial tasks}} | Risk: {{score}} | Timeline: {{rough estimate}}

        ## Progress: 0/X Complete, 0 In Progress, 0 Not Started, 0 Blocked

        ## Phase 1: Foundation
        - [ ] TASK-{{generate a UUID}}-001: {{Descriptive task name}}
          Trace: {{Link to REQ-ID}} | Design: {{Link to Design Component/ADR}} | AC: {{Link to AC-ID}}
          DoD: [{{Definition of Done criteria}}] | Risk: Low | Deps: None | Effort: {{story points}}

        - [ ] TASK-{{generate a UUID}}-002: {{Descriptive task name}}
          Trace: {{Link to REQ-ID}} | Design: {{Link to Design method/element}} | AC: {{Link to AC-ID}}
          DoD: [{{Definition of Done criteria}}] | Risk: Medium | Deps: TASK-...-001 | Effort: {{story points}}

        ## Phase 2: Integration
        - [ ] TASK-{{generate a UUID}}-003: API Implementation
          Trace: {{Link to REQ-ID}} | Design: POST /api/x | AC: {{Link to AC-ID}}
          DoD: [{{Definition of Done criteria}}] | Risk: Low | Deps: TASK-...-002 | Effort: {{story points}}

        ## Phase 3: QA
        - [ ] TASK-{{generate a UUID}}-004: Test Suite
          Trace: ALL AC-* | Design: Test implementation | AC: 100% coverage + NFR validation
          DoD: [{{Definition of Done criteria}}] | Risk: Medium | Deps: All prev | Effort: {{story points}}

        ## Verification Checklist
        - [ ] Every REQ-* → implementing task
        - [ ] Every AC-* → test coverage
        - [ ] Every NFR-* → measurable validation
        - [ ] All design elements → specific tasks
        - [ ] Risk mitigation for Medium+ risks
        ```

        The tasks must be complete, realistic, and fully trace back to the requirements and design elements. Ensure every task has a clear Definition of Done (DoD) that can be objectively verified.
        """
        print("📋 Generating tasks.md...")
        tasks_content = model.generate_content(tasks_prompt).text
        (spec_path / "tasks.md").write_text(tasks_content)
        print("   -> Done.")

        # 4. Auto-Verification
        print("🔎 Performing comprehensive verification...")
        verification_report = _comprehensive_verification(feature_name, requirements_content, design_content, tasks_content, model)
        print("   -> Done.")

        # 5. GEMINI.md Update Assessment
        print("🔄 Assessing GEMINI.md update needs...")
        gemini_assessment = _gemini_md_update_assessment(feature_name, requirements_content, design_content, tasks_content, model)
        print("   -> Done.")

        # Display reports
        print("\n---VERIFICATION REPORT---")
        print(verification_report)
        print("\n---GEMINI.MD ASSESSMENT---")
        print(gemini_assessment)
        print("---")

        return f"✅ Kiro process complete for '{feature_name}'. Files are in '{spec_path}'."

    # --- RESUME COMMAND: RECONSTRUCT CONTEXT ---
    elif command.lower() == 'resume':
        if not spec_path.exists():
            return f"❌ Error: No specifications found for feature '{feature_name}' at '{spec_path}'."

        try:
            req_content = (spec_path / "requirements.md").read_text()
            des_content = (spec_path / "design.md").read_text()
            tsk_content = (spec_path / "tasks.md").read_text()
        except FileNotFoundError as e:
            return f"❌ Error: Missing a file in the spec directory: {e.filename}"

        resume_prompt = f"""
        You are an AI agent resuming work on the feature "{feature_name}". You have just been provided with the complete project specification files.
        Your task is to read, understand, and reconstruct the full semantic context and traceability graph in your memory.
        Then, provide a concise summary of the project's current state (requirements intent, key design decisions, and task progress).
        Conclude by confirming you are ready to proceed with the full context maintained.

        **Requirements File Content:**
        ---
        {req_content}
        ---

        **Design File Content:**
        ---
        {des_content}
        ---

        **Tasks File Content:**
        ---
        {tsk_content}
        ---
        """
        print(f"🧠 Resuming context for '{feature_name}'...")
        resume_summary = model.generate_content(resume_prompt).text
        return resume_summary
        
    # --- UPDATE COMMAND: UPDATE TASK STATUS ---
    elif command.lower() == 'update':
        if not spec_path.exists():
            return f"❌ Error: No specifications found for feature '{feature_name}' at '{spec_path}'."
        
        task_id = kwargs.get('task_id')
        status = kwargs.get('status', 'done')
        
        if not task_id:
            return f"❌ Error: Missing task_id parameter for 'update' command."
        
        return _update_task_status(spec_path, task_id, status)
        
    # --- COMPLETE COMMAND: RUN SMART COMPLETION ---
    elif command.lower() == 'complete':
        if not spec_path.exists():
            return f"❌ Error: No specifications found for feature '{feature_name}' at '{spec_path}'."
            
        # Check if all tasks are marked as complete
        tasks_file = spec_path / "tasks.md"
        tasks_content = tasks_file.read_text()
        
        total_tasks = len(re.findall(r"- \[ [x~ !] \]", tasks_content))
        completed_tasks = len(re.findall(r"- \[x\]", tasks_content))
        
        if completed_tasks < total_tasks:
            return f"⚠️ Warning: Not all tasks are complete ({completed_tasks}/{total_tasks}). Use 'kiro update' to mark tasks as complete first."
            
        return _smart_completion(spec_path, model, feature_name)
        
    else:
        return f"❌ Invalid command '{command}'. Please use 'call', 'resume', 'update', or 'complete'."
