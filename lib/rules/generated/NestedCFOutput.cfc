/**
 * NestedCFOutput.cfc
 *
 * Checks for nested cfoutput with cfquery tag
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "NESTED_CFOUTPUT";
        variables.ruleName = "NestedCFOutput";
        variables.description = "Nested cfoutput with cfquery tag";
        variables.severity = "ERROR";
        variables.message = "Nested CFOutput, outer CFOutput has @query";
        variables.group = "BugProne";
        return this;
    }
    
    /**
     * Check AST for nested cfoutput tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        if(node.type == "CFMLTag" AND node.name == "cfoutput" ){
            // Check if it has a query attribute
           
        }
        // TODO: Implement check for nested cfoutput tags with query attribute
        
        return results;
    }
}
