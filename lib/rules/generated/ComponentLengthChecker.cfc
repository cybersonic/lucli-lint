/**
 * ComponentLengthChecker.cfc
 *
 * Checks for excessively long components
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "EXCESSIVE_COMPONENT_LENGTH";
        variables.ruleName = "ComponentLengthChecker";
        variables.description = "Component is too long";
        variables.severity = "WARNING";
        variables.message = "Component *component* is *variable* lines. Should be fewer than 500 lines";
        variables.group = "Complexity";
        variables.parameters = {
            "length": 500
        };
        return this;
    }
    
    /**
     * Check AST for excessively long components
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for components exceeding max length
        
        return results;
    }
}
