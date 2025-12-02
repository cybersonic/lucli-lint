/**
 * ComponentHintChecker.cfc
 *
 * Checks for missing component hints
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "COMPONENT_HINT_MISSING";
        variables.ruleName = "ComponentHintChecker";
        variables.description = "Component is missing a hint";
        variables.severity = "WARNING";
        variables.message = "Component *variable* is missing a hint";
        variables.group = "CodeStyle";
        return this;
    }
    
    /**
     * Check AST for components without hints
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for components without hint attribute
        
        return results;
    }
}
