#!/usr/bin/env node

/**
 * Behavioral Contract Validation Engine (TASK-E5A8F3B2-009)
 * 
 * EARS Context: WHERE delegation completes successfully, SHALL validate outputs against original behavioral contracts
 * AC-E5A8F3B2-003-04: Validate outputs against original behavioral contracts before integration
 * 
 * Implementation: Output validation against original EARS behavioral contracts with contract violation detection
 * Risk: High | Effort: 8pts
 */

const fs = require('fs').promises;
const path = require('path');

class BehavioralContractValidationEngine {
    constructor() {
        this.validationRules = this.initializeValidationRules();
        this.contractPatterns = this.initializeContractPatterns();
        this.validationHistory = [];
        this.performanceMetrics = {
            validationsPerformed: 0,
            avgValidationTime: 0,
            passRate: 0,
            violationPatterns: new Map()
        };
    }

    /**
     * Initialize EARS validation rules for different contract types
     */
    initializeValidationRules() {
        return {
            WHEN_SHALL: {
                pattern: /WHEN\s+(.+?)\s+SHALL\s+(.+?)(?:\s*\{|$)/gi,
                validator: this.validateWhenShallContract.bind(this),
                description: 'Event-triggered behavioral requirements',
                weight: 1.0
            },
            WHILE_SHALL: {
                pattern: /WHILE\s+(.+?)\s+SHALL\s+(.+?)(?:\s*\{|$)/gi,
                validator: this.validateWhileShallContract.bind(this),
                description: 'Continuous state behavioral requirements',
                weight: 1.2
            },
            IF_SHALL: {
                pattern: /IF\s+(.+?)\s+SHALL\s+(.+?)(?:\s*\{|$)/gi,
                validator: this.validateIfShallContract.bind(this),
                description: 'Conditional behavioral requirements',
                weight: 1.1
            },
            WHERE_SHALL: {
                pattern: /WHERE\s+(.+?)\s+SHALL\s+(.+?)(?:\s*\{|$)/gi,
                validator: this.validateWhereShallContract.bind(this),
                description: 'Boundary condition behavioral requirements',
                weight: 1.3
            }
        };
    }

    /**
     * Initialize contract pattern matchers for different types of implementations
     */
    initializeContractPatterns() {
        return {
            security: {
                keywords: ['authenticate', 'authorize', 'validate', 'secure', 'encrypt', 'permission'],
                description: 'Security-related behavioral contracts'
            },
            performance: {
                keywords: ['within', 'milliseconds', 'seconds', 'optimize', 'performance', 'speed'],
                description: 'Performance-related behavioral contracts'
            },
            ui_ux: {
                keywords: ['display', 'show', 'interface', 'user', 'click', 'submit'],
                description: 'User interface behavioral contracts'
            },
            api: {
                keywords: ['endpoint', 'api', 'request', 'response', 'http', 'return'],
                description: 'API-related behavioral contracts'
            },
            data: {
                keywords: ['save', 'store', 'persist', 'database', 'data', 'record'],
                description: 'Data persistence behavioral contracts'
            }
        };
    }

    /**
     * Main validation method: Validate subagent output against EARS behavioral contracts
     * AC-E5A8F3B2-003-04: WHERE delegation completes successfully, SHALL validate outputs
     * 
     * @param {string} subagentOutput - The implementation output from subagent
     * @param {Array} behavioralContracts - Array of EARS behavioral contract strings
     * @param {Object} earsContext - Original EARS context with acceptance criteria
     * @returns {Promise<Object>} Comprehensive validation result
     */
    async validateAgainstBehavioralContracts(subagentOutput, behavioralContracts, earsContext) {
        const validationStart = performance.now();
        
        try {
            console.log('🔍 [Contract Validation] Starting behavioral contract validation...');
            console.log(`📋 [Contract Validation] Validating ${behavioralContracts.length} contracts`);

            const validationResult = {
                timestamp: new Date().toISOString(),
                contextId: earsContext.requirement_id,
                agentOutput: this.sanitizeOutputForLogging(subagentOutput),
                overallResult: 'PENDING',
                overallScore: 0,
                contractValidations: [],
                criticalViolations: [],
                warnings: [],
                recommendations: [],
                passedContracts: 0,
                totalContracts: behavioralContracts.length,
                metadata: {
                    validationEngine: 'BehavioralContractValidationEngine v1.0',
                    earsCompliance: true,
                    validationDepth: 'COMPREHENSIVE'
                }
            };

            // Validate each behavioral contract
            for (let i = 0; i < behavioralContracts.length; i++) {
                const contract = behavioralContracts[i];
                console.log(`🔍 [Contract ${i+1}/${behavioralContracts.length}] Validating: ${contract.substring(0, 80)}...`);
                
                const contractValidation = await this.validateSingleContract(
                    subagentOutput, 
                    contract, 
                    earsContext
                );
                
                validationResult.contractValidations.push(contractValidation);
                
                if (contractValidation.result === 'PASSED') {
                    validationResult.passedContracts++;
                    console.log(`✅ [Contract ${i+1}] PASSED - ${contractValidation.summary}`);
                } else if (contractValidation.result === 'FAILED') {
                    validationResult.criticalViolations.push(contractValidation);
                    console.log(`❌ [Contract ${i+1}] FAILED - ${contractValidation.violation}`);
                } else {
                    validationResult.warnings.push(contractValidation);
                    console.log(`⚠️ [Contract ${i+1}] WARNING - ${contractValidation.warning}`);
                }
            }

            // Calculate overall score and result
            validationResult.overallScore = Math.round(
                (validationResult.passedContracts / validationResult.totalContracts) * 100
            );

            // Determine overall validation result
            if (validationResult.criticalViolations.length === 0) {
                validationResult.overallResult = 'PASSED';
            } else if (validationResult.criticalViolations.length <= 2 && validationResult.overallScore >= 70) {
                validationResult.overallResult = 'CONDITIONAL_PASS';
            } else {
                validationResult.overallResult = 'FAILED';
            }

            // Generate recommendations for improvement
            validationResult.recommendations = this.generateRecommendations(validationResult);

            const validationTime = performance.now() - validationStart;
            this.updatePerformanceMetrics(validationResult, validationTime);

            // Store validation history for analysis
            this.validationHistory.push({
                timestamp: validationResult.timestamp,
                result: validationResult.overallResult,
                score: validationResult.overallScore,
                contractCount: validationResult.totalContracts,
                validationTime: validationTime
            });

            console.log(`✅ [Contract Validation] Completed in ${validationTime.toFixed(1)}ms`);
            console.log(`📊 [Contract Validation] Result: ${validationResult.overallResult} (${validationResult.overallScore}%)`);

            return validationResult;

        } catch (error) {
            console.error('❌ [Contract Validation] Validation failed:', error.message);
            throw new Error(`Behavioral contract validation failed: ${error.message}`);
        }
    }

    /**
     * Validate a single behavioral contract against subagent output
     */
    async validateSingleContract(output, contract, earsContext) {
        try {
            // Parse the contract to identify its EARS type and components
            const contractAnalysis = this.parseEARSContract(contract);
            
            if (!contractAnalysis.isValid) {
                return {
                    contract: contract,
                    result: 'WARNING',
                    warning: 'Contract format not recognized as valid EARS syntax',
                    details: 'Contract may not follow EARS format (WHEN/WHILE/IF/WHERE + SHALL)',
                    confidence: 0.3
                };
            }

            // Select appropriate validator based on contract type
            const validator = this.validationRules[contractAnalysis.type]?.validator;
            
            if (!validator) {
                return {
                    contract: contract,
                    result: 'WARNING',
                    warning: `No validator available for contract type: ${contractAnalysis.type}`,
                    details: 'Contract type recognized but no specific validation logic implemented',
                    confidence: 0.5
                };
            }

            // Perform type-specific validation
            const validation = await validator(output, contractAnalysis, earsContext);

            // Enhance validation with pattern matching
            const patternValidation = this.performPatternValidation(output, contractAnalysis);
            
            // Combine results
            return {
                contract: contract,
                result: validation.result,
                summary: validation.summary,
                violation: validation.violation,
                warning: validation.warning,
                details: validation.details,
                confidence: validation.confidence,
                earsType: contractAnalysis.type,
                patternMatch: patternValidation,
                recommendations: validation.recommendations || []
            };

        } catch (error) {
            return {
                contract: contract,
                result: 'FAILED',
                violation: `Contract validation error: ${error.message}`,
                details: 'Internal validation engine error',
                confidence: 0.1
            };
        }
    }

    /**
     * Parse EARS contract to extract components and determine type
     */
    parseEARSContract(contract) {
        for (const [type, rule] of Object.entries(this.validationRules)) {
            const match = rule.pattern.exec(contract);
            if (match) {
                rule.pattern.lastIndex = 0; // Reset regex state
                return {
                    isValid: true,
                    type: type,
                    trigger: match[1]?.trim(),
                    behavior: match[2]?.trim(),
                    fullText: contract,
                    weight: rule.weight
                };
            }
        }

        return {
            isValid: false,
            type: 'UNKNOWN',
            fullText: contract
        };
    }

    /**
     * Validate WHEN-SHALL contracts (event-triggered behaviors)
     */
    async validateWhenShallContract(output, contractAnalysis, earsContext) {
        const trigger = contractAnalysis.trigger;
        const behavior = contractAnalysis.behavior;
        
        // Check if output addresses the trigger condition
        const triggerAddressed = this.checkTriggerAddressed(output, trigger);
        
        // Check if expected behavior is implemented
        const behaviorImplemented = this.checkBehaviorImplemented(output, behavior);
        
        if (triggerAddressed && behaviorImplemented) {
            return {
                result: 'PASSED',
                summary: `Event-triggered behavior correctly implemented for: ${trigger}`,
                confidence: 0.85,
                details: `Output addresses trigger "${trigger}" and implements required behavior "${behavior}"`
            };
        } else if (!triggerAddressed) {
            return {
                result: 'FAILED',
                violation: `Trigger condition not addressed: ${trigger}`,
                confidence: 0.9,
                details: `Implementation does not handle the specified trigger condition`
            };
        } else {
            return {
                result: 'FAILED',
                violation: `Required behavior not implemented: ${behavior}`,
                confidence: 0.8,
                details: `Implementation addresses trigger but does not implement required behavior`
            };
        }
    }

    /**
     * Validate WHILE-SHALL contracts (continuous state behaviors)
     */
    async validateWhileShallContract(output, contractAnalysis, earsContext) {
        const condition = contractAnalysis.trigger;
        const behavior = contractAnalysis.behavior;
        
        // Check for continuous/ongoing behavior implementation
        const continuousBehavior = this.checkContinuousBehavior(output, condition, behavior);
        
        if (continuousBehavior.implemented) {
            return {
                result: 'PASSED',
                summary: `Continuous behavior correctly implemented for: ${condition}`,
                confidence: 0.8,
                details: continuousBehavior.evidence
            };
        } else {
            return {
                result: 'FAILED',
                violation: `Continuous behavior not implemented for: ${condition}`,
                confidence: 0.85,
                details: continuousBehavior.issue
            };
        }
    }

    /**
     * Validate IF-SHALL contracts (conditional behaviors)
     */
    async validateIfShallContract(output, contractAnalysis, earsContext) {
        const condition = contractAnalysis.trigger;
        const behavior = contractAnalysis.behavior;
        
        // Check for conditional logic implementation
        const conditionalLogic = this.checkConditionalLogic(output, condition, behavior);
        
        if (conditionalLogic.implemented) {
            return {
                result: 'PASSED',
                summary: `Conditional behavior correctly implemented`,
                confidence: 0.82,
                details: conditionalLogic.evidence
            };
        } else {
            return {
                result: 'FAILED',
                violation: `Conditional logic not properly implemented`,
                confidence: 0.87,
                details: conditionalLogic.issue
            };
        }
    }

    /**
     * Validate WHERE-SHALL contracts (boundary condition behaviors)
     */
    async validateWhereShallContract(output, contractAnalysis, earsContext) {
        const boundary = contractAnalysis.trigger;
        const behavior = contractAnalysis.behavior;
        
        // Check for boundary condition handling
        const boundaryHandling = this.checkBoundaryCondition(output, boundary, behavior);
        
        if (boundaryHandling.implemented) {
            return {
                result: 'PASSED',
                summary: `Boundary condition correctly handled`,
                confidence: 0.83,
                details: boundaryHandling.evidence
            };
        } else {
            return {
                result: 'FAILED',
                violation: `Boundary condition not properly handled`,
                confidence: 0.88,
                details: boundaryHandling.issue
            };
        }
    }

    /**
     * Check if trigger condition is addressed in output
     */
    checkTriggerAddressed(output, trigger) {
        const outputLower = output.toLowerCase();
        const triggerWords = trigger.toLowerCase().split(' ')
            .filter(word => word.length > 2)
            .filter(word => !['the', 'and', 'or', 'but', 'when', 'while', 'if', 'where'].includes(word));

        const matchedWords = triggerWords.filter(word => 
            outputLower.includes(word) || 
            this.findSimilarWords(outputLower, word).length > 0
        );

        return matchedWords.length >= Math.ceil(triggerWords.length * 0.6);
    }

    /**
     * Check if required behavior is implemented
     */
    checkBehaviorImplemented(output, behavior) {
        const outputLower = output.toLowerCase();
        const behaviorWords = behavior.toLowerCase().split(' ')
            .filter(word => word.length > 2)
            .filter(word => !['the', 'and', 'or', 'but', 'shall', 'should', 'must'].includes(word));

        const matchedWords = behaviorWords.filter(word => 
            outputLower.includes(word) || 
            this.findSimilarWords(outputLower, word).length > 0
        );

        return matchedWords.length >= Math.ceil(behaviorWords.length * 0.5);
    }

    /**
     * Check for continuous behavior patterns
     */
    checkContinuousBehavior(output, condition, behavior) {
        const continuousKeywords = ['continuously', 'ongoing', 'while', 'during', 'throughout', 'maintain'];
        const outputLower = output.toLowerCase();
        
        const hasContinuousPattern = continuousKeywords.some(keyword => 
            outputLower.includes(keyword)
        );
        
        const conditionAddressed = this.checkTriggerAddressed(output, condition);
        const behaviorImplemented = this.checkBehaviorImplemented(output, behavior);
        
        if (hasContinuousPattern && conditionAddressed && behaviorImplemented) {
            return {
                implemented: true,
                evidence: `Implementation includes continuous behavior patterns and addresses condition "${condition}"`
            };
        } else {
            return {
                implemented: false,
                issue: `Missing continuous behavior implementation for condition: ${condition}`
            };
        }
    }

    /**
     * Check for conditional logic implementation
     */
    checkConditionalLogic(output, condition, behavior) {
        const conditionalKeywords = ['if', 'when', 'condition', 'check', 'verify', 'validate'];
        const outputLower = output.toLowerCase();
        
        const hasConditionalPattern = conditionalKeywords.some(keyword => 
            outputLower.includes(keyword)
        );
        
        const conditionAddressed = this.checkTriggerAddressed(output, condition);
        const behaviorImplemented = this.checkBehaviorImplemented(output, behavior);
        
        if (hasConditionalPattern && conditionAddressed && behaviorImplemented) {
            return {
                implemented: true,
                evidence: `Implementation includes conditional logic for "${condition}"`
            };
        } else {
            return {
                implemented: false,
                issue: `Missing conditional logic implementation for: ${condition}`
            };
        }
    }

    /**
     * Check for boundary condition handling
     */
    checkBoundaryCondition(output, boundary, behavior) {
        const boundaryKeywords = ['limit', 'boundary', 'constraint', 'within', 'outside', 'exceed'];
        const outputLower = output.toLowerCase();
        
        const hasBoundaryPattern = boundaryKeywords.some(keyword => 
            outputLower.includes(keyword)
        );
        
        const boundaryAddressed = this.checkTriggerAddressed(output, boundary);
        const behaviorImplemented = this.checkBehaviorImplemented(output, behavior);
        
        if (hasBoundaryPattern && boundaryAddressed && behaviorImplemented) {
            return {
                implemented: true,
                evidence: `Implementation handles boundary condition "${boundary}"`
            };
        } else {
            return {
                implemented: false,
                issue: `Missing boundary condition handling for: ${boundary}`
            };
        }
    }

    /**
     * Perform pattern-based validation for specialized domains
     */
    performPatternValidation(output, contractAnalysis) {
        const outputLower = output.toLowerCase();
        const patternResults = {};
        
        for (const [domain, config] of Object.entries(this.contractPatterns)) {
            const keywordMatches = config.keywords.filter(keyword => 
                outputLower.includes(keyword)
            ).length;
            
            if (keywordMatches > 0) {
                patternResults[domain] = {
                    relevance: keywordMatches / config.keywords.length,
                    matchedKeywords: config.keywords.filter(keyword => outputLower.includes(keyword)),
                    description: config.description,
                    score: Math.round((keywordMatches / config.keywords.length) * 100)
                };
            }
        }
        
        return patternResults;
    }

    /**
     * Find similar words for fuzzy matching
     */
    findSimilarWords(text, word) {
        const words = text.split(/\W+/);
        return words.filter(textWord => 
            textWord.length > 2 && 
            (textWord.includes(word) || word.includes(textWord))
        );
    }

    /**
     * Generate recommendations for contract violations
     */
    generateRecommendations(validationResult) {
        const recommendations = [];
        
        if (validationResult.criticalViolations.length > 0) {
            recommendations.push({
                type: 'CRITICAL',
                message: 'Address critical contract violations before integration',
                actions: validationResult.criticalViolations.map(v => 
                    `Fix: ${v.violation}`
                )
            });
        }
        
        if (validationResult.warnings.length > 0) {
            recommendations.push({
                type: 'IMPROVEMENT',
                message: 'Consider addressing contract warnings for better compliance',
                actions: validationResult.warnings.map(w => 
                    `Improve: ${w.warning}`
                )
            });
        }
        
        if (validationResult.overallScore < 80) {
            recommendations.push({
                type: 'ENHANCEMENT',
                message: 'Validation score could be improved',
                actions: [
                    'Review implementation against EARS acceptance criteria',
                    'Ensure all behavioral contracts are explicitly addressed',
                    'Add missing functionality identified in validation failures'
                ]
            });
        }
        
        return recommendations;
    }

    /**
     * Sanitize output for logging (remove sensitive data, limit length)
     */
    sanitizeOutputForLogging(output) {
        // Remove potential sensitive information
        let sanitized = output.replace(/password|token|key|secret/gi, '[REDACTED]');
        
        // Limit length for logging
        if (sanitized.length > 500) {
            sanitized = sanitized.substring(0, 500) + '...[truncated]';
        }
        
        return sanitized;
    }

    /**
     * Update performance metrics
     */
    updatePerformanceMetrics(validationResult, validationTime) {
        this.performanceMetrics.validationsPerformed++;
        this.performanceMetrics.avgValidationTime = 
            (this.performanceMetrics.avgValidationTime + validationTime) / 2;
        
        const passed = validationResult.overallResult === 'PASSED' ? 1 : 0;
        this.performanceMetrics.passRate = 
            (this.performanceMetrics.passRate * (this.performanceMetrics.validationsPerformed - 1) + passed) 
            / this.performanceMetrics.validationsPerformed;
        
        // Track violation patterns for improvement
        for (const violation of validationResult.criticalViolations) {
            const pattern = violation.earsType || 'UNKNOWN';
            this.performanceMetrics.violationPatterns.set(
                pattern, 
                (this.performanceMetrics.violationPatterns.get(pattern) || 0) + 1
            );
        }
    }

    /**
     * Get validation engine metrics and performance data
     */
    getValidationMetrics() {
        return {
            validationsPerformed: this.performanceMetrics.validationsPerformed,
            avgValidationTime: `${this.performanceMetrics.avgValidationTime.toFixed(1)}ms`,
            passRate: `${(this.performanceMetrics.passRate * 100).toFixed(1)}%`,
            violationPatterns: Object.fromEntries(this.performanceMetrics.violationPatterns),
            validationHistory: this.validationHistory.slice(-10), // Last 10 validations
            engineStatus: 'OPERATIONAL',
            supportedContractTypes: Object.keys(this.validationRules)
        };
    }

    /**
     * Generate validation report for debugging and improvement
     */
    generateValidationReport(validationResult) {
        const report = {
            executive_summary: {
                result: validationResult.overallResult,
                score: validationResult.overallScore,
                contracts_validated: validationResult.totalContracts,
                critical_issues: validationResult.criticalViolations.length,
                warnings: validationResult.warnings.length
            },
            contract_analysis: validationResult.contractValidations.map(cv => ({
                contract: cv.contract.substring(0, 100) + '...',
                result: cv.result,
                confidence: cv.confidence,
                ears_type: cv.earsType
            })),
            critical_violations: validationResult.criticalViolations.map(cv => ({
                violation: cv.violation,
                contract: cv.contract.substring(0, 80) + '...',
                confidence: cv.confidence
            })),
            recommendations: validationResult.recommendations,
            next_steps: this.generateNextSteps(validationResult)
        };
        
        return report;
    }

    /**
     * Generate actionable next steps based on validation results
     */
    generateNextSteps(validationResult) {
        const steps = [];
        
        if (validationResult.overallResult === 'FAILED') {
            steps.push('❌ RETRY REQUIRED: Fix critical violations before proceeding');
            steps.push('🔧 Enhanced Context: Provide additional requirements context to subagent');
            steps.push('🔄 Fallback Option: Consider direct implementation if retry fails');
        } else if (validationResult.overallResult === 'CONDITIONAL_PASS') {
            steps.push('⚠️ CONDITIONAL: Minor issues detected but proceeding allowed');
            steps.push('📝 Document: Record validation warnings for future reference');
            steps.push('🔍 Monitor: Watch for related issues during integration');
        } else {
            steps.push('✅ APPROVED: Output meets all behavioral contract requirements');
            steps.push('🚀 Integration: Ready for integration into main implementation');
            steps.push('📊 Metrics: Update success metrics for subagent delegation');
        }
        
        return steps;
    }

    /**
     * Clear validation history for testing or memory management
     */
    clearValidationHistory() {
        this.validationHistory = [];
        this.performanceMetrics.violationPatterns.clear();
        console.log('🗑️ Validation history cleared');
    }
}

// Export for use in enhanced kiro-implementer
module.exports = { BehavioralContractValidationEngine };

// CLI usage when run directly
if (require.main === module) {
    const validator = new BehavioralContractValidationEngine();
    
    async function demonstrateValidation() {
        try {
            console.log('🚀 Behavioral Contract Validation Engine Demo');
            console.log('===============================================');
            
            // Sample subagent output
            const sampleOutput = `
            I have implemented the authentication system with the following features:
            - When user submits login form, system validates credentials within 200ms
            - If authentication fails, system displays specific error message
            - While user session is active, system maintains authentication state
            - Where invalid tokens are provided, system returns 401 unauthorized
            - The implementation includes secure password hashing and token generation
            - User interface displays login form with validation feedback
            - API endpoints handle authentication requests and responses appropriately
            - Data persistence stores user credentials securely in database
            `;
            
            // Sample behavioral contracts
            const sampleContracts = [
                'WHEN user submits login form, system SHALL validate credentials within 200ms',
                'IF authentication fails, system SHALL display specific error message',
                'WHILE user session is active, system SHALL maintain authentication state',
                'WHERE invalid tokens are provided, system SHALL return 401 unauthorized'
            ];
            
            // Sample EARS context
            const sampleContext = {
                requirement_id: 'AC-AUTH-001',
                acceptance_criteria: [
                    { id: 'AC-AUTH-001', trigger: 'WHEN', condition: 'user submits login', behavior: 'validate within 200ms' }
                ]
            };
            
            console.log('\n🔍 Validating sample authentication implementation...');
            
            const validationResult = await validator.validateAgainstBehavioralContracts(
                sampleOutput,
                sampleContracts,
                sampleContext
            );
            
            console.log('\n📊 Validation Results:');
            console.log(`- Overall Result: ${validationResult.overallResult}`);
            console.log(`- Overall Score: ${validationResult.overallScore}%`);
            console.log(`- Passed Contracts: ${validationResult.passedContracts}/${validationResult.totalContracts}`);
            console.log(`- Critical Violations: ${validationResult.criticalViolations.length}`);
            console.log(`- Warnings: ${validationResult.warnings.length}`);
            
            // Generate and display report
            const report = validator.generateValidationReport(validationResult);
            console.log('\n📋 Executive Summary:');
            console.log(JSON.stringify(report.executive_summary, null, 2));
            
            console.log('\n🎯 Next Steps:');
            report.next_steps.forEach(step => console.log(`  ${step}`));
            
            console.log('\n📈 Engine Metrics:');
            console.log(JSON.stringify(validator.getValidationMetrics(), null, 2));
            
        } catch (error) {
            console.error('Demo failed:', error.message);
        }
    }
    
    demonstrateValidation();
}