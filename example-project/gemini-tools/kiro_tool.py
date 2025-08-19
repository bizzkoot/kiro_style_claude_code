import pathlib
import re
import datetime
import hashlib
import uuid
import json
from typing import Dict, List, Optional, Any, Tuple
from google.generativeai.function_calling import tool

# ==============================================================================
# Kiro TAD Workflow Tools for Gemini CLI
# ==============================================================================
# This script has been enhanced with state-of-the-art prompt engineering techniques
# and optimizations specifically for the Gemini CLI agent.
#
# Advanced Architectural Principles:
# 1.  **Optimized Delegation to Host Agent**: The tools provide rich semantic context
#     to the Gemini CLI's built-in ReAct agent, leveraging its advanced reasoning.
#     Each tool returns detailed prompts with reasoning structures that improve 
#     the quality of generated content.
# 2.  **Context-Preserving Tools**: Functions now include metadata and context
#     preservation mechanisms to maintain semantic coherence across interactions.
# 3.  **Chain-of-Thought Workflow Generation**: Tools now return step-by-step
#     reasoning prompts that guide the Gemini agent through complex processes with
#     explicit reasoning chains.
# 4.  **Enhanced Token Efficiency**: All prompts are optimized for token usage
#     while preserving semantic richness, using proven patterns from recent 
#     prompt engineering research.
# ==============================================================================


def _kebab_case(name: str) -> str:
    """Converts a string to kebab-case for file-safe naming."""
    name = re.sub(r'(?<!^)(?=[A-Z])', '-', name).lower()
    return re.sub(r'[\s_]+', '-', name)


def _generate_uuid(prefix: str = "") -> str:
    """Generates a short UUID (8 characters) with optional prefix."""
    return f"{prefix}{uuid.uuid4().hex[:8]}"


def _get_date_stamp() -> str:
    """Returns the current date in YYYYMMDD format."""
    return datetime.datetime.now().strftime("%Y%m%d")


class ContextMetadata:
    """Maintains metadata about the current development context for richer prompts."""
    
    def __init__(self):
        self.last_feature: Optional[str] = None
        self.feature_history: List[str] = []
        self.interaction_count: int = 0
        self.creation_date = _get_date_stamp()
    
    def update_feature_context(self, feature_name: str) -> None:
        """Updates the feature context with a new feature."""
        if self.last_feature != feature_name:
            self.last_feature = feature_name
            if feature_name not in self.feature_history:
                self.feature_history.append(feature_name)
        self.interaction_count += 1
    
    def get_context_summary(self) -> Dict[str, Any]:
        """Returns a summary of the current context for rich prompts."""
        return {
            "last_feature": self.last_feature,
            "feature_history": self.feature_history,
            "interaction_count": self.interaction_count,
            "session_age": f"{int((datetime.datetime.now() - datetime.datetime.strptime(self.creation_date, '%Y%m%d')).total_seconds() / 60)} minutes"
        }


# Global context tracker to enhance prompt quality
context_tracker = ContextMetadata()


@tool
def generate_feature_specs(feature_name: str, description: Optional[str] = None):
    """
    Generates a multi-step plan for the Gemini CLI agent to create a complete
    set of specification documents (requirements, design, tasks) for a new feature.
    Uses advanced prompt engineering with chain-of-thought reasoning.

    Args:
        feature_name (str): The descriptive name of the new feature.
        description (str, optional): Additional context or description for the feature.

    Returns:
        str: A detailed prompt with explicit reasoning steps for the agent.
    """
    feature_slug = _kebab_case(feature_name)
    spec_path = f"specs/{feature_slug}"
    feature_uuid = _generate_uuid("FEAT-")
    
    # Update context for richer future interactions
    context_tracker.update_feature_context(feature_name)
    
    # This enhanced prompt uses explicit reasoning steps and context preservation
    # to achieve higher quality results from the Gemini agent
    return f"""
    I'll help you generate comprehensive specifications for the feature '{feature_name}'. This will involve creating three interconnected documents following the Traceable Agentic Development (TAD) methodology.

    **Context Assessment:**
    - Feature Name: {feature_name}
    - Feature UUID: {feature_uuid}
    - Feature Path: {spec_path}
    - Additional Context: {description if description else "None provided"}

    **Reasoning Process:**
    I'll approach this methodically, starting with understanding the core requirements, then designing the technical solution, and finally breaking down the implementation into actionable tasks. Each document will maintain semantic traceability to the others.

    **Step 1: Requirements Analysis**
    Let me generate the `requirements.md` file with:
    - A clear feature purpose statement
    - Functional requirements with unique IDs
    - Acceptance criteria for each requirement
    - Non-functional requirements (performance, security, etc.)
    - Traceability links to existing system components

    **Step 2: Design Solution**
    Based on the requirements, I'll create `design.md` with:
    - Architectural decisions with explicit reasoning
    - Component diagrams and relationships
    - API specifications that fulfill specific requirements
    - Data models and state management approach
    - Security and performance considerations

    **Step 3: Implementation Planning**
    Using both requirements and design, I'll develop `tasks.md` with:
    - Task breakdown by implementation phase
    - Clear traceability to requirements and design elements
    - Estimated effort and complexity
    - Dependencies between tasks
    - Progress tracking mechanisms

    **Step 4: Documentation Organization**
    I'll ensure all documents are saved in the correct location with consistent formatting and cross-referencing.

    **Plan Execution:**

    1.  **Generate requirements.md:**
        I'll create a comprehensive requirements document with the following structure:

        ```markdown
        # Requirements: {feature_name}
        ## Meta-Context
        - Feature UUID: {feature_uuid}
        - Parent Context: [GEMINI.md]
        - Dependency Graph: {{I'll analyze and list potential dependencies}}

        ## Functional Requirements
        {{I'll create 3-5 detailed requirements with unique IDs, each with:}}
        - Intent vector (semantic summary)
        - User story format
        - Business value and complexity rating
        - 2-3 specific acceptance criteria
        - Validation hooks and risk factors

        ## Non-functional Requirements
        {{I'll define measurable non-functional requirements for:}}
        - Performance expectations
        - Security constraints
        - Usability metrics
        - Reliability standards

        ## Traceability Manifest
        {{I'll identify upstream and downstream connections to other system components}}
        ```

    2.  **Create design.md:**
        Using the requirements as my foundation, I'll develop a detailed design document:

        ```markdown
        # Design: {feature_name}
        ## Architectural Decision Records
        {{I'll create 2-3 ADRs that explicitly trace back to specific requirements}}
        - Status and context
        - Decision with explicit reasoning
        - Considered alternatives
        - Implementation consequences

        ## Components
        {{I'll define the component structure with interfaces that fulfill specific requirements}}
        - New and modified components
        - Responsibility mappings to requirements
        - Interface definitions with parameter types

        ## Data Models
        {{I'll define any data structures needed}}

        ## API Matrix
        {{I'll create a comprehensive API table with requirement traceability}}
        ```

    3.  **Develop tasks.md:**
        Drawing from both requirements and design, I'll create an implementation plan:

        ```markdown
        # Tasks: {feature_name}
        ## Metadata
        {{I'll calculate complexity metrics and identify the critical path}}

        ## Progress: 0/X Complete, 0 In Progress, X Not Started, 0 Blocked

        ## Implementation Phases
        {{I'll organize tasks into logical phases with clear dependencies}}
        - Each task will have a unique ID
        - Explicit traces to requirements and design elements
        - Definition of Done criteria
        - Risk assessment and effort estimation
        ```

    I'll now execute this plan step by step, generating high-quality content for each document and saving them to the correct location. I'll ensure strong semantic connections between all documents to maintain complete traceability throughout the development lifecycle.
    """


@tool
def _apply_task_update_logic(tasks_content: str, task_id: str, status: str) -> str:
    """
    A pure function tool that applies status update logic to the string content of a tasks.md file.
    It performs regex replacements to update a task's checkbox and the overall progress summary line.
    This tool does NO file I/O.

    Args:
        tasks_content (str): The full string content of the tasks.md file.
        task_id (str): The ID of the task to update (e.g., 'TASK-123-001').
        status (str): The new status ('done', 'in-progress', 'blocked').

    Returns:
        str: The updated string content of the tasks.md file.
    """
    content = tasks_content
    status_map = {
        'done': ('- [x]', r'- \[ \] ({task_id}:.*?)'),
        'in-progress': ('- [~]', r'- \[ \] ({task_id}:.*?)'),
        'blocked': ('- [!]', r'- \[ \] ({task_id}:.*?)'),
    }

    if status.lower() in status_map:
        replacement_char, pattern_template = status_map[status.lower()]
        pattern = pattern_template.format(task_id=re.escape(task_id))
        replacement = fr"{replacement_char} \1"
        content = re.sub(pattern, replacement, content, flags=re.DOTALL | re.MULTILINE)

    # Recalculate progress counts from the updated content
    completed = len(re.findall(r"-\s\[x\]", content))
    in_progress = len(re.findall(r"-\s\[~\]", content))
    not_started = len(re.findall(r"-\s\[ \]", content))
    blocked = len(re.findall(r"-\s\[!\]", content))
    total = completed + in_progress + not_started + blocked

    progress_line = f"## Progress: {completed}/{total} Complete, {in_progress} In Progress, {not_started} Not Started, {blocked} Blocked"
    updated_content = re.sub(r"## Progress:.*", progress_line, content)

    return updated_content


@tool
def update_task_status(feature_name: str, task_id: str, status: str, reasoning: Optional[str] = None):
    """
    Generates a plan for the Gemini CLI agent to update the status of a single task
    in the feature's tasks.md file, with enhanced reasoning capabilities.

    Args:
        feature_name (str): The descriptive name of the feature.
        task_id (str): The ID of the task to update.
        status (str): The new status. Must be one of 'done', 'in-progress', or 'blocked'.
        reasoning (str, optional): The reasoning behind the status update for documentation.

    Returns:
        str: A prompt instructing the agent on the read-modify-write workflow with reasoning.
    """
    feature_slug = _kebab_case(feature_name)
    tasks_file_path = f"specs/{feature_slug}/tasks.md"
    
    # Update context tracker
    context_tracker.update_feature_context(feature_name)
    context_summary = context_tracker.get_context_summary()
    
    # Enhanced prompt with reasoning structure and context preservation
    return f"""
    I'll update task '{task_id}' to status '{status}' for the feature '{feature_name}'. I'll approach this with careful reasoning to ensure the update is correct and properly documented.

    **Context Assessment:**
    - Feature: {feature_name} (Slug: {feature_slug})
    - Task ID: {task_id}
    - New Status: {status}
    - Reasoning: {reasoning if reasoning else "None provided"}
    - Session Context: This is interaction #{context_summary["interaction_count"]} in this session

    **Reasoning Process:**
    1. First, I need to retrieve the current tasks file to understand its structure and the current state of the task.
    2. Then I'll analyze the task's current status and ensure the update is valid.
    3. Next, I'll apply the status change while preserving all other content.
    4. Finally, I'll update the progress summary to reflect the new status distribution.

    **Execution Plan:**

    1.  **Read Current Content:** 
        I need to retrieve the current content of `{tasks_file_path}` to understand the task's current state and context.

    2.  **Analyze Current State:**
        Once I have the content, I'll:
        - Verify the task exists in the file
        - Identify its current status
        - Understand its relationship to other tasks
        - Ensure the status change is logical

    3.  **Apply Status Update:**
        I'll use the `_apply_task_update_logic` tool to:
        - Change the task's checkbox marker based on status:
          - 'done' → '[x]'
          - 'in-progress' → '[~]'
          - 'blocked' → '[!]'
        - Recalculate the overall progress metrics
        - Preserve all other content and formatting

    4.  **Save Updated Content:**
        I'll write the modified content back to `{tasks_file_path}` while ensuring:
        - No other tasks are modified
        - The file format remains consistent
        - The progress summary is accurate

    5.  **Provide Confirmation:**
        I'll confirm the update with:
        - The task's new status
        - Updated progress metrics
        - Any relevant context from the reasoning provided

    Let me execute this plan now to update the task status.
    """


@tool
def complete_feature(feature_name: str, quality_focus: Optional[str] = None):
    """
    Generates a plan for the Gemini CLI agent to run the smart completion process.
    This involves validating, generating reports, and archiving a completed feature.
    Enhanced with quality focus options and reasoning structure.

    Args:
        feature_name (str): The descriptive name of the feature to complete.
        quality_focus (str, optional): Specific quality aspects to focus on during validation
                                       (e.g., 'security', 'performance', 'usability').

    Returns:
        str: A prompt instructing the agent on the multi-step completion workflow with explicit reasoning.
    """
    feature_slug = _kebab_case(feature_name)
    spec_path = f"specs/{feature_slug}"
    done_dir = "specs/done"
    feature_hash = hashlib.md5(feature_name.encode()).hexdigest()[:8]
    today = datetime.date.today().strftime("%Y%m%d")
    
    # Update context tracker
    context_tracker.update_feature_context(feature_name)
    
    # Enhanced prompt with reasoning structure and quality focus
    return f"""
    I'll execute the smart completion and archival process for the feature '{feature_name}'. This process will thoroughly validate the feature's completeness, generate quality metrics, create a retrospective, and properly archive all documentation.

    **Context Assessment:**
    - Feature: {feature_name} (Slug: {feature_slug})
    - Quality Focus: {quality_focus if quality_focus else "Balanced assessment across all quality dimensions"}
    - Archive Identifier: DONE_{today}_{feature_hash}
    - Archive Location: {done_dir}

    **Reasoning Process:**
    I'll approach this completion process systematically, applying critical analysis at each stage:

    1. First, I'll gather and analyze all specification documents to build a complete understanding of the feature.
    2. Then, I'll verify that all tasks are actually complete - this is a prerequisite for proceeding.
    3. Next, I'll validate that all acceptance criteria have been met with implementation evidence.
    4. I'll assess the overall quality and generate metrics across key dimensions.
    5. I'll conduct a retrospective analysis to identify strengths and improvement opportunities.
    6. Finally, I'll organize and archive all documentation for future reference.

    **Execution Plan:**

    1.  **Document Retrieval and Analysis:**
        I'll read all specification documents to build a comprehensive understanding:
        - `{spec_path}/requirements.md`: To understand the intended functionality
        - `{spec_path}/design.md`: To verify the technical implementation approach
        - `{spec_path}/tasks.md`: To confirm all tasks are marked complete

    2.  **Completion Verification:**
        I'll analyze the tasks file to ensure all tasks are marked as complete before proceeding.
        This is a critical gate - if any tasks remain open, I'll stop and provide a detailed report
        of what remains to be done.

    3.  **Acceptance Criteria Validation:**
        For each requirement, I'll:
        - Extract all acceptance criteria
        - Verify evidence of implementation in tasks and design
        - Identify any gaps or inconsistencies
        - Generate a comprehensive validation report with traceability links

    4.  **Quality Metrics Assessment:**
        I'll generate quantitative and qualitative metrics focusing on:
        - Requirements Satisfaction: How completely the implementation meets requirements
        - Design Integrity: Consistency between design and implementation
        - Code Quality: Inferred from implementation descriptions
        - Test Coverage: Extent of testing for each component
        - {quality_focus if quality_focus else "Overall Feature Completeness"}

    5.  **Retrospective Analysis:**
        I'll perform a detailed retrospective that examines:
        - Successful approaches and practices worth continuing
        - Challenges encountered and how they were overcome
        - Opportunities for process improvement
        - Knowledge gained that could benefit future features

    6.  **Archive Creation:**
        I'll save all documents to the archive location with clear naming:
        - Original specifications: requirements, design, tasks
        - Generated reports: validation, metrics, retrospective
        - All with consistent naming: DONE_{today}_{feature_hash}_[document-type].md

    7.  **Summary Report Generation:**
        I'll create a concise but comprehensive completion report summarizing:
        - Feature overview and purpose
        - Key implementation highlights
        - Quality assessment summary
        - Archive location details
        - Next steps or recommendations

    Let me now execute this plan to properly complete and archive the feature.
    """


@tool
def resume_feature_context(feature_name: str, focus_area: Optional[str] = None):
    """
    Generates a plan for the Gemini CLI agent to read all specification files for an
    existing feature and provide a summary to reconstruct the context.
    Enhanced with focus area targeting and semantic summarization.

    Args:
        feature_name (str): The descriptive name of the feature to resume.
        focus_area (str, optional): Specific aspect to focus on (e.g., 'requirements',
                                    'design', 'implementation', 'testing').

    Returns:
        str: A prompt instructing the agent on the read-and-summarize workflow with
             enhanced semantic understanding.
    """
    feature_slug = _kebab_case(feature_name)
    spec_path = f"specs/{feature_slug}"
    
    # Update context tracker
    context_tracker.update_feature_context(feature_name)
    context_summary = context_tracker.get_context_summary()
    
    # Determine if this feature has been seen before
    feature_familiarity = "This feature appears in your history" if feature_name in context_summary["feature_history"] else "This is a new feature for this session"
    
    # Enhanced prompt with context awareness and semantic understanding guidance
    return f"""
    I'll help you resume work on the feature '{feature_name}' by reconstructing its complete context from the existing specification documents. This will give you a comprehensive understanding of the feature's current state.

    **Context Assessment:**
    - Feature: {feature_name} (Slug: {feature_slug})
    - Focus Area: {focus_area if focus_area else "Complete feature overview"}
    - Feature Familiarity: {feature_familiarity}
    - Documentation Path: {spec_path}

    **Reasoning Process:**
    I'll approach this systematically to build a complete mental model of the feature:

    1. First, I'll gather all specification documents to understand the feature from multiple perspectives.
    2. Then, I'll extract the core intent and key requirements to establish the fundamental purpose.
    3. Next, I'll analyze the technical design decisions and their rationale to understand the implementation approach.
    4. I'll examine the task breakdown to assess current progress and remaining work.
    5. Finally, I'll synthesize all this information into a coherent semantic understanding of the entire feature.

    **Execution Plan:**

    1.  **Document Retrieval:**
        I'll read all specification files to build a complete picture:
        - `{spec_path}/requirements.md`: To understand the WHY and WHAT
        - `{spec_path}/design.md`: To understand the HOW
        - `{spec_path}/tasks.md`: To understand the implementation plan and progress

    2.  **Requirements Analysis:**
        I'll extract and summarize:
        - Core feature purpose and value proposition
        - Key functional requirements and their priority
        - Acceptance criteria that define success
        - Non-functional requirements that shape the solution

    3.  **Design Understanding:**
        I'll analyze and summarize:
        - Major architectural decisions and their rationale
        - Component structure and relationships
        - API specifications and data models
        - Security and performance considerations

    4.  **Implementation Status Assessment:**
        I'll evaluate:
        - Overall progress metrics (complete/in-progress/not-started/blocked)
        - Completed work and its alignment with requirements
        - Current tasks in progress and their status
        - Blocked items and their dependencies
        - Remaining work to be done

    5.  **Contextual Synthesis:**
        I'll create a cohesive mental model that connects:
        - Requirements to design decisions (why specific approaches were chosen)
        - Design elements to implementation tasks (how the design is being realized)
        - Current status to overall completion (what remains to be done)
        {f"- Particular emphasis on {focus_area} aspects" if focus_area else ""}

    Let me execute this plan to rebuild the complete context for the '{feature_name}' feature.
    """


@tool
def generate_feature_roadmap(feature_names: List[str], timeline: Optional[str] = None, dependencies: Optional[Dict[str, List[str]]] = None):
    """
    Generates a comprehensive feature roadmap with timeline visualization and dependency tracking.
    
    Args:
        feature_names (List[str]): List of feature names to include in the roadmap.
        timeline (str, optional): Timeline specification (e.g., 'Q1-Q2 2025', '6 months').
        dependencies (Dict[str, List[str]], optional): Dictionary mapping features to their dependencies.
        
    Returns:
        str: A prompt instructing the agent to create a detailed feature roadmap with visualizations.
    """
    # Create consistent IDs for features
    feature_ids = {name: _kebab_case(name) for name in feature_names}
    
    # Update context for richer future interactions
    for feature in feature_names:
        context_tracker.update_feature_context(feature)
    
    return f"""
    I'll create a comprehensive feature roadmap for the specified features, incorporating timeline projections and dependency relationships.
    
    **Context Assessment:**
    - Features: {", ".join(feature_names)}
    - Timeline Scope: {timeline if timeline else "Not specified, will analyze appropriate timeframe"}
    - Dependencies Provided: {"Yes, will incorporate into planning" if dependencies else "No, will infer logical dependencies"}
    
    **Reasoning Process:**
    I'll approach this roadmap creation methodically:
    
    1. First, I'll gather information about each feature to understand scope and complexity.
    2. Then, I'll analyze dependencies to establish a logical execution order.
    3. Next, I'll distribute features across the timeline based on dependencies and capacity.
    4. Finally, I'll create visualizations to communicate the roadmap effectively.
    
    **Execution Plan:**
    
    1.  **Feature Analysis:**
        For each feature, I'll:
        - Read existing specifications if available
        - Estimate complexity and effort
        - Identify key milestones within each feature
        - Determine critical vs. flexible timing requirements
    
    2.  **Dependency Mapping:**
        I'll create a comprehensive dependency graph:
        - Technical dependencies (what must be built first)
        - Resource dependencies (who needs to work on what)
        - External dependencies (third-party integrations, etc.)
        - Visualize as a directed graph for clarity
    
    3.  **Timeline Development:**
        I'll create a timeline visualization with:
        - Features plotted across time periods
        - Clear indication of dependencies
        - Milestone markers and delivery dates
        - Resource allocation considerations
        - Parallel development opportunities
    
    4.  **Roadmap Documentation:**
        I'll produce a complete roadmap document with:
        - Executive summary of the delivery plan
        - Feature-by-feature breakdown with rationale
        - Visual timeline representation
        - Risk assessment and mitigation strategies
        - Key decision points and alternatives
    
    Let me now execute this plan to create your feature roadmap.
    """


@tool
def analyze_implementation_options(feature_name: str, technology_constraints: Optional[List[str]] = None, evaluation_criteria: Optional[List[str]] = None):
    """
    Generates a comprehensive analysis of implementation options for a feature with explicit tradeoff evaluation.
    
    Args:
        feature_name (str): The name of the feature to analyze.
        technology_constraints (List[str], optional): Technology constraints to consider.
        evaluation_criteria (List[str], optional): Specific criteria to evaluate options against.
        
    Returns:
        str: A prompt instructing the agent to conduct a detailed implementation options analysis.
    """
    feature_slug = _kebab_case(feature_name)
    spec_path = f"specs/{feature_slug}"
    
    # Update context for richer future interactions
    context_tracker.update_feature_context(feature_name)
    
    # Default evaluation criteria if none provided
    default_criteria = [
        "development speed",
        "maintainability",
        "performance",
        "security",
        "scalability"
    ]
    
    criteria = evaluation_criteria if evaluation_criteria else default_criteria
    
    return f"""
    I'll conduct a thorough analysis of implementation options for the '{feature_name}' feature, evaluating different approaches against your criteria and constraints.
    
    **Context Assessment:**
    - Feature: {feature_name}
    - Technology Constraints: {", ".join(technology_constraints) if technology_constraints else "None specified"}
    - Evaluation Criteria: {", ".join(criteria)}
    - Documentation Path: {spec_path}
    
    **Reasoning Process:**
    I'll approach this analysis systematically:
    
    1. First, I'll understand the feature requirements to establish evaluation baselines.
    2. Then, I'll identify multiple viable implementation approaches.
    3. Next, I'll evaluate each approach against the specified criteria.
    4. Finally, I'll provide a recommendation with explicit reasoning.
    
    **Execution Plan:**
    
    1.  **Requirements Review:**
        I'll read the feature specifications to understand:
        - Core functionality requirements
        - Performance and scalability needs
        - Integration points with existing systems
        - Non-functional requirements that impact implementation
    
    2.  **Implementation Options Identification:**
        I'll develop 3-4 distinct implementation approaches, considering:
        - Technology stacks and frameworks
        - Architecture patterns
        - Build vs. buy decisions
        - Development and deployment approaches
    
    3.  **Comparative Analysis:**
        For each option, I'll evaluate:
        {chr(10).join([f"        - {criterion}: Detailed assessment with quantitative metrics where possible" for criterion in criteria])}
        - Development resource requirements
        - Time to market implications
        - Risk factors and mitigation strategies
    
    4.  **Decision Matrix Creation:**
        I'll create a weighted decision matrix:
        - Each criterion with appropriate weighting
        - Each option scored against each criterion
        - Calculation of weighted scores
        - Visualization of comparative strengths/weaknesses
    
    5.  **Recommendation Development:**
        I'll provide a clear recommendation that includes:
        - Preferred implementation approach with rationale
        - Key advantages over alternatives
        - Potential challenges and mitigation strategies
        - Implementation plan outline
    
    Let me execute this plan to analyze implementation options for '{feature_name}'.
    """


@tool
def generate_integration_test_plan(feature_name: str, test_environments: Optional[List[str]] = None, test_priority: Optional[str] = None):
    """
    Generates a comprehensive integration test plan for a feature with explicit test case design.
    
    Args:
        feature_name (str): The name of the feature to create a test plan for.
        test_environments (List[str], optional): Environments to include in the test plan.
        test_priority (str, optional): Priority focus for testing (e.g., 'security', 'performance').
        
    Returns:
        str: A prompt instructing the agent to create a detailed integration test plan.
    """
    feature_slug = _kebab_case(feature_name)
    spec_path = f"specs/{feature_slug}"
    
    # Update context for richer future interactions
    context_tracker.update_feature_context(feature_name)
    
    # Default test environments if none provided
    default_environments = ["development", "staging", "production"]
    environments = test_environments if test_environments else default_environments
    
    return f"""
    I'll create a comprehensive integration test plan for the '{feature_name}' feature, designed to validate its functionality and integration with other system components.
    
    **Context Assessment:**
    - Feature: {feature_name}
    - Test Environments: {", ".join(environments)}
    - Test Priority: {test_priority if test_priority else "Balanced testing across all aspects"}
    - Documentation Path: {spec_path}
    
    **Reasoning Process:**
    I'll develop this test plan methodically:
    
    1. First, I'll understand the feature requirements to identify testable aspects.
    2. Then, I'll design specific test cases that verify functionality and integration.
    3. Next, I'll define test data requirements and environment configurations.
    4. Finally, I'll create a structured test execution strategy with clear pass/fail criteria.
    
    **Execution Plan:**
    
    1.  **Requirements Analysis:**
        I'll review the feature specifications to identify:
        - Functional requirements to validate
        - Integration points with other components
        - Performance and security expectations
        - Edge cases and error handling scenarios
    
    2.  **Test Case Design:**
        I'll create detailed test cases covering:
        - Happy path scenarios that verify core functionality
        - Edge cases that test boundary conditions
        - Error handling and recovery scenarios
        - Integration verification with other components
        - {f"Enhanced focus on {test_priority} testing" if test_priority else ""}
    
    3.  **Test Environment Configuration:**
        For each environment ({", ".join(environments)}), I'll specify:
        - Required configuration parameters
        - Test data setup requirements
        - Mocking/stubbing strategies for dependencies
        - Monitoring and logging considerations
    
    4.  **Test Execution Strategy:**
        I'll develop an execution plan that includes:
        - Test sequencing and dependencies
        - Required tools and frameworks
        - Automation opportunities and approaches
        - Manual testing requirements
        - Pass/fail criteria for each test case
    
    5.  **Test Documentation:**
        I'll create comprehensive test documentation with:
        - Test case inventory with traceability to requirements
        - Test data specifications
        - Environment setup instructions
        - Expected results and verification methods
        - Defect reporting procedures
    
    Let me execute this plan to create a detailed integration test plan for '{feature_name}'.
    """