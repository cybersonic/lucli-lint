/**
 * CFDebugAttributeChecker.cfc
 *
 * Checks for debug attributes in tags
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_DEBUG_ATTR";
        variables.ruleName = "CFDebugAttributeChecker";
        variables.description = "Avoid use of debug attribute";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving debug attribute on tags";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for debug attributes
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for debug attribute on tags and showDebugOutput on cfsetting
        
        return results;
    }
}
