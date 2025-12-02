/**
 * CFDumpChecker.cfc
 *
 * Checks for cfdump tag usage
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "AVOID_USING_DUMP";
        variables.ruleName = "DumpChecker";
        variables.description = "Avoid use of dump statements";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving <cfdump> or dump() satements in committed code. Debug information should be omitted from release code";
        variables.group = "BadPractice";
        variables.nodeType = "CFMLTag,CallExpression";

        variables.parameters = {
            "extensions": "cfm,cfml,cfc"
        };
        return this;
    }
    
    /**
     * Check AST for cfdump tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];


        // if(variables.paramters.extensionsListLast(toLowerCase(arguments.fileName),".") NOT IN ListToArray( toLowerCase( variables.parameters.extensions ) )){
        //     return results;
        // }
     
        var isDump = (
            (node.type == "CFMLTag" && node.name == "dump") 
            OR (node.type == "CallExpression"  
            AND node?.callee?.type == "Identifier" 
            AND node?.callee?.name == "dump")
        );

       
        if(isDump){
            // Looks like tags have the "fullname" property
    
            results.append(
                createLintResult(
                        lintRule = this,
                        node = node,
                        fileName = arguments.fileName,
                        fileContent = arguments.fileContent
                    )
            );
        }
        return results;
    }
}
