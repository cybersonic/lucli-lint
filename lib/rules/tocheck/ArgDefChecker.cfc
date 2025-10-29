/**
 * ArgDefChecker.cfc
 *
 * Checks for optional arguments that do not define a default value.
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../BaseRule" {
    
    function init() {

        variables.ruleCode = "ARG_DEFAULT_MISSING";
        variables.ruleName = "ArgDefChecker";
        variables.description = "Optional argument is missing a default value";
        variables.severity = "WARNING";
        variables.message = "Argument variable is not required and does not define a default value";
        variables.group = "Correctness";
        return this;
    }
    
    /**
     * Check AST for argument definition
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // Find all CFML tags named "dump"
        var funcDecls = helper.getAllFunctions();
        
        for(var func in funcDecls){
            for(var param in func.params ?: []){
                if(param.required.value == false && !structKeyExists(param, "defaultValue")){
                    // dump(func=func, label="Function with param missing default value");
                    var res = createLintResult(
                       lintRule = this,
                        node = func,
                        fileName = arguments.fileName,
                        fileContent = arguments.fileContent
                    )
                    if(isSimpleValue(param.name.value)){
                        res.setVariable(param.name.value);
                    }

                    // Since we are in param, lets pass in the functions information
                    res.setLine(func.start.line);
                    res.setColumn(func.start.column);
                    res.setOffset(func.start.offset);

                    res.setEndLine(func.end.line);
                    res.setEndColumn(func.end.column);
                    res.setEndOffset(func.end.offset);

                    res.setCodeContents();
                    
                    results.append(
                        res
                    );
                }
            }
        }
        
        
        
        return results;
    }
}
