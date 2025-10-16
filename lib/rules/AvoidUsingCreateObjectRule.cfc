/**
 * AVOID_USING_CREATEOBJECT Rule
 * 
 * Suggests using modern syntax instead of createObject() function
 */
component extends="../BaseRule" {
    
    function initRuleProperties() {
        variables.ruleCode = "AVOID_USING_CREATEOBJECT";
        variables.ruleName = "CreateObjectChecker";
        variables.description = "Avoid use of creatObject statements";
        variables.severity = "INFO";
        variables.message = "CreateObject found. Use createObject(path_to_component) or even better new path_to_component()";
        variables.group = "ModernSyntax";
    }
    
    /**
     * Check AST for createObject usage
     */
    function check(required struct node, required any helper, string fileName = "") {
        var results = [];
        
        // Find all function call expressions
        var callExpressions = helper.findNodes(function(node) {
            return isStruct(node) && 
                   structKeyExists(node, "type") && 
                   node.type == "CallExpression";
        });
        
        for (var call in callExpressions) {
            if (isCreateObjectCall(call)) {
                results.append(
                    createResultFromNode(
                        message = variables.message,
                        node = call,
                        fileName = arguments.fileName
                    )
                );
            }
        }
        
        return results;
    }
    
    /**
     * Check if this call expression is a createObject call
     */
    function isCreateObjectCall(required struct callNode) {
        // Check if the callee is an identifier named "createObject"
        if (structKeyExists(callNode, "callee") && 
            structKeyExists(callNode.callee, "type") &&
            callNode.callee.type == "Identifier" &&
            structKeyExists(callNode.callee, "name")) {
            
            return lCase(callNode.callee.name) == "createobject";
        }
        
        return false;
    }
}
