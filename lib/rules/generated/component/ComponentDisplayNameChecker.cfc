/**
 * ComponentDisplayNameChecker.cfc
 *
 * Checks for name attribute instead of displayName
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "USE_DISPLAY_NAME";
        variables.ruleName = "ComponentDisplayNameChecker";
        variables.description = "Component has name attribute instead of displayName";
        variables.severity = "INFO";
        variables.message = "Component *variable* has a name attribute, but perhaps you meant to use displayName";
        variables.group = "Correctness";
        return this;
    }
    
    /**
     * Check AST for components with name instead of displayName
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for component name attribute vs displayName
        
        return results;
    }
}
