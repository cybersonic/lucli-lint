/**
 * Avoid using SQL Rule
 * 
 * Detects usage of SQL and quueries in a file. Returns all the usages where there are query calls and the locations of any sql variables. 
 */
component extends="../BaseRule" {
    
    function initRuleProperties() {
        variables.ruleCode = "AVOID_USING_SQL";
        variables.ruleName = "SQLChecker";
        variables.description = "Avoid use of SQL queries";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving SQL queries in this file";
        variables.group = "OptionalRules";
    }
    
    /**
     * Check AST for cfquerytags and sql variables
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
