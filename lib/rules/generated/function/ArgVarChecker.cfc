/**
 * ArgVarChecker.cfc
 *
 * Checks for variables declared in both local and argument scopes
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "ARG_VAR_CONFLICT";
        variables.ruleName = "ArgVarChecker";
        variables.description = "Variable declared in both local and argument scopes";
        variables.severity = "ERROR";
        variables.message = "Variable *variable* should not be declared in both local and argument scopes";
        variables.group = "BugProne";
        return this;
    }
    
    /**
     * Check AST for argument/variable conflicts
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for variables declared in both local and argument scopes
        
        return results;
    }
}
