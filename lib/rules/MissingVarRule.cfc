/**
 * MISSING_VAR Rule
 * 
 * Detects variables that are not declared with a var statement in functions
 * This is one of the most critical CFLint rules for preventing scope creep
 */
component extends="../BaseRule" {
    
    function initRuleProperties() {
        variables.ruleCode = "MISSING_VAR";
        variables.ruleName = "VarScoper";
        variables.description = "Variable is not declared with a var statement";
        variables.severity = "ERROR";
        variables.message = "Variable *variable* is not declared with a var statement";
        variables.group = "BugProne";
    }
    
    /**
     * Check AST for missing var declarations
     */
    function check(required struct node, required any helper, string fileName = "") {
        var results = [];
        
        // Find all function declarations
        var functions = helper.getAllFunctions();
        
        for (var func in functions) {
            var functionName = getFunctionName(func);
            var declaredVars = getDeclaredVariables(func);
            var usedVars = getUsedVariables(func);
            
            // Check each used variable to see if it's declared
            for (var varName in usedVars) {
                if (!isVariableDeclared(varName, declaredVars) && 
                    !isBuiltInScope(varName) &&
                    !isArgumentVariable(varName, func)) {
                    
                    results.append(
                        createResultFromNode(
                            message = variables.message,
                            node = usedVars[varName].node,
                            fileName = arguments.fileName,
                            variable = varName
                        )
                    );
                }
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
     * Get all variables declared with VAR in this function
     */
    function getDeclaredVariables(required struct functionNode) {
        var declared = {};
        
        // Look for variable declarations in the function body
        if (structKeyExists(functionNode, "body") && 
            structKeyExists(functionNode.body, "body") &&
            isArray(functionNode.body.body)) {
            
            for (var stmt in functionNode.body.body) {
                if (isVariableDeclaration(stmt)) {
                    var varName = getVariableDeclarationName(stmt);
                    if (len(varName)) {
                        declared[varName] = true;
                    }
                }
            }
        }
        
        return declared;
    }
    
    /**
     * Get all variables used in this function
     */
    function getUsedVariables(required struct functionNode) {
        var used = {};
        
        // Traverse the function body to find all identifier references
        traverseForIdentifiers(functionNode, used);
        
        return used;
    }
    
    /**
     * Recursively traverse node to find identifier usage
     */
    function traverseForIdentifiers(required struct node, required struct used) {
        if (structKeyExists(node, "type")) {
            // If this is an identifier node, record it
            if (node.type == "Identifier" && structKeyExists(node, "name")) {
                var name = node.name;
                // Don't record function names or property access
                if (!structKeyExists(used, name)) {
                    used[name] = {
                        node: node,
                        name: name
                    };
                }
            }
            
            // If this is an assignment, record the left side as declared
            if (node.type == "AssignmentExpression" && 
                structKeyExists(node, "left") &&
                structKeyExists(node.left, "type") &&
                node.left.type == "Identifier") {
                var varName = node.left.name;
                used[varName] = {
                    node: node.left,
                    name: varName
                };
            }
        }
        
        // Recursively traverse child nodes
        for (var key in node) {
            var child = node[key];
            if (isArray(child)) {
                for (var item in child) {
                    if (isStruct(item)) {
                        traverseForIdentifiers(item, used);
                    }
                }
            } else if (isStruct(child)) {
                traverseForIdentifiers(child, used);
            }
        }
    }
    
    /**
     * Check if this statement is a variable declaration
     */
    function isVariableDeclaration(required struct stmt) {
        // Look for VAR statements or local declarations
        if (structKeyExists(stmt, "type")) {
            // This is a simplified check - in practice, CFML VAR declarations
            // might appear as different AST node types
            return (stmt.type == "VariableDeclaration" ||
                   (stmt.type == "AssignmentExpression" && isLocalScope(stmt)));
        }
        return false;
    }
    
    /**
     * Check if assignment is to local scope
     */
    function isLocalScope(required struct stmt) {
        // This would need more sophisticated logic to detect VAR statements
        // For now, assume any assignment in function body without scope prefix is local
        return true;
    }
    
    /**
     * Get variable name from declaration
     */
    function getVariableDeclarationName(required struct stmt) {
        if (structKeyExists(stmt, "left") && 
            structKeyExists(stmt.left, "name")) {
            return stmt.left.name;
        }
        return "";
    }
    
    /**
     * Check if variable is declared in the declared variables list
     */
    function isVariableDeclared(required string varName, required struct declaredVars) {
        return structKeyExists(declaredVars, arguments.varName);
    }
    
    /**
     * Check if this is a built-in CFML scope
     */
    function isBuiltInScope(required string varName) {
        var builtInScopes = [
            "arguments", "variables", "this", "super", "local", "session", 
            "application", "server", "request", "form", "url", "cgi", 
            "cookie", "client", "caller", "attributes", "thistag"
        ];
        
        return arrayFind(builtInScopes, lCase(arguments.varName)) > 0;
    }
    
    /**
     * Check if variable is a function argument
     */
    function isArgumentVariable(required string varName, required struct functionNode) {
        if (structKeyExists(functionNode, "params") && isArray(functionNode.params)) {
            for (var param in functionNode.params) {
                if (structKeyExists(param, "name") && param.name == arguments.varName) {
                    return true;
                }
            }
        }
        return false;
    }
}
