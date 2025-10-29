/**
 * CFIncludeChecker.cfc
 *
 * Checks for cfinclude tag usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_CFINCLUDE_TAG";
        variables.ruleName = "CFIncludeChecker";
        variables.description = "Avoid use of cfinclude tags";
        variables.severity = "WARNING";
        variables.message = "Avoid using <cfinclude> tags. Use components instead";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for cfinclude tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for cfinclude tags
        
        return results;
    }
}
