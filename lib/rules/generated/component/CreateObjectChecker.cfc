/**
 * CreateObjectChecker.cfc
 *
 * Checks for createObject usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_CREATEOBJECT";
        variables.ruleName = "CreateObjectChecker";
        variables.description = "Avoid use of creatObject statements";
        variables.severity = "INFO";
        variables.message = "CreateObject found. Use createObject(path_to_component) or even better new path_to_component()";
        variables.group = "ModernSyntax";
        return this;
    }
    
    /**
     * Check AST for createObject() calls
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for createObject() function calls
        
        return results;
    }
}
