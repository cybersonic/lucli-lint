/**
 * QueryParamChecker.cfc
 *
 * Checks for query parameters usage in SQL statements
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "CFQUERYPARAM_REQ";
        variables.ruleName = "QueryParamChecker";
        variables.description = "cfquery should use <cfqueryparam>";
        variables.severity = "WARNING";
        variables.message = "<*tag*> should use <cfqueryparam/> for variable '*variable*'";
        variables.group = "Security";
        return this;
    }
    
    /**
     * Check AST for missing cfqueryparam
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for SQL statements without cfqueryparam
        
        return results;
    }
}
