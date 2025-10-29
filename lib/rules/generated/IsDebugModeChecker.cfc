/**
 * IsDebugModeChecker.cfc
 *
 * Checks for isDebugMode usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_ISDEBUGMODE";
        variables.ruleName = "IsDebugModeChecker";
        variables.description = "Avoid use of isDebugMode statements";
        variables.severity = "WARNING";
        variables.message = "Avoid using the IsDebugMode function in production code";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for isDebugMode() function calls
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for isDebugMode() function calls
        
        return results;
    }
}
