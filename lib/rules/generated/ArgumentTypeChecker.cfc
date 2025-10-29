/**
 * ArgumentTypeChecker.cfc
 *
 * Checks for argument type issues
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "ARG_TYPE_MISSING";
        variables.ruleName = "ArgumentTypeChecker";
        variables.description = "Component is missing a type";
        variables.severity = "WARNING";
        variables.message = "Argument *variable* is missing a type";
        variables.group = "Correctness";
        return this;
    }
    
    /**
     * Check AST for argument type issues
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for arguments without type or with type="any"
        
        return results;
    }
}
