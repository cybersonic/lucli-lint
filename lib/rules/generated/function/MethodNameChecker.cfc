/**
 * MethodNameChecker.cfc
 *
 * Checks for method naming convention violations
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "METHOD_INVALID_NAME";
        variables.ruleName = "MethodNameChecker";
        variables.description = "Method has invalid name";
        variables.severity = "INFO";
        variables.message = "Method name *function* is not a valid name. Please use camelCase or underscores";
        variables.group = "Naming";
        variables.parameters = {
            "minLength": 3,
            "maxLength": 25,
            "maxWords": 5,
            "case": "camelCase"
        };
        return this;
    }
    
    /**
     * Check AST for method naming issues
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for method naming conventions
        // Should detect: METHOD_INVALID_NAME, METHOD_ALLCAPS_NAME, METHOD_TOO_SHORT,
        // METHOD_TOO_LONG, METHOD_TOO_WORDY, METHOD_IS_TEMPORARY, METHOD_HAS_PREFIX_OR_POSTFIX
        
        return results;
    }
}
