/**
 * GlobalVarChecker.cfc
 *
 * Checks for global variable usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "GLOBAL_VAR";
        variables.ruleName = "GlobalVarChecker";
        variables.description = "Global variable exists";
        variables.severity = "WARNING";
        variables.message = "Identifier *variable* is global. Referencing in a CFC or function should be avoided";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for global variable usage
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for global variable usage
        
        return results;
    }
}
