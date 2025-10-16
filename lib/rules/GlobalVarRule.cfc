/**
 * GLOBAL_VAR Rule
 * 
 * Detects usage of global variables which should be avoided in CFCs and functions
 */
component extends="../BaseRule" {
    
    function initRuleProperties() {
        variables.ruleCode = "GLOBAL_VAR";
        variables.ruleName = "GlobalVarChecker";
        variables.description = "Global variable exists";
        variables.severity = "WARNING";
        variables.message = "Identifier *variable* is global. Referencing in a CFC or function should be avoided";
        variables.group = "BugProne";
    }
    
    /**
     * Check AST for global variable usage
     */
    function check(required struct node, required any helper, string fileName = "") {
        var results = [];
        
        // Find all identifier nodes
        var identifiers = helper.getAllIdentifiers();
        
        for (var identifier in identifiers) {
            var name = helper.getIdentifierName(identifier);
            
            if (len(name) > 0 && isGlobalVariable(name)) {
                results.append(
                    createResultFromNode(
                        message = variables.message,
                        node = identifier,
                        fileName = arguments.fileName,
                        variable = name
                    )
                );
            }
        }
        
        return results;
    }
    
    /**
     * Check if variable is a global variable that should be avoided
     */
    function isGlobalVariable(required string varName) {
        var globalVars = [
            // Application-level variables that are often misused
            "application",
            "session", 
            "server",
            "client",
            
            // Form and URL scope (often better to scope explicitly)
            "form",
            "url",
            
            // Variables scope when used globally
            "variables"
        ];
        
        // Check if it's a direct reference to a global scope
        var lowerName = lCase(arguments.varName);
        
        // Check for unscoped variables that could be global
        for (var globalVar in globalVars) {
            if (lowerName == globalVar) {
                return true;
            }
        }
        
        // Check for variables that start with global scope prefixes
        // but are not properly scoped (this is more complex to detect accurately)
        return false;
    }
}
