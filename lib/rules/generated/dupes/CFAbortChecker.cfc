/**
 * CFAbortChecker.cfc
 *
 * Checks for cfabort tag usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_CFABORT_TAG";
        variables.ruleName = "CFAbortChecker";
        variables.description = "Avoid use of cfabort tags";
        variables.severity = "INFO";
        variables.message = "Avoid leaving <cfabort> tags in committed code";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for cfabort tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for cfabort tags
        
        return results;
    }
}
