/**
 * FunctionCollisionChecker.cfc
 *
 * Checks for function names that collide with reserved words
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "FUNCTION_NAME_COLLISION";
        variables.ruleName = "FunctionCollisionChecker";
        variables.description = "Function name collision with reserved words";
        variables.severity = "WARNING";
        variables.message = "Avoid using the name *variable* for a function. It is reserved in some CFML implementations. See https://cfdocs.org/*variable*";
        variables.group = "Correctness";
        return this;
    }
    
    /**
     * Check AST for function names that collide with reserved words
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for function names matching reserved words
        
        return results;
    }
}
