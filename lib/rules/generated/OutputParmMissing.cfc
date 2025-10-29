/**
 * OutputParmMissing.cfc
 *
 * Checks for missing output='false' attribute
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "OUTPUT_ATTR";
        variables.ruleName = "OutputParmMissing";
        variables.description = "Tag should have output='false'";
        variables.severity = "INFO";
        variables.message = "<*tag* name=\"*variable*\"> should have @output='false'";
        variables.group = "BugProne";
        return this;
    }
    
    /**
     * Check AST for missing output attribute
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for functions/components without output='false'
        
        return results;
    }
}
