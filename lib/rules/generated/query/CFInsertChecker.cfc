/**
 * CFInsertChecker.cfc
 *
 * Checks for cfinsert tag usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_CFINSERT_TAG";
        variables.ruleName = "CFInsertChecker";
        variables.description = "Avoid use of cfinsert tags";
        variables.severity = "WARNING";
        variables.message = "Avoid using <cfinsert> tags. Use cfquery and cfstoredproc instead";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for cfinsert tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for cfinsert tags
        
        return results;
    }
}
