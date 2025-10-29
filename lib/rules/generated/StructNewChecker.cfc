/**
 * StructNewChecker.cfc
 *
 * Checks for structNew usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_STRUCTNEW";
        variables.ruleName = "StructNewChecker";
        variables.description = "Avoid use of structNew statements. Use {} instead";
        variables.severity = "INFO";
        variables.message = "Avoid using the structNew function in production code";
        variables.group = "ModernSyntax";
        return this;
    }
    
    /**
     * Check AST for structNew() function calls
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for structNew() function calls
        
        return results;
    }
}
