/**
 * CFModuleChecker.cfc
 *
 * Checks for cfmodule tag usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_CFMODULE_TAG";
        variables.ruleName = "CFModuleChecker";
        variables.description = "Avoid use of cfmodule tags";
        variables.severity = "WARNING";
        variables.message = "Avoid using <cfmodule> tags";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for cfmodule tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for cfmodule tags
        
        return results;
    }
}
