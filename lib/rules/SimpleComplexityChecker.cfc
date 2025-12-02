/**
 * SimpleComplexityChecker.cfc
 *
 * Checks for overly complex functions
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "FUNCTION_TOO_COMPLEX";
        variables.ruleName = "SimpleComplexityChecker";
        variables.description = "Function is too complex";
        variables.severity = "WARNING";
        // LintResult only substitutes *variable*, so we use that placeholder
        variables.message = "Function *variable* is too complex. Consider breaking the function into smaller functions";
        variables.group = "Complexity";
        variables.parameters = {
            "maximum": 10
        };
        // This rule only applies to function declarations
        variables.nodetype = "FunctionDeclaration";
        return this;
    }
    
    /**
     * Check AST for complex functions (cyclomatic complexity)
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        var functionName = node.name.value;
       
        var maxComplexity = getParameter("maximum", 10);
        var complexity    = calculateCyclomaticComplexity(node, helper);

        
            


        if (complexity > maxComplexity) {
            var lint = createLintResult(
                lintRule    = this,
                node        = node,
                fileName    = fileName,
                fileContent = fileContent
            );
            

            var msg = Replace(variables.message, "*variable*", functionName & " (complexity=" & complexity & ", max=" & maxComplexity & ")");
            lint.setMessage(msg);
            lint.setVariable(functionName);
            lint.setValue(complexity);
           
            // Try to determine a useful function name from the node
            // var fnName = "";
            // if (structKeyExists(node, "name")) {
            //     fnName = node.name;
            // } else if (structKeyExists(node, "id") && structKeyExists(node.id, "name")) {
            //     fnName = node.id.name;
            // }

            // if (len(fnName)) {
            //     // Store function name and complexity details in the *variable* placeholder
            //     lint.setVariable("#fnName# (complexity=#complexity#, max=#maxComplexity#)");
            // }

            arrayAppend(results, lint);
        }
        
        return results;
    }

    /**
     * Rough cyclomatic complexity calculation for a function node.
     * Starts at 1 and increments for each decision point found.
     */
    private numeric function calculateCyclomaticComplexity(required struct functionNode, required any helper) {
        var complexity = 1; // base path

        helper.traverseNode(functionNode, function(n) {
            var type = (n.type ?: "");
            

            // Script-style control structures (names are typical for Lucee/JS-style ASTs)
            switch (type) {
                case "IfStatement":
                // case "ForStatement":
                // case "ForInStatement":
                // case "ForOfStatement":
                // case "WhileStatement":
                // case "DoWhileStatement":
                case "SwitchStatement":
                case "SwitchCase":
                // case "CatchClause":
                // case "ConditionalExpression": // ternary ?:
                    complexity++;
                    break;
            }
           
            
            if(isSimpleValue(type) && type EQ "BinaryExpression"){
                // if( listFindNoCase("&&,||,AND,OR", n.operator) ){
                // All BinaryExpressions
                    complexity++;
                // }
                
            }
         
            // Logical operators inside expressions: a && b || c
            // if (type == "LogicalExpression" && structKeyExists(n, "operator")) {
            //     if (listFindNoCase("&&,||,AND,OR", n.operator)) {
            //         complexity++;
            //     }
            // }

            // Tag-based CFML control structures represented as CFMLTag nodes
            // if (type == "CFMLTag" && structKeyExists(n, "name")) {
            //     // Adjust this list as you learn the exact tag names in the AST
            //     if (listFindNoCase("if,elseif,loop,while,switch,case,catch", n.name)) {
            //         complexity++;
            //     }
            // }
        });

        return complexity;
    }
}
