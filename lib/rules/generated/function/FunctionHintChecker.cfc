/**
 * FunctionHintChecker.cfc
 *
 * Checks for missing function hints
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "FUNCTION_HINT_MISSING";
        variables.ruleName = "FunctionHintChecker";
        variables.description = "Function is missing a hint";
        variables.severity = "INFO";
        variables.message = "Function *variable* is missing a hint";
        variables.group = "CodeStyle";
        return this;
    }
    
    /**
     * Check AST for functions without hints
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for functions without hint attribute
        
        return results;
    }
}
