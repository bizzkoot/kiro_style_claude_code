#!/usr/bin/env node

/**
 * EARS Context Injection System (TASK-E5A8F3B2-008)
 * 
 * EARS Context: WHEN delegating to subagents, SHALL provide specific EARS acceptance criteria
 * AC-E5A8F3B2-003-01: Provide specific EARS acceptance criteria that must be satisfied
 * AC-E5A8F3B2-003-02: Maintain minimal necessary context from requirements.md and design.md
 * 
 * Implementation: Minimal context extraction with requirements.md parsing
 * Risk: Medium | Effort: 6pts
 */

const fs = require('fs').promises;
const path = require('path');

class EARSContextInjectionSystem {
    constructor() {
        this.contextCache = new Map();
        this.performanceMetrics = {
            contextExtractions: 0,
            avgExtractionTime: 0,
            cacheHits: 0,
            cacheMisses: 0
        };
    }

    /**
     * EARS Context: WHEN delegating to subagents, SHALL provide specific EARS acceptance criteria
     * AC-E5A8F3B2-003-01: Extract and provide specific EARS acceptance criteria
     * 
     * @param {string} requirementsPath - Path to requirements.md file
     * @param {string} designPath - Path to design.md file (optional)
     * @param {string} taskId - Specific task ID for context focus
     * @returns {Promise<Object>} Minimal EARS context package
     */
    async extractEARSContext(requirementsPath, designPath = null, taskId = null) {
        const extractionStart = performance.now();
        
        try {
            // Check cache first for performance optimization
            const cacheKey = `${requirementsPath}:${designPath}:${taskId}`;
            if (this.contextCache.has(cacheKey)) {
                this.performanceMetrics.cacheHits++;
                console.log('🔄 [EARS Context] Using cached context extraction');
                return this.contextCache.get(cacheKey);
            }

            this.performanceMetrics.cacheMisses++;
            console.log('🔍 [EARS Context] Extracting minimal context from specifications...');

            // Parse requirements.md for EARS acceptance criteria
            const requirementsContext = await this.parseRequirementsFile(requirementsPath);
            
            // Parse design.md for behavioral contracts (if provided)
            let designContext = null;
            if (designPath) {
                designContext = await this.parseDesignFile(designPath);
            }

            // Filter context based on task ID if provided
            const filteredContext = taskId 
                ? this.filterContextByTask(requirementsContext, designContext, taskId)
                : this.createGeneralContext(requirementsContext, designContext);

            // Create minimal EARS context package
            const earsContext = this.buildMinimalContextPackage(filteredContext);

            // Cache the result for performance
            this.contextCache.set(cacheKey, earsContext);

            const extractionTime = performance.now() - extractionStart;
            this.updatePerformanceMetrics(extractionTime);

            console.log(`✅ [EARS Context] Extracted ${earsContext.acceptance_criteria.length} acceptance criteria in ${extractionTime.toFixed(1)}ms`);
            
            return earsContext;

        } catch (error) {
            console.error('❌ [EARS Context] Extraction failed:', error.message);
            throw new Error(`EARS context extraction failed: ${error.message}`);
        }
    }

    /**
     * Parse requirements.md file and extract EARS acceptance criteria
     * EARS Format: WHEN/WHILE/IF/WHERE + trigger/condition + SHALL + behavior
     * 
     * @param {string} requirementsPath - Path to requirements.md
     * @returns {Promise<Object>} Parsed requirements with EARS criteria
     */
    async parseRequirementsFile(requirementsPath) {
        try {
            const content = await fs.readFile(requirementsPath, 'utf8');
            
            // Extract EARS acceptance criteria using regex pattern
            const earsPattern = /AC-[A-Za-z0-9-]+-\d+-\d+:\s+(WHEN|WHILE|IF|WHERE)\s+(.+?)\s+SHALL\s+(.+?)(?=\s*\{|$)/gm;
            const acceptanceCriteria = [];
            let match;

            while ((match = earsPattern.exec(content)) !== null) {
                const [fullMatch, trigger, condition, behavior] = match;
                const acId = fullMatch.split(':')[0].trim();
                
                acceptanceCriteria.push({
                    id: acId,
                    trigger: trigger,
                    condition: condition.trim(),
                    behavior: behavior.trim(),
                    fullText: fullMatch,
                    behavioralContract: `${trigger} ${condition.trim()}, SHALL ${behavior.trim()}`
                });
            }

            // Extract feature summary and metadata
            const featureSummary = this.extractFeatureSummary(content);
            const constraints = this.extractConstraints(content);
            const dependencies = this.extractDependencies(content);

            return {
                featureSummary,
                acceptanceCriteria,
                constraints,
                dependencies,
                filePath: requirementsPath
            };

        } catch (error) {
            throw new Error(`Failed to parse requirements file ${requirementsPath}: ${error.message}`);
        }
    }

    /**
     * Parse design.md file for behavioral contracts and architectural constraints
     * 
     * @param {string} designPath - Path to design.md
     * @returns {Promise<Object>} Parsed design with behavioral contracts
     */
    async parseDesignFile(designPath) {
        try {
            const content = await fs.readFile(designPath, 'utf8');
            
            // Extract behavioral contracts from design
            const behavioralContracts = this.extractBehavioralContracts(content);
            
            // Extract architectural constraints
            const architecturalConstraints = this.extractArchitecturalConstraints(content);
            
            // Extract component interfaces with EARS specifications
            const componentInterfaces = this.extractComponentInterfaces(content);

            return {
                behavioralContracts,
                architecturalConstraints,
                componentInterfaces,
                filePath: designPath
            };

        } catch (error) {
            throw new Error(`Failed to parse design file ${designPath}: ${error.message}`);
        }
    }

    /**
     * Extract feature summary from requirements content
     */
    extractFeatureSummary(content) {
        // Look for feature description or intent vector
        const intentMatch = content.match(/Intent Vector:\s*(.+?)$/m);
        if (intentMatch) {
            return intentMatch[1].trim();
        }

        // Fallback: Use first paragraph or header
        const lines = content.split('\n').filter(line => line.trim());
        for (const line of lines) {
            if (line.startsWith('#') && line.length > 5) {
                return line.replace(/^#+\s*/, '').trim();
            }
            if (line.length > 50 && !line.startsWith('##') && !line.includes(':')) {
                return line.trim();
            }
        }

        return 'Feature implementation with EARS compliance';
    }

    /**
     * Extract constraints from requirements content
     */
    extractConstraints(content) {
        const constraints = [];
        
        // Look for NFR (Non-functional Requirements) sections
        const nfrPattern = /NFR-[A-Za-z0-9-]+-[A-Z]+-\d+:\s*(.+?)$/gm;
        let match;
        
        while ((match = nfrPattern.exec(content)) !== null) {
            constraints.push(match[1].trim());
        }

        // Look for explicit constraints section
        const constraintsSection = content.match(/## Constraints\s*\n([\s\S]*?)(?=\n##|$)/i);
        if (constraintsSection) {
            const constraintItems = constraintsSection[1].match(/[-*]\s*(.+)/g);
            if (constraintItems) {
                constraints.push(...constraintItems.map(item => item.replace(/[-*]\s*/, '').trim()));
            }
        }

        return constraints.length > 0 ? constraints : ['EARS compliance required', 'Performance within acceptable limits'];
    }

    /**
     * Extract dependencies from requirements content
     */
    extractDependencies(content) {
        const dependencies = [];
        
        // Look for dependencies section
        const depsSection = content.match(/## Dependencies\s*\n([\s\S]*?)(?=\n##|$)/i);
        if (depsSection) {
            const depItems = depsSection[1].match(/[-*]\s*(.+)/g);
            if (depItems) {
                dependencies.push(...depItems.map(item => item.replace(/[-*]\s*/, '').trim()));
            }
        }

        // Look for ADR references
        const adrPattern = /ADR-\d+/g;
        const adrMatches = content.match(adrPattern);
        if (adrMatches) {
            dependencies.push(...adrMatches.map(adr => `Architecture decision: ${adr}`));
        }

        return dependencies.length > 0 ? dependencies : ['None specified'];
    }

    /**
     * Extract behavioral contracts from design content
     */
    extractBehavioralContracts(content) {
        const contracts = [];
        
        // Look for interface definitions with EARS format
        const interfacePattern = /interface\s+\w+\s*\{[\s\S]*?\}/g;
        const interfaces = content.match(interfacePattern);
        
        if (interfaces) {
            for (const interfaceDef of interfaces) {
                const earsComments = interfaceDef.match(/\/\/\s*(WHEN|WHILE|IF|WHERE).+?SHALL.+/g);
                if (earsComments) {
                    contracts.push(...earsComments.map(comment => comment.replace(/\/\/\s*/, '')));
                }
            }
        }

        // Look for explicit behavioral contracts section
        const contractsSection = content.match(/## Behavioral Contracts?\s*\n([\s\S]*?)(?=\n##|$)/i);
        if (contractsSection) {
            const contractItems = contractsSection[1].match(/[-*]\s*(.+)/g);
            if (contractItems) {
                contracts.push(...contractItems.map(item => item.replace(/[-*]\s*/, '').trim()));
            }
        }

        return contracts;
    }

    /**
     * Extract architectural constraints from design content
     */
    extractArchitecturalConstraints(content) {
        const constraints = [];
        
        // Look for ADR (Architectural Decision Records)
        const adrPattern = /### ADR-\d+:(.+?)\n[\s\S]*?Decision:\s*(.+?)$/gm;
        let match;
        
        while ((match = adrPattern.exec(content)) !== null) {
            constraints.push(`${match[1].trim()}: ${match[2].trim()}`);
        }

        return constraints;
    }

    /**
     * Extract component interfaces from design content
     */
    extractComponentInterfaces(content) {
        const interfaces = [];
        
        // Look for component definitions
        const componentPattern = /### (?:New|Modified):\s+(.+?)\s+→\s+Responsibility:\s+(.+?)$/gm;
        let match;
        
        while ((match = componentPattern.exec(content)) !== null) {
            interfaces.push({
                component: match[1].trim(),
                responsibility: match[2].trim()
            });
        }

        return interfaces;
    }

    /**
     * Filter context based on specific task ID
     * AC-E5A8F3B2-003-02: Maintain minimal necessary context
     */
    filterContextByTask(requirementsContext, designContext, taskId) {
        // Filter acceptance criteria relevant to the task
        const relevantAC = requirementsContext.acceptanceCriteria.filter(ac => 
            ac.id.includes(taskId) || ac.behavior.toLowerCase().includes(taskId.toLowerCase())
        );

        // If no specific match, take first 3 most relevant criteria
        const finalAC = relevantAC.length > 0 ? relevantAC : requirementsContext.acceptanceCriteria.slice(0, 3);

        return {
            requirements: {
                ...requirementsContext,
                acceptanceCriteria: finalAC
            },
            design: designContext,
            taskFocus: taskId
        };
    }

    /**
     * Create general context for broad implementation
     */
    createGeneralContext(requirementsContext, designContext) {
        // Limit to essential acceptance criteria for minimal context
        const essentialAC = requirementsContext.acceptanceCriteria.slice(0, 5);

        return {
            requirements: {
                ...requirementsContext,
                acceptanceCriteria: essentialAC
            },
            design: designContext,
            taskFocus: 'general'
        };
    }

    /**
     * Build minimal EARS context package for subagent delegation
     * Structure defined in design.md: EARSContext interface
     */
    buildMinimalContextPackage(filteredContext) {
        const { requirements, design, taskFocus } = filteredContext;

        return {
            requirement_id: requirements.acceptanceCriteria[0]?.id || 'GENERAL',
            acceptance_criteria: requirements.acceptanceCriteria.map(ac => ({
                id: ac.id,
                trigger: ac.trigger,
                condition: ac.condition,
                behavior: ac.behavior,
                fullText: ac.fullText
            })),
            behavioral_contracts: [
                ...requirements.acceptanceCriteria.map(ac => ac.behavioralContract),
                ...(design?.behavioralContracts || [])
            ],
            minimal_context: {
                feature_summary: requirements.featureSummary,
                constraints: requirements.constraints.slice(0, 3), // Limit for minimality
                dependencies: requirements.dependencies.slice(0, 3), // Limit for minimality
                task_focus: taskFocus,
                architectural_constraints: design?.architecturalConstraints?.slice(0, 2) || [],
                component_interfaces: design?.componentInterfaces?.slice(0, 3) || []
            },
            metadata: {
                extracted_at: new Date().toISOString(),
                source_files: [
                    requirements.filePath,
                    ...(design ? [design.filePath] : [])
                ],
                context_size: this.calculateContextSize(requirements, design),
                validation_required: true
            }
        };
    }

    /**
     * Calculate context size for optimization monitoring
     */
    calculateContextSize(requirements, design) {
        const reqSize = JSON.stringify(requirements).length;
        const designSize = design ? JSON.stringify(design).length : 0;
        return {
            requirements_bytes: reqSize,
            design_bytes: designSize,
            total_bytes: reqSize + designSize,
            acceptance_criteria_count: requirements.acceptanceCriteria.length
        };
    }

    /**
     * Update performance metrics for monitoring
     */
    updatePerformanceMetrics(extractionTime) {
        this.performanceMetrics.contextExtractions++;
        this.performanceMetrics.avgExtractionTime = 
            (this.performanceMetrics.avgExtractionTime + extractionTime) / 2;
    }

    /**
     * Create delegation prompt with EARS context injection
     * Used by ThreePhaseExecutionController for actual delegation
     */
    createDelegationPrompt(agentName, task, earsContext) {
        const prompt = `@${agentName}: 

Please ${task} following these EARS acceptance criteria:

**Required Acceptance Criteria:**
${earsContext.acceptance_criteria.map(ac => 
    `- ${ac.id}: ${ac.trigger} ${ac.condition}, SHALL ${ac.behavior}`
).join('\n')}

**Behavioral Contracts:**
${earsContext.behavioral_contracts.slice(0, 3).map(bc => `- ${bc}`).join('\n')}

**Context:**
- Feature: ${earsContext.minimal_context.feature_summary}
- Constraints: ${earsContext.minimal_context.constraints.join(', ')}
- Dependencies: ${earsContext.minimal_context.dependencies.join(', ')}

**Expected Output:** 
Implementation that satisfies all specified EARS acceptance criteria with clear validation against behavioral contracts.

**Validation Required:** All outputs will be validated against the original EARS behavioral contracts before integration.`;

        return prompt;
    }

    /**
     * Validate subagent output against EARS context
     * Used in Phase 3 Implementation for output validation
     */
    validateOutputAgainstEARS(output, earsContext) {
        const validation = {
            contextId: earsContext.requirement_id,
            timestamp: new Date().toISOString(),
            passed: true,
            details: [],
            violations: []
        };

        // Check if output addresses each acceptance criterion
        for (const ac of earsContext.acceptance_criteria) {
            const addressed = this.checkAcceptanceCriterionAddressed(output, ac);
            
            if (addressed.satisfied) {
                validation.details.push(`✅ ${ac.id}: ${addressed.evidence}`);
            } else {
                validation.passed = false;
                validation.violations.push(`❌ ${ac.id}: ${addressed.issue}`);
            }
        }

        // Check behavioral contract compliance
        for (const contract of earsContext.behavioral_contracts.slice(0, 2)) {
            const compliant = this.checkBehavioralContractCompliance(output, contract);
            
            if (!compliant.satisfied) {
                validation.passed = false;
                validation.violations.push(`⚠️ Contract: ${compliant.issue}`);
            }
        }

        validation.score = validation.passed ? 100 : 
            Math.max(0, 100 - (validation.violations.length * 20));

        return validation;
    }

    /**
     * Check if output addresses specific acceptance criterion
     */
    checkAcceptanceCriterionAddressed(output, acceptanceCriterion) {
        const outputLower = output.toLowerCase();
        const behaviorKeywords = acceptanceCriterion.behavior.toLowerCase().split(' ')
            .filter(word => word.length > 3);

        const keywordMatches = behaviorKeywords.filter(keyword => 
            outputLower.includes(keyword)
        );

        if (keywordMatches.length >= Math.ceil(behaviorKeywords.length * 0.6)) {
            return {
                satisfied: true,
                evidence: `Implementation addresses key behaviors: ${keywordMatches.join(', ')}`
            };
        } else {
            return {
                satisfied: false,
                issue: `Missing key behaviors from EARS criterion: ${behaviorKeywords.join(', ')}`
            };
        }
    }

    /**
     * Check behavioral contract compliance
     */
    checkBehavioralContractCompliance(output, behavioralContract) {
        // Basic compliance check - can be enhanced with more sophisticated analysis
        const contractKeywords = behavioralContract.toLowerCase().match(/shall\s+(.+?)(?=\s+and|\s+but|$)/);
        
        if (contractKeywords && contractKeywords[1]) {
            const requiredBehavior = contractKeywords[1];
            const behaviorWords = requiredBehavior.split(' ').filter(word => word.length > 3);
            
            const matches = behaviorWords.filter(word => 
                output.toLowerCase().includes(word)
            ).length;
            
            if (matches >= Math.ceil(behaviorWords.length * 0.5)) {
                return { satisfied: true };
            } else {
                return {
                    satisfied: false,
                    issue: `Behavioral contract not addressed: ${requiredBehavior}`
                };
            }
        }

        return { satisfied: true }; // Default pass for unclear contracts
    }

    /**
     * Get performance and usage metrics
     */
    getMetrics() {
        return {
            contextExtractions: this.performanceMetrics.contextExtractions,
            avgExtractionTime: `${this.performanceMetrics.avgExtractionTime.toFixed(1)}ms`,
            cacheHits: this.performanceMetrics.cacheHits,
            cacheMisses: this.performanceMetrics.cacheMisses,
            cacheEfficiency: this.performanceMetrics.cacheHits + this.performanceMetrics.cacheMisses > 0 
                ? `${((this.performanceMetrics.cacheHits / (this.performanceMetrics.cacheHits + this.performanceMetrics.cacheMisses)) * 100).toFixed(1)}%`
                : '0%',
            cacheSize: this.contextCache.size
        };
    }

    /**
     * Clear context cache for testing or memory management
     */
    clearCache() {
        this.contextCache.clear();
        console.log('🗑️ EARS context cache cleared');
    }
}

// Export for use in enhanced kiro-implementer
module.exports = { EARSContextInjectionSystem };

// CLI usage when run directly
if (require.main === module) {
    const earsSystem = new EARSContextInjectionSystem();
    
    async function demonstrateEARSExtraction() {
        try {
            const exampleReqPath = './specs/enhanced-subagent-integration/requirements.md';
            const exampleDesignPath = './specs/enhanced-subagent-integration/design.md';
            
            console.log('🚀 EARS Context Injection System Demo');
            console.log('=====================================');
            
            const context = await earsSystem.extractEARSContext(
                exampleReqPath, 
                exampleDesignPath, 
                'E5A8F3B2-003'
            );
            
            console.log('\n📋 Extracted EARS Context:');
            console.log('- Requirement ID:', context.requirement_id);
            console.log('- Acceptance Criteria Count:', context.acceptance_criteria.length);
            console.log('- Behavioral Contracts Count:', context.behavioral_contracts.length);
            console.log('- Feature Summary:', context.minimal_context.feature_summary);
            
            console.log('\n🎯 Sample Delegation Prompt:');
            const samplePrompt = earsSystem.createDelegationPrompt(
                'code-reviewer',
                'review the implementation for EARS compliance',
                context
            );
            console.log(samplePrompt);
            
            console.log('\n📊 Performance Metrics:');
            console.log(earsSystem.getMetrics());
            
        } catch (error) {
            console.error('Demo failed:', error.message);
        }
    }
    
    demonstrateEARSExtraction();
}