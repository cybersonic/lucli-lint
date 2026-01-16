/**
 * Avoid using SQL Rule
 * 
 * Detects usage of SQL and quueries in a file. Returns all the usages where there are query calls and the locations of any sql variables. 
 */
component extends="../BaseRule" {
    
    
    function init() {
        variables.ruleCode = "SQL_CHECK";
        variables.ruleName = "SQLChecker";
        variables.description = "Find SQL queries in code files";
        variables.severity = "WARNING";
        variables.message = "Found SQL query and related variables in code";
        variables.group = "OptionalRules";
        variables.enabled = false;
        variables.nodeTypes = "CFMLTag,CallExpression,AssignmentExpression"


        variables.parameters = {
            "extensions": "cfc,cfm,cfml"
        };

        return this;
    }
    
    /**
     * Check AST for cfquerytags and sql variables
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        // Check we are in a query node, works for both tag and function call;
        var isQueryNode = (
                            (node.type == "CFMLTag" && node.name == "query") //Query Tags
                            OR (node.type == "CallExpression"  //queryExecute
                            AND node?.callee?.type == "Identifier" 
                            AND compareNoCase(node?.callee?.name ?: "", "queryExecute") == 0)
                            OR (node.type == "AssignmentExpression" // var result = queryExecute(...)
                                AND node?.right?.type == "CallExpression"
                                AND node?.right?.callee?.type == "Identifier"
                                AND compareNoCase(node?.right?.callee?.name ?: "", "queryExecute") == 0)
                        );
    
        // More complex check for Query object creation
        if( node.type == "AssignmentExpression" && node?.right?.type == "CallExpression" &&
            node?.right?.isBuiltIn == true &&
            compareNoCase(node?.right?.callee?.name ?: "", "_createcomponent") == 0
        ){
            var suspectedQueryComponentArguments = node?.right?.arguments;
            var foundQuery = suspectedQueryComponentArguments.filter(
                function(arg){
                    return arg?.type == "StringLiteral" AND arg?.value == "Query";
                }
            );
            if( ArrayLen(foundQuery) ){
                isQueryNode = true;
            }
        }
        
        // Check we are in a query node;
        if(!isQueryNode){
            return results;
        }
        
        // Check the extensions
        var ext = listLast(fileName, ".");
        if( not listFindNoCase( variables.parameters.extensions, ext ) ){
            return results;
        }
        
        var sqlVariable = "";
        var hasSQLVariables = false;
        var variableAssignments = [];   
        var sqlContents = MID(fileContent, node.start.offset, node.end.offset - node.start.offset);

        // Handle queryExecute with positional items
        if( node.keyExists("arguments") && node.arguments.len() && node.arguments[1].type == "Identifier"  ){
            hasSQLVariables = true;
            sqlVariable = node.arguments[1].name;
            var parent = helper.findNodeParent(node);
        }
        // Handle queryExecute with named parameters
        if( node.keyExists("arguments") && node.arguments.len() && node.arguments[1].type == "NamedArgument"  ){
            if(node.arguments[1].value?.type == "Identifier"){
                hasSQLVariables = true;
                sqlVariable = node.arguments[1].value?.name;
            }
        }

        // If it is a tag, it has a body, let's see if it has any variables
        if(ArrayLen(node.body?.body ?: []) ){
            for(var bodyItem in node.body.body){
                if(bodyItem.type == "ExpressionStatement" AND bodyItem.expression?.type == "Identifier"){
                    hasSQLVariables = true;
                    sqlVariable = bodyItem.expression.name;
                    hasSQLVariables = true;
                }
            }
        }


        
        if(hasSQLVariables){
            variableAssignments = helper.getAssignmentsByVariableName(sqlVariable, node);
        }
        results.append(node);
        results.append(variableAssignments, true);
        // Now if we have a variable in the query, we can go find it's assignment.

        // Finally Sort it
        var sorted = results.sort(
            function(a, b){
                if(a.start.line == b.start.line){
                    return 0;
                }
                if(a.start.line > b.start.line){
                    return 1;
                }
                return -1;
            }
        );

        var resultNodes = [];
        for (var item in sorted) {
            resultNodes.append(
                createLintResult(
                    lintRule = this,
                    node = item,
                    fileName = arguments.fileName,
                    fileContent = arguments.fileContent
                )
            );
        }
        // dump(resultNodes);
        return resultNodes;
    }

    
}
