/**
 * Avoid using CFAbort Rule
 * 
 * Detects usage of <cfabort> tags and statements which should not be left in production code
 */
component extends="../BaseRule" {
    
    function initRuleProperties() {
        variables.ruleCode = "AVOID_USING_CFAbort_TAG";
        variables.ruleName = "CFDumpChecker";
        variables.description = "Avoid use of cfdump tags";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving <cfdump> tags in committed code. Debug information should be omitted from release code";
        variables.group = "BadPractice";
    }
    
    /**
     * Check AST for cfdump tag usage
     */
    function check(required struct node, required any helper, string fileName = "") {
        var results = [];
        
        // Find all CFML tags named "dump"
        var dumpTags = helper.getCFMLTagsByName("dump");
        
        for (var tag in dumpTags) {
            results.append(
                createResultFromNode(
                    message = variables.message,
                    node = tag,
                    fileName = arguments.fileName
                )
            );
        }
        
        return results;
    }
}
