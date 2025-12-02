/**
 * CFBuiltInFunctionChecker.cfc
 *
 * Checks for problematic built-in function usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_ISDATE";
        variables.ruleName = "CFBuiltInFunctionChecker";
        variables.description = "Avoid using isDate built-in function";
        variables.severity = "WARNING";
        variables.message = "Avoid using the isDate built-in function. It is too permissive. Use isValid() instead";
        variables.group = "BugProne";
        return this;
    }
    
    /**
     * Check AST for isDate function usage
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for isDate() function calls
        
        return results;
    }
}
