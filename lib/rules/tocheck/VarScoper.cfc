/**
 * VarScoper.cfc
 *
 * Checks for variables not declared with var statement
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "MISSING_VAR";
        variables.ruleName = "VarScoper";
        variables.description = "Variable is not declared with a var statement";
        variables.severity = "ERROR";
        variables.message = "Variable *variable* is not declared with a var statement";
        variables.group = "BugProne";
        variables.nodeType = "FunctionDeclaration";
        return this;
    }
    
    /**
     * Check AST for variables without var declaration
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
            var results = [];

            if(node.type NEQ NODES.FUNCTIONDECLARATION ) {
                return [];
            }
            // Get all the variables 
            var varsInFunction = helper.getNodesByType(node, "AssignmentExpression");
            
            // dump(helper);
            // dump(node);
            
        
        
        return results;
    }
}
