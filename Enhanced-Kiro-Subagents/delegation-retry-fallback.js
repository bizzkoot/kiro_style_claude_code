#!/usr/bin/env node

/**
 * Delegation Retry and Fallback Logic (TASK-E5A8F3B2-010)
 * 
 * EARS Context: IF subagent output fails EARS compliance validation, SHALL retry with enhanced context
 * AC-E5A8F3B2-003-03: Retry with enhanced context or fall back to direct implementation
 * 
 * Implementation: Progressive context enhancement with graceful degradation
 * Risk: Medium | Effort: 5pts
 */

const fs = require('fs').promises;
const { EARSContextInjectionSystem } = require('./ears-context-injection');
const { BehavioralContractValidationEngine } = require('./behavioral-contract-validator');

class DelegationRetryFallbackSystem {
    constructor() {
        this.earsSystem = new EARSContextInjectionSystem();
        this.validator = new BehavioralContractValidationEngine();
        this.retryStrategies = this.initializeRetryStrategies();
        this.fallbackStrategies = this.initializeFallbackStrategies();
        this.delegationHistory = [];
        this.performanceMetrics = {
            totalDelegations: 0,
            successOnFirstTry: 0,
            successAfterRetry: 0,
            fallbacksTriggered: 0,
            avgRetryCount: 0,
            mostCommonFailureReasons: new Map()
        };
    }

    /**
     * Initialize retry strategies for different types of validation failures
     */
    initializeRetryStrategies() {
        return {
            MISSING_CONTEXT: {
                name: 'Enhanced Context Injection',
                description: 'Provide additional context from design.md and dependencies',
                maxRetries: 2,
                strategy: this.enhanceContextStrategy.bind(this)
            },
            BEHAVIORAL_VIOLATION: {
                name: 'Detailed Behavioral Guidance',
                description: 'Include specific behavioral contract examples and patterns',
                maxRetries: 1,
                strategy: this.enhanceBehavioralGuidanceStrategy.bind(this)
            },
            INCOMPLETE_IMPLEMENTATION: {
                name: 'Implementation Completeness',
                description: 'Add missing acceptance criteria and validation checkpoints',
                maxRetries: 1,
                strategy: this.enhanceCompletenessStrategy.bind(this)
            },
            TECHNICAL_COMPLEXITY: {
                name: 'Technical Complexity Breakdown',
                description: 'Break down complex requirements into simpler sub-tasks',
                maxRetries: 2,
                strategy: this.simplifyComplexityStrategy.bind(this)
            }
        };
    }

    /**
     * Initialize fallback strategies when retries fail
     */
    initializeFallbackStrategies() {
        return {
            DIRECT_IMPLEMENTATION: {
                name: 'Direct Implementation Mode',
                description: 'Fall back to standard kiro-implementer without delegation',
                priority: 1,
                handler: this.directImplementationFallback.bind(this)
            },
            HUMAN_ESCALATION: {
                name: 'Human Developer Escalation',
                description: 'Escalate to human developer with detailed context',
                priority: 2,
                handler: this.humanEscalationFallback.bind(this)
            },
            SIMPLIFIED_DELEGATION: {
                name: 'Simplified Delegation',
                description: 'Retry with simpler, more general subagent',
                priority: 3,
                handler: this.simplifiedDelegationFallback.bind(this)
            }
        };
    }

    /**
     * Main delegation method with retry and fallback logic
     * AC-E5A8F3B2-003-03: IF subagent output fails validation, SHALL retry with enhanced context or fallback
     * 
     * @param {string} agentName - Name of the subagent to delegate to
     * @param {string} task - Task description
     * @param {Object} earsContext - Original EARS context
     * @param {Object} options - Delegation options and constraints
     * @returns {Promise<Object>} Final delegation result with retry/fallback information
     */
    async delegateWithRetryFallback(agentName, task, earsContext, options = {}) {
        const delegationStart = performance.now();
        const delegationId = this.generateDelegationId();
        
        console.log(`🎯 [Delegation ${delegationId}] Starting delegation to @${agentName}`);
        console.log(`📋 [Delegation ${delegationId}] Task: ${task.substring(0, 100)}...`);
        
        const delegationSession = {
            delegationId,
            agentName,
            task,
            originalContext: earsContext,
            startTime: new Date().toISOString(),
            attempts: [],
            finalResult: null,
            fallbackUsed: null,
            totalTime: 0,
            status: 'IN_PROGRESS'
        };

        try {
            // Attempt 1: Initial delegation
            const firstAttempt = await this.attemptDelegation(agentName, task, earsContext, 1);
            delegationSession.attempts.push(firstAttempt);

            if (firstAttempt.validationResult.overallResult === 'PASSED') {
                console.log(`✅ [Delegation ${delegationId}] SUCCESS on first attempt`);
                delegationSession.status = 'SUCCESS';
                delegationSession.finalResult = firstAttempt;
                this.performanceMetrics.successOnFirstTry++;
                
                return this.finalizeDelegationSession(delegationSession, delegationStart);
            }

            // Determine retry strategy based on validation failures
            const retryStrategy = this.determineRetryStrategy(firstAttempt.validationResult);
            
            if (retryStrategy && firstAttempt.attemptCount < retryStrategy.maxRetries + 1) {
                console.log(`🔄 [Delegation ${delegationId}] Retrying with strategy: ${retryStrategy.name}`);
                
                // Attempt retry with enhanced context
                const enhancedContext = await retryStrategy.strategy(earsContext, firstAttempt.validationResult);
                const retryAttempt = await this.attemptDelegation(agentName, task, enhancedContext, 2);
                delegationSession.attempts.push(retryAttempt);

                if (retryAttempt.validationResult.overallResult === 'PASSED' || 
                    retryAttempt.validationResult.overallResult === 'CONDITIONAL_PASS') {
                    console.log(`✅ [Delegation ${delegationId}] SUCCESS after retry`);
                    delegationSession.status = 'SUCCESS_AFTER_RETRY';
                    delegationSession.finalResult = retryAttempt;
                    this.performanceMetrics.successAfterRetry++;
                    
                    return this.finalizeDelegationSession(delegationSession, delegationStart);
                }
            }

            // All retries failed - trigger fallback
            console.log(`⚠️ [Delegation ${delegationId}] Retries exhausted, triggering fallback`);
            const fallbackResult = await this.triggerFallback(delegationSession, options);
            delegationSession.fallbackUsed = fallbackResult.strategy;
            delegationSession.finalResult = fallbackResult;
            delegationSession.status = 'FALLBACK_SUCCESS';
            this.performanceMetrics.fallbacksTriggered++;

            return this.finalizeDelegationSession(delegationSession, delegationStart);

        } catch (error) {
            console.error(`❌ [Delegation ${delegationId}] Delegation failed:`, error.message);
            delegationSession.status = 'FAILED';
            delegationSession.error = error.message;
            
            return this.finalizeDelegationSession(delegationSession, delegationStart);
        }
    }

    /**
     * Attempt single delegation with validation
     */
    async attemptDelegation(agentName, task, earsContext, attemptNumber) {
        const attemptStart = performance.now();
        
        try {
            // Simulate subagent delegation (in real implementation, this would call Claude with @agent format)
            const delegationPrompt = this.earsSystem.createDelegationPrompt(agentName, task, earsContext);
            
            console.log(`🔍 [Attempt ${attemptNumber}] Delegating to @${agentName}...`);
            
            // Simulate subagent response (in real implementation, this would be actual subagent output)
            const subagentOutput = await this.simulateSubagentResponse(agentName, task, earsContext, attemptNumber);
            
            // Validate the output against behavioral contracts
            const validationResult = await this.validator.validateAgainstBehavioralContracts(
                subagentOutput,
                earsContext.behavioral_contracts,
                earsContext
            );

            const attemptTime = performance.now() - attemptStart;
            
            return {
                attemptCount: attemptNumber,
                agentName,
                delegationPrompt: this.sanitizePromptForLogging(delegationPrompt),
                subagentOutput: this.sanitizeOutputForLogging(subagentOutput),
                validationResult,
                attemptTime: attemptTime,
                timestamp: new Date().toISOString()
            };

        } catch (error) {
            throw new Error(`Delegation attempt ${attemptNumber} failed: ${error.message}`);
        }
    }

    /**
     * Determine appropriate retry strategy based on validation failures
     */
    determineRetryStrategy(validationResult) {
        const violations = validationResult.criticalViolations;
        const score = validationResult.overallScore;

        // Analysis-based strategy selection
        if (score < 30) {
            return this.retryStrategies.MISSING_CONTEXT;
        } else if (violations.some(v => v.violation.includes('behavior'))) {
            return this.retryStrategies.BEHAVIORAL_VIOLATION;
        } else if (violations.some(v => v.violation.includes('incomplete'))) {
            return this.retryStrategies.INCOMPLETE_IMPLEMENTATION;
        } else if (violations.length > 2) {
            return this.retryStrategies.TECHNICAL_COMPLEXITY;
        }

        return this.retryStrategies.MISSING_CONTEXT; // Default strategy
    }

    /**
     * Enhanced Context Strategy: Add more context from design and dependencies
     */
    async enhanceContextStrategy(originalContext, validationResult) {
        console.log('🔧 [Retry Strategy] Enhancing context with additional information...');
        
        const enhancedContext = JSON.parse(JSON.stringify(originalContext));
        
        // Add more detailed constraints
        enhancedContext.minimal_context.constraints.push(
            'Implementation must explicitly address all EARS acceptance criteria',
            'Output should include validation steps for behavioral contracts'
        );
        
        // Add more behavioral contracts
        enhancedContext.behavioral_contracts.push(
            ...validationResult.criticalViolations.map(v => `Enhanced: ${v.contract}`)
        );
        
        // Add specific guidance based on violations
        enhancedContext.enhanced_guidance = {
            validation_failures: validationResult.criticalViolations.map(v => v.violation),
            specific_requirements: [
                'Include explicit validation logic for each EARS criterion',
                'Address all behavioral contract requirements directly',
                'Provide clear evidence of requirement fulfillment'
            ],
            examples: this.generateExamplesForViolations(validationResult.criticalViolations)
        };

        return enhancedContext;
    }

    /**
     * Behavioral Guidance Strategy: Add specific behavioral contract examples
     */
    async enhanceBehavioralGuidanceStrategy(originalContext, validationResult) {
        console.log('🎯 [Retry Strategy] Adding detailed behavioral guidance...');
        
        const enhancedContext = JSON.parse(JSON.stringify(originalContext));
        
        enhancedContext.behavioral_guidance = {
            contract_patterns: {
                'WHEN_SHALL': 'Event-triggered behavior: Implement event handler that performs action when trigger occurs',
                'WHILE_SHALL': 'Continuous behavior: Implement ongoing monitoring/maintenance logic',
                'IF_SHALL': 'Conditional behavior: Implement conditional logic with clear branching',
                'WHERE_SHALL': 'Boundary behavior: Implement boundary condition validation and response'
            },
            implementation_examples: this.generateImplementationExamples(originalContext.acceptance_criteria),
            validation_checklist: [
                'Does implementation handle the trigger condition?',
                'Does implementation perform the required behavior?',
                'Are edge cases and error conditions addressed?',
                'Is the implementation testable against the EARS criteria?'
            ]
        };

        return enhancedContext;
    }

    /**
     * Completeness Strategy: Add missing acceptance criteria and checkpoints
     */
    async enhanceCompletenessStrategy(originalContext, validationResult) {
        console.log('📝 [Retry Strategy] Adding completeness checkpoints...');
        
        const enhancedContext = JSON.parse(JSON.stringify(originalContext));
        
        enhancedContext.completeness_requirements = {
            mandatory_elements: [
                'Address every acceptance criterion explicitly',
                'Include error handling for all failure scenarios',
                'Provide validation logic for all behavioral contracts',
                'Include appropriate logging and monitoring'
            ],
            validation_checkpoints: originalContext.acceptance_criteria.map(ac => ({
                criterion: ac.id,
                checkpoint: `Verify: ${ac.behavior}`,
                validation_method: `Test: ${ac.trigger} ${ac.condition}`
            })),
            success_indicators: [
                'All EARS criteria have corresponding implementation',
                'Behavioral contracts are explicitly satisfied',
                'Implementation includes comprehensive error handling'
            ]
        };

        return enhancedContext;
    }

    /**
     * Complexity Strategy: Break down complex requirements
     */
    async simplifyComplexityStrategy(originalContext, validationResult) {
        console.log('🔨 [Retry Strategy] Breaking down complexity...');
        
        const enhancedContext = JSON.parse(JSON.stringify(originalContext));
        
        // Simplify by focusing on highest priority criteria
        const prioritizedCriteria = originalContext.acceptance_criteria
            .slice(0, Math.min(3, originalContext.acceptance_criteria.length));
        
        enhancedContext.acceptance_criteria = prioritizedCriteria;
        enhancedContext.complexity_reduction = {
            simplified_focus: 'Focus on core acceptance criteria first',
            phased_approach: prioritizedCriteria.map((ac, index) => ({
                phase: index + 1,
                criterion: ac.id,
                simplified_requirement: this.simplifyRequirement(ac)
            })),
            implementation_hints: [
                'Start with the simplest requirement first',
                'Build incrementally toward full compliance',
                'Validate each phase before proceeding to next'
            ]
        };

        return enhancedContext;
    }

    /**
     * Trigger fallback when retries are exhausted
     */
    async triggerFallback(delegationSession, options) {
        console.log(`🛡️ [Fallback] Initiating fallback for delegation ${delegationSession.delegationId}`);
        
        // Select fallback strategy based on options and failure analysis
        const fallbackStrategy = this.selectFallbackStrategy(delegationSession, options);
        
        console.log(`🔄 [Fallback] Using strategy: ${fallbackStrategy.name}`);
        
        try {
            const fallbackResult = await fallbackStrategy.handler(delegationSession, options);
            
            console.log(`✅ [Fallback] Success with ${fallbackStrategy.name}`);
            
            return {
                strategy: fallbackStrategy.name,
                result: fallbackResult,
                success: true,
                timestamp: new Date().toISOString()
            };

        } catch (error) {
            console.error(`❌ [Fallback] Failed:`, error.message);
            throw new Error(`Fallback strategy ${fallbackStrategy.name} failed: ${error.message}`);
        }
    }

    /**
     * Select appropriate fallback strategy
     */
    selectFallbackStrategy(delegationSession, options) {
        // Default to direct implementation for most cases
        if (options.allowDirectImplementation !== false) {
            return this.fallbackStrategies.DIRECT_IMPLEMENTATION;
        }
        
        // Human escalation if direct implementation not allowed
        if (options.allowHumanEscalation === true) {
            return this.fallbackStrategies.HUMAN_ESCALATION;
        }
        
        // Simplified delegation as last resort
        return this.fallbackStrategies.SIMPLIFIED_DELEGATION;
    }

    /**
     * Direct Implementation Fallback Handler
     */
    async directImplementationFallback(delegationSession, options) {
        console.log('🔧 [Direct Implementation] Switching to standard kiro-implementer mode...');
        
        const directResult = {
            implementation_mode: 'DIRECT',
            message: `Subagent delegation to @${delegationSession.agentName} failed validation. Proceeding with direct implementation.`,
            task: delegationSession.task,
            original_context: delegationSession.originalContext,
            implementation_guidance: [
                'Implement requirements directly following EARS acceptance criteria',
                'Ensure all behavioral contracts are satisfied',
                'Include comprehensive validation and error handling',
                'Test against original EARS requirements'
            ],
            next_steps: [
                'Review original EARS context and acceptance criteria',
                'Implement functionality directly without delegation',
                'Validate implementation against behavioral contracts',
                'Document any limitations or technical debt'
            ],
            delegation_analysis: {
                failed_agent: delegationSession.agentName,
                attempts_made: delegationSession.attempts.length,
                common_failures: this.analyzeCommonFailures(delegationSession.attempts),
                recommendations: [
                    'Consider improving subagent prompts for similar future tasks',
                    'Review EARS context injection effectiveness',
                    'Evaluate if task complexity exceeds subagent capabilities'
                ]
            }
        };

        return directResult;
    }

    /**
     * Human Escalation Fallback Handler
     */
    async humanEscalationFallback(delegationSession, options) {
        console.log('🚨 [Human Escalation] Escalating to human developer...');
        
        const escalationPackage = {
            escalation_type: 'DELEGATION_FAILURE',
            urgency: 'MEDIUM',
            summary: `Subagent delegation to @${delegationSession.agentName} failed after multiple attempts`,
            context: {
                task: delegationSession.task,
                agent: delegationSession.agentName,
                attempts: delegationSession.attempts.length,
                primary_failures: delegationSession.attempts.map(a => a.validationResult.criticalViolations).flat(),
                ears_context: delegationSession.originalContext
            },
            recommended_actions: [
                'Review subagent capabilities and limitations',
                'Consider task decomposition or different approach',
                'Evaluate EARS context injection effectiveness',
                'Implement task manually with full EARS compliance'
            ],
            escalation_data: {
                delegation_history: delegationSession,
                validation_failures: this.summarizeValidationFailures(delegationSession),
                performance_impact: 'Delegation retry process may have performance implications',
                business_impact: 'Feature implementation may be delayed pending manual resolution'
            }
        };

        return escalationPackage;
    }

    /**
     * Simplified Delegation Fallback Handler
     */
    async simplifiedDelegationFallback(delegationSession, options) {
        console.log('📉 [Simplified Delegation] Attempting delegation with general-purpose agent...');
        
        // Create simplified context
        const simplifiedContext = {
            requirement_id: delegationSession.originalContext.requirement_id,
            acceptance_criteria: delegationSession.originalContext.acceptance_criteria.slice(0, 2), // Take only first 2
            behavioral_contracts: delegationSession.originalContext.behavioral_contracts.slice(0, 2),
            minimal_context: {
                feature_summary: delegationSession.originalContext.minimal_context.feature_summary,
                constraints: ['EARS compliance required'],
                dependencies: ['None'],
                task_focus: 'simplified'
            }
        };

        const simplifiedResult = {
            delegation_mode: 'SIMPLIFIED',
            target_agent: 'general-purpose',
            simplified_context: simplifiedContext,
            message: 'Attempting delegation with reduced complexity and general-purpose agent',
            success_criteria: [
                'Basic functionality implementation',
                'Core acceptance criteria satisfaction',
                'Minimal EARS compliance'
            ],
            limitations: [
                'Reduced feature completeness',
                'May require additional refinement',
                'Limited specialized knowledge application'
            ]
        };

        return simplifiedResult;
    }

    /**
     * Helper Methods
     */
    generateDelegationId() {
        return `DEL-${Date.now().toString(36)}-${Math.random().toString(36).substr(2, 5)}`.toUpperCase();
    }

    async simulateSubagentResponse(agentName, task, earsContext, attemptNumber) {
        // Simulate different quality responses based on attempt number and context
        const baseResponse = `I have implemented the requested functionality for: ${task}`;
        
        if (attemptNumber === 1) {
            // First attempt - moderate implementation
            return `${baseResponse}
            
The implementation includes basic functionality but may be missing some EARS compliance details.
I have addressed the main requirements but might need additional context for complete behavioral contract satisfaction.`;
        } else {
            // Retry attempt - improved implementation with enhanced context
            return `${baseResponse}

Enhanced implementation with full EARS compliance:
- Explicitly addresses all acceptance criteria: ${earsContext.acceptance_criteria.map(ac => ac.id).join(', ')}
- Implements required behaviors: ${earsContext.acceptance_criteria.map(ac => ac.behavior).join(', ')}
- Includes comprehensive error handling and validation
- Satisfies all behavioral contracts with appropriate triggers and responses
- Provides testable implementation against original EARS requirements`;
        }
    }

    sanitizePromptForLogging(prompt) {
        return prompt.length > 200 ? prompt.substring(0, 200) + '...[truncated]' : prompt;
    }

    sanitizeOutputForLogging(output) {
        let sanitized = output.replace(/password|token|key|secret/gi, '[REDACTED]');
        return sanitized.length > 300 ? sanitized.substring(0, 300) + '...[truncated]' : sanitized;
    }

    generateExamplesForViolations(violations) {
        return violations.map(violation => ({
            violation: violation.violation,
            example: `Example solution: Implement specific logic to address "${violation.violation}"`
        }));
    }

    generateImplementationExamples(acceptanceCriteria) {
        return acceptanceCriteria.map(ac => ({
            criterion: ac.id,
            example: `Implementation approach for ${ac.trigger} ${ac.condition}: [specific code pattern]`
        }));
    }

    simplifyRequirement(acceptanceCriterion) {
        return `Simplified: ${acceptanceCriterion.behavior} (core functionality only)`;
    }

    analyzeCommonFailures(attempts) {
        const failureReasons = attempts
            .flatMap(a => a.validationResult.criticalViolations)
            .map(v => v.violation);
        
        const frequencyMap = {};
        failureReasons.forEach(reason => {
            frequencyMap[reason] = (frequencyMap[reason] || 0) + 1;
        });
        
        return Object.entries(frequencyMap)
            .sort(([,a], [,b]) => b - a)
            .slice(0, 3)
            .map(([reason, count]) => ({ reason, frequency: count }));
    }

    summarizeValidationFailures(delegationSession) {
        return {
            total_attempts: delegationSession.attempts.length,
            validation_scores: delegationSession.attempts.map(a => a.validationResult.overallScore),
            common_violations: this.analyzeCommonFailures(delegationSession.attempts),
            retry_effectiveness: delegationSession.attempts.length > 1 
                ? delegationSession.attempts[1].validationResult.overallScore - delegationSession.attempts[0].validationResult.overallScore
                : 0
        };
    }

    finalizeDelegationSession(delegationSession, startTime) {
        const totalTime = performance.now() - startTime;
        delegationSession.totalTime = totalTime;
        delegationSession.endTime = new Date().toISOString();
        
        // Update performance metrics
        this.performanceMetrics.totalDelegations++;
        this.performanceMetrics.avgRetryCount = 
            (this.performanceMetrics.avgRetryCount * (this.performanceMetrics.totalDelegations - 1) + 
             delegationSession.attempts.length) / this.performanceMetrics.totalDelegations;
        
        // Store delegation history
        this.delegationHistory.push({
            delegationId: delegationSession.delegationId,
            agentName: delegationSession.agentName,
            status: delegationSession.status,
            attempts: delegationSession.attempts.length,
            totalTime: totalTime,
            timestamp: delegationSession.startTime
        });
        
        console.log(`📊 [Delegation ${delegationSession.delegationId}] Completed: ${delegationSession.status} in ${totalTime.toFixed(1)}ms`);
        
        return delegationSession;
    }

    /**
     * Get delegation system metrics and performance data
     */
    getDelegationMetrics() {
        return {
            totalDelegations: this.performanceMetrics.totalDelegations,
            successRate: this.performanceMetrics.totalDelegations > 0 
                ? `${(((this.performanceMetrics.successOnFirstTry + this.performanceMetrics.successAfterRetry) / this.performanceMetrics.totalDelegations) * 100).toFixed(1)}%`
                : '0%',
            firstTrySuccessRate: this.performanceMetrics.totalDelegations > 0 
                ? `${((this.performanceMetrics.successOnFirstTry / this.performanceMetrics.totalDelegations) * 100).toFixed(1)}%`
                : '0%',
            retrySuccessRate: this.performanceMetrics.successAfterRetry > 0 
                ? `${((this.performanceMetrics.successAfterRetry / (this.performanceMetrics.totalDelegations - this.performanceMetrics.successOnFirstTry)) * 100).toFixed(1)}%`
                : '0%',
            fallbackRate: this.performanceMetrics.totalDelegations > 0 
                ? `${((this.performanceMetrics.fallbacksTriggered / this.performanceMetrics.totalDelegations) * 100).toFixed(1)}%`
                : '0%',
            avgRetryCount: this.performanceMetrics.avgRetryCount.toFixed(1),
            availableStrategies: {
                retry: Object.keys(this.retryStrategies),
                fallback: Object.keys(this.fallbackStrategies)
            },
            recentHistory: this.delegationHistory.slice(-5)
        };
    }

    /**
     * Clear delegation history for testing or memory management
     */
    clearHistory() {
        this.delegationHistory = [];
        this.performanceMetrics = {
            totalDelegations: 0,
            successOnFirstTry: 0,
            successAfterRetry: 0,
            fallbacksTriggered: 0,
            avgRetryCount: 0,
            mostCommonFailureReasons: new Map()
        };
        console.log('🗑️ Delegation history cleared');
    }
}

// Export for use in enhanced kiro-implementer
module.exports = { DelegationRetryFallbackSystem };

// CLI usage when run directly
if (require.main === module) {
    const delegationSystem = new DelegationRetryFallbackSystem();
    
    async function demonstrateDelegationRetryFallback() {
        try {
            console.log('🚀 Delegation Retry and Fallback System Demo');
            console.log('============================================');
            
            // Sample EARS context
            const sampleContext = {
                requirement_id: 'AC-AUTH-001',
                acceptance_criteria: [
                    { 
                        id: 'AC-AUTH-001', 
                        trigger: 'WHEN', 
                        condition: 'user submits login', 
                        behavior: 'validate within 200ms' 
                    },
                    { 
                        id: 'AC-AUTH-002', 
                        trigger: 'IF', 
                        condition: 'authentication fails', 
                        behavior: 'display error message' 
                    }
                ],
                behavioral_contracts: [
                    'WHEN user submits login, system SHALL validate within 200ms',
                    'IF authentication fails, system SHALL display error message'
                ],
                minimal_context: {
                    feature_summary: 'User authentication system',
                    constraints: ['EARS compliance required', 'Performance within 200ms'],
                    dependencies: ['User database', 'Session management']
                }
            };
            
            console.log('\n🎯 Testing delegation with retry and fallback...');
            
            const delegationResult = await delegationSystem.delegateWithRetryFallback(
                'authentication-specialist',
                'implement user login validation with EARS compliance',
                sampleContext,
                { allowDirectImplementation: true }
            );
            
            console.log('\n📊 Delegation Results:');
            console.log(`- Delegation ID: ${delegationResult.delegationId}`);
            console.log(`- Final Status: ${delegationResult.status}`);
            console.log(`- Total Attempts: ${delegationResult.attempts.length}`);
            console.log(`- Total Time: ${delegationResult.totalTime.toFixed(1)}ms`);
            
            if (delegationResult.fallbackUsed) {
                console.log(`- Fallback Strategy: ${delegationResult.fallbackUsed}`);
            }
            
            console.log('\n📈 System Metrics:');
            console.log(JSON.stringify(delegationSystem.getDelegationMetrics(), null, 2));
            
            // Demonstrate fallback scenario
            console.log('\n🔄 Testing fallback scenario...');
            
            const fallbackResult = await delegationSystem.delegateWithRetryFallback(
                'complex-specialist',
                'implement highly complex feature with multiple dependencies',
                sampleContext,
                { allowDirectImplementation: true }
            );
            
            console.log('\n📋 Fallback Results:');
            console.log(`- Status: ${fallbackResult.status}`);
            console.log(`- Fallback Used: ${fallbackResult.fallbackUsed || 'None'}`);
            
            console.log('\n📊 Final System Metrics:');
            console.log(JSON.stringify(delegationSystem.getDelegationMetrics(), null, 2));
            
        } catch (error) {
            console.error('Demo failed:', error.message);
        }
    }
    
    demonstrateDelegationRetryFallback();
}