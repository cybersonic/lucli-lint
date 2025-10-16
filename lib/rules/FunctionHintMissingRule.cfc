/**
 * FUNCTION_HINT_MISSING Rule
 * 
 * Detects functions that are missing hint attributes for documentation
 */
component extends="../BaseRule" {
    
    function initRuleProperties() {
        variables.ruleCode = "FUNCTION_HINT_MISSING";
        variables.ruleName = "FunctionHintChecker";
        variables.description = "Function is missing a hint";
        variables.severity = "INFO";
        variables.message = "Function *variable* is missing a hint";
        variables.group = "CodeStyle";
    }
    
    /**
     * Check AST for functions missing hints
     */
    function check(required struct node, required any helper, string fileName = "") {
        var results = [];
        
        // Find all function declarations
        var functions = helper.getAllFunctions();
        
        for (var func in functions) {
            var functionName = getFunctionName(func);
            
            if (!hasFunctionHint(func)) {
                results.append(
                    createResultFromNode(
                        message = variables.message,
                        node = func,
                        fileName = arguments.fileName,
                        variable = functionName
                    )
                );
            }
        }
        
        return results;
    }
    
    /**
     * Get function name from function declaration node
     */
    function getFunctionName(required struct functionNode) {
        if (structKeyExists(functionNode, "id") && 
            structKeyExists(functionNode.id, "name")) {
            return functionNode.id.name;
        }
        return "anonymous";
    }
    
    /**
     * Check if function has a hint attribute
     */
    function hasFunctionHint(required struct functionNode) {
        // Look for hint in function attributes
        if (structKeyExists(functionNode, "attributes") && isArray(functionNode.attributes)) {
            for (var attr in functionNode.attributes) {
                if (structKeyExists(attr, "name") && 
                    lCase(attr.name) == "hint" &&
                    structKeyExists(attr, "value") &&
                    len(trim(getAttributeValue(attr)))) {
                    return true;
                }
            }
        }
        
        // Also check for javadoc-style comments above function
        return hasJavaDocComment(functionNode);
    }
    
    /**
     * Check if function has javadoc-style comments
     */
    function hasJavaDocComment(required struct functionNode) {
        // This would need to check for comments in the AST
        // Lucee's AST might not include comments, so this is simplified
        return false;
    }
    
    /**
     * Get attribute value from attribute node
     */
    function getAttributeValue(required struct attr) {
        if (structKeyExists(attr, "value")) {
            if (isStruct(attr.value) && structKeyExists(attr.value, "value")) {
                return attr.value.value;
            } else if (isSimpleValue(attr.value)) {
                return attr.value;
            }
        }
        return "";
    }
}
