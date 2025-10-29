/**
 * FunctionLengthChecker.cfc
 *
 * Checks for excessively long functions
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "EXCESSIVE_FUNCTION_LENGTH";
        variables.ruleName = "FunctionLengthChecker";
        variables.description = "Method is too long";
        variables.severity = "WARNING";
        variables.message = "Function *function* is *variable* lines. Should be fewer than 100 lines";
        variables.group = "Complexity";
        variables.parameters = {
            "length": 100
        };
        return this;
    }
    
    /**
     * Check AST for excessively long functions
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for functions exceeding max length
        
        return results;
    }
}
