/**
 * CFUpdateChecker.cfc
 *
 * Checks for cfupdate tag usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_CFUPDATE_TAG";
        variables.ruleName = "CFUpdateChecker";
        variables.description = "Avoid use of cfupdate tags";
        variables.severity = "WARNING";
        variables.message = "Avoid using <cfupdate> tags. Use cfquery and cfstoredproc instead";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for cfupdate tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for cfupdate tags
        
        return results;
    }
}
