/**
 * EXCESSIVE_FUNCTION_LENGTH Rule
 * 
 * Detects functions that are too long and should be broken down
 */
component extends="../BaseRule" {
    
     

    function init() {
        variables.ruleCode = "EXCESSIVE_FUNCTION_LENGTH";
        variables.ruleName = "FunctionLengthChecker";
        variables.description = "Method is too long";
        variables.severity = "WARNING";
        variables.message = "Function *function* is *variable* lines. Should be fewer than *maxLength* lines";
        variables.group = "Complexity";
        variables.nodetype = "FunctionDeclaration";
        variables.parameters = {
                "length": 100
        };

        return this;
    }
    
    /**
     * Check AST for overly long functions
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        var maxLength = getParameter("length", 100);
        var functionName = node.name.value;
        
        var functionLineLength = abs(node.end.line - node.start.line);
        if(functionLineLength  GT maxLength){
                results.append(
                    createLintResult(
                        lintRule    = this,
                        node        = node,
                        fileName    = fileName,
                        fileContent = fileContent,
                        message     = "Function #functionName# is #functionLineLength# lines. Should be fewer than #maxLength# lines"

                    )
                );
        }
        return results;
    }
    
}
