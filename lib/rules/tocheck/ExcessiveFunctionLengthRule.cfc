/**
 * EXCESSIVE_FUNCTION_LENGTH Rule
 * 
 * Detects functions that are too long and should be broken down
 */
component extends="../BaseRule" {
    
     variables.parameters = {
            "length": 100
    };

    function init() {
        variables.ruleCode = "EXCESSIVE_FUNCTION_LENGTH";
        variables.ruleName = "FunctionLengthChecker";
        variables.description = "Method is too long";
        variables.severity = "WARNING";
        variables.message = "Function *function* is *variable* lines. Should be fewer than *maxLength* lines";
        variables.group = "Complexity";
        return this;
    }
    
    /**
     * Check AST for overly long functions
     */
    function check(required struct node, required any helper, string fileName = "") {
        var results = [];
        var maxLength = getParameter("length", 100);
        
        // Find all function declarations
        var functions = helper.getAllFunctions();
        
        for (var func in functions) {
            var functionName = getFunctionName(func);
            var lineCount = helper.countLinesInNode(func);
            
            if (lineCount > maxLength) {
                var message = variables.message;
                message = replace(message, "*function*", functionName);
                message = replace(message, "*variable*", lineCount);
                message = replace(message, "*maxLength*", maxLength);
                
                results.append(
                    createResultFromNode(
                        message = message,
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
}
