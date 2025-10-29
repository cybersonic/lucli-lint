/**
 * UnusedArgumentChecker.cfc
 *
 * Checks for unused method arguments
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "UNUSED_METHOD_ARGUMENT";
        variables.ruleName = "UnusedArgumentChecker";
        variables.description = "Unused method argument";
        variables.severity = "INFO";
        variables.message = "Argument *variable* is not used in function. Consider removing it";
        variables.group = "Correctness";
        return this;
    }
    
    /**
     * Check AST for unused method arguments
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for function arguments that are never referenced
        
        return results;
    }
}
