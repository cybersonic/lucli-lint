/**
 * StructKeyChecker.cfc
 *
 * Checks for unquoted struct keys
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "UNQUOTED_STRUCT_KEY";
        variables.ruleName = "StructKeyChecker";
        variables.description = "Unquoted struct key is not case-sensitive";
        variables.severity = "WARNING";
        variables.message = "Unquoted struct key *variable* is not case-sensitive. Quoting it is recommended";
        variables.group = "Correctness";
        return this;
    }
    
    /**
     * Check AST for unquoted struct keys
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for unquoted struct keys
        // Should also detect STRUCT_ARRAY_NOTATION
        
        return results;
    }
}
