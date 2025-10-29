/**
 * ArgumentHintChecker.cfc
 *
 * Checks for missing argument hints
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "ARG_HINT_MISSING";
        variables.ruleName = "ArgumentHintChecker";
        variables.description = "Argument is missing a hint";
        variables.severity = "INFO";
        variables.message = "Argument *variable* is missing a hint";
        variables.group = "CodeStyle";
        return this;
    }
    
    /**
     * Check AST for arguments without hints
     * @node the current node we are looking through
     * @contenxt || @document
     * @helper a helper to find other things in the document 
     * @filename 
     * @fileContent
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for arguments without hint attribute
        
        return results;
    }
}
