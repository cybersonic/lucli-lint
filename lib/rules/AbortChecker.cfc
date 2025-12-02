/**
 * AbortChecker.cfc
 *
 * Checks for abort statement usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_ABORT";
        variables.ruleName = "AbortChecker";
        variables.description = "Avoid use of abort statements";
        variables.severity = "INFO";
        variables.message = "Avoid using abort in production code";
        variables.group = "BadPractice";
        // variables.nodeType = "CFMLTag,CallExpression";
        return this;
    }
    
    /**
     * Check AST for abort statements
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
            var isAbort = (
                            (node.type == "CFMLTag" && node.name == "abort") //Query Tags
                            OR (node.type == "CallExpression"  //queryExecute
                            AND node?.callee?.type == "Identifier" 
                            AND node?.callee?.name == "abort")
                        );



        if(isAbort){
            results.append(
                createLintResult(
                        lintRule = this,
                        node = node,
                        fileName = arguments.fileName,
                        fileContent = arguments.fileContent
                    )
            );
           
        }

        return results;
    }
}
