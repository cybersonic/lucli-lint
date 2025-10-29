/**
 * FunctionTypeChecker.cfc
 *
 * Checks for function return type issues
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "FUNCTION_TYPE_MISSING";
        variables.ruleName = "FunctionTypeChecker";
        variables.description = "Function is missing a return type";
        variables.severity = "WARNING";
        variables.message = "Function *variable* is missing a return type";
        variables.group = "CodeStyle";
        return this;
    }
    
    /**
     * Check AST for function return type issues
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for functions without return type or with returnType="any"
        
        return results;
    }
}
