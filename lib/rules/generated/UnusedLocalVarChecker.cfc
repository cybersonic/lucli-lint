/**
 * UnusedLocalVarChecker.cfc
 *
 * Checks for unused local variables
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "UNUSED_LOCAL_VARIABLE";
        variables.ruleName = "UnusedLocalVarChecker";
        variables.description = "Unused local variable";
        variables.severity = "INFO";
        variables.message = "Local variable *variable* is not used in function *function*. Consider removing it";
        variables.group = "Correctness";
        return this;
    }
    
    /**
     * Check AST for unused local variables
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for local variables that are declared but never used
        
        return results;
    }
}
