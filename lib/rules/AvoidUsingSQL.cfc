/**
 * Avoid using SQL Rule
 * 
 * Detects usage of SQL and quueries in a file. Returns all the usages where there are query calls and the locations of any sql variables. 
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_SQL";
        variables.ruleName = "SQLChecker";
        variables.description = "Avoid use of SQL";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving SQL queries in this file";
        variables.group = "OptionalRules";
        return this;
    }
    
    /**
     * Check AST for cfquerytags and sql variables
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];


        
        // Find all CFML tags named "dump"
        var queryTags = helper.getCFMLTagsByName("query");
        results.append(queryTags, true);

        // Find all queryExecute function calls
        var queryFuncs = helper.getAllCallExpressions().filter(
            function(item){
                return item?.callee?.type == "Identifier" && item?.callee?.name == "queryExecute";
            }
        );
        results.append(queryFuncs, true);
      

        for(var qf in queryFuncs){
            // dump(qf);
            var sqlArgument = qf.arguments[1] ?: {};
            var varNameToFind = "";
            // queryExectute( "select now()") or queryExecute( sqlVar )
            if(sqlArgument.type == "Identifier") {
                // This is a variable - we should find its declaration
                varNameToFind = sqlArgument.name;
                var assignments = helper.getAssignmentsByVariableName(varNameToFind, qf);
                // dump(var=assignments, label="Found sql variable name from identifier");
                results.append(assignments, true);
                
            }
            else if(sqlArgument.type == "NamedArgument"){
                var type = sqlArgument.value?.type;
                if(type == "Identifier"){
                    varNameToFind = sqlArgument.value.name;
                    var assignments = helper.getAssignmentsByVariableName(varNameToFind, qf);
                    // dump(var=assignments, label="Found sql variable name from named argument");
                    results.append(assignments, true);
                }
            }
        }
        

        // Finally Sort it
        results.sort(
            function(a, b){
                return a.start.line - b.start.line;
            }
        );

        var resultNodes = [];
        for (var item in results) {
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
