/**
 * Avoid using CFAbort Rule
 * 
 * Detects usage of <cfabort> tags and statements which should not be left in production code
 */
component extends="../BaseRule" {
    
    function init() {
        
        variables.ruleCode = "AVOID_USING_CFABORT_TAG";
        variables.ruleName = "CFAbortTagChecker";
        variables.description = "Avoid use of cfabort tags";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving <cfabort> tags in committed code. Try to handle errors more gracefully.";
        variables.group = "BadPractice";

        return this;
    }
    
    /**
     * Check AST for cfdump tag usage
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // Find all CFML tags named "dump"
        var abortTags = helper.getCFMLTagsByName("abort");
        
        for (var tag in abortTags) {
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
