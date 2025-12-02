/**
 * AbortChecker.cfc
 *
 * Checks for abort statement usage
 *
 * @author  Mark Drew
 * @date 2nd December 2025
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_ABORT";
        variables.ruleName = "AbortChecker";
        variables.description = "Avoid use of abort statements";
        variables.severity = "INFO";
        variables.message = "Avoid using abort in production code";
        variables.group = "BadPractice";
        variables.nodeType = "CFMLTag";

         variables.parameters = {
            "extensions": "cfm,cfml,cfc",
            "tagOnly": false
        };
        return this;
    }
    
    /**
     * Check AST for abort statements
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
       
        
        var results = [];
        var isAbort = (
                        (node.type == "CFMLTag" && node.name == "abort") 
                        OR (node.type == "CallExpression"  
                        AND node?.callee?.type == "Identifier" 
                        AND node?.callee?.name == "abort")
                    );



        if(isAbort){

            // Looks like tags have the "fullname" property
            var isTag = node.keyExists("fullname") ? true : false; 
            if( variables.parameters.tagOnly AND !isTag ){
                return results;
            }
        
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
