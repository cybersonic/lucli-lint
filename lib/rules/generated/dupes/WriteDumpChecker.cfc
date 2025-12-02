/**
 * WriteDumpChecker.cfc
 *
 * Checks for writeDump function usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_WRITEDUMP";
        variables.ruleName = "WriteDumpChecker";
        variables.description = "Avoid use of writeDump statements";
        variables.severity = "INFO";
        variables.message = "Avoid using the writeDump function in production code";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for writeDump function calls
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for writeDump() function calls
        
        return results;
    }
}
