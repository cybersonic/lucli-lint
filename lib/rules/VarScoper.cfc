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
            var functionName = node.name.value;
            // dump(var=node, expand=false);
            var hasLocalMode = nodeHasLocalMode(node);
            // Get all the variables 
            var varsInFunction = helper.getNodesByType(node, "AssignmentExpression");
            for(var varNode in varsInFunction){
                // We are only interested in assignments to Identifiers
                if(!structKeyExists(varNode, "left")){
                    continue;
                }
                
                // if we are type of MemberExpression, then we DO have var scoping (to local.)
                if( varNode.left.type == "MemberExpression" ){
                    continue;
                }

                // /if we have locamode, then we dont need var scoping
                if( hasLocalMode ){
                    continue;
                }

                // var VariableName = node.left.name;

                
                
                  var lint = createLintResult(
                            lintRule    = this,
                            node        = varNode,
                            fileName    = fileName,
                            fileContent = fileContent
                        );
                        
                var msg = Replace(variables.message, "*variable*", "[#varNode.left.name#]", "all");
                lint.setMessage(msg);
                lint.setVariable(varNode.left.name);
                results.append( lint );
            }
            
        
        
        return results;
    }

    function nodeHasLocalMode(struct node){
        var hasLocalMode = false;
        if(node.keyExists("localmode") && node.localmode.type == "IntegerLiteral"  && node.localmode.value == "2"){
            hasLocalMode = true;    
        }
        return hasLocalMode;
    }
}
