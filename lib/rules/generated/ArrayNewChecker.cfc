/**
 * ArrayNewChecker.cfc
 *
 * Checks for arrayNew usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_ARRAYNEW";
        variables.ruleName = "ArrayNewChecker";
        variables.description = "Avoid use of arrayNew statements. Use [] instead";
        variables.severity = "INFO";
        variables.message = "Use implict array construction instead (= [])";
        variables.group = "ModernSyntax";
        return this;
    }
    
    /**
     * Check AST for arrayNew() function calls
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for arrayNew() function calls
        
        return results;
    }
}
