/**
 * SelectStarChecker.cfc
 *
 * Checks for SELECT * in queries
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "SQL_SELECT_STAR";
        variables.ruleName = "SelectStarChecker";
        variables.description = "Avoid using 'select *' in queries";
        variables.severity = "WARNING";
        variables.message = "Avoid using 'select *' in a query";
        variables.group = "BadPractice";
        return this;
    }
    
    /**
     * Check AST for SELECT * usage
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for SELECT * in SQL queries
        
        return results;
    }
}
