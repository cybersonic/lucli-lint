/**
 * QueryNewChecker.cfc
 *
 * Checks for QueryNew with duplicate columns
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "QUERYNEW_DUPLICATE_COLUMNS";
        variables.ruleName = "QueryNewChecker";
        variables.description = "QueryNew declares duplicate columns";
        variables.severity = "ERROR";
        variables.message = "QueryNew declares column *variable* multiple times, this is a hard error in some CFML implementations";
        variables.group = "Correctness";
        return this;
    }
    
    /**
     * Check AST for QueryNew with duplicate columns
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for QueryNew with duplicate column names
        
        return results;
    }
}
