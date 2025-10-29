/**
 * TypedQueryNew.cfc
 *
 * Checks that QueryNew specifies data types
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "QUERYNEW_DATATYPE";
        variables.ruleName = "TypedQueryNew";
        variables.description = "QueryNew statement should specify data types";
        variables.severity = "WARNING";
        variables.message = "QueryNew statement should specify datatypes";
        variables.group = "Correctness";
        return this;
    }
    
    /**
     * Check AST for QueryNew without datatypes
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for QueryNew without data types
        
        return results;
    }
}
