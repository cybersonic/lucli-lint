/**
 * CFQueryChecker.cfc
 *
 * Checks for cfquery usage in CFM files
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "NEVER_USE_QUERY_IN_CFM";
        variables.ruleName = "CFQueryChecker";
        variables.description = "Don't use cfquery in .cfm files";
        variables.severity = "ERROR";
        variables.message = "Don't use <cfquery> in .cfm files. Database should not be coupled with view";
        variables.group = "Experimental";
        return this;
    }
    
    /**
     * Check AST for cfquery in CFM files
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for cfquery tags in .cfm files
        
        return results;
    }
}
