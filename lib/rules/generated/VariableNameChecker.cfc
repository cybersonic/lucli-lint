/**
 * VariableNameChecker.cfc
 *
 * Checks for variable naming convention violations
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "VAR_INVALID_NAME";
        variables.ruleName = "VariableNameChecker";
        variables.description = "Variable has invalid name";
        variables.severity = "INFO";
        variables.message = "Variable *variable* is not a valid name. Please use camelCase or underscores";
        variables.group = "Naming";
        variables.parameters = {
            "minLength": 3,
            "maxLength": 20,
            "maxWords": 4,
            "ignoreUpperCaseScopes": "CGI,URL",
            "ignoreAllCapsInScopes": "this,variables",
            "ignorePrefixPostfixOn": "thisTag",
            "case": "camelCase"
        };
        return this;
    }
    
    /**
     * Check AST for variable naming issues
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for variable naming conventions
        // Should detect: VAR_INVALID_NAME, VAR_ALLCAPS_NAME, SCOPE_ALLCAPS_NAME, 
        // VAR_TOO_SHORT, VAR_TOO_LONG, VAR_TOO_WORDY, VAR_IS_TEMPORARY, VAR_HAS_PREFIX_OR_POSTFIX
        
        return results;
    }
}
