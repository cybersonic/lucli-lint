/**
 * CFDumpChecker.cfc
 *
 * Checks for cfdump tag usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_CFDUMP_TAG";
        variables.ruleName = "CFDumpChecker";
        variables.description = "Avoid use of cfdump tags";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving <cfdump> tags in committed code. Debug information should be omitted from release code";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for cfdump tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for cfdump tags
        
        return results;
    }
}
