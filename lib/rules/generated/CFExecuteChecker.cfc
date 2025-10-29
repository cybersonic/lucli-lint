/**
 * CFExecuteChecker.cfc
 *
 * Checks for cfexecute tag usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_CFEXECUTE_TAG";
        variables.ruleName = "CFExecuteChecker";
        variables.description = "Avoid use of cfexecute tags";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving <cfexecute> tags in committed code. CFexecute can be used as an attack vector and is slow";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for cfexecute tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for cfexecute tags
        
        return results;
    }
}
