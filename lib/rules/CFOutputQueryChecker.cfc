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
        variables.ruleCode = "AVOID_CFOUTPUT_QUERY";
        variables.ruleName = "CFOutputQueryChecker";
        variables.description = "Avoid use of cfoutput with query attribute";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving `cfoutput query=` statements in committed code. Debug information should be omitted from release code";
        variables.group = "BadPractice";
        variables.enabled = false; //Disable by default
        variables.nodeType = "CFMLTag,CallExpression";

        variables.parameters = {
            "extensions": "cfm,cfml,cfc"
        };
        return this;
    }
    
    /**
     * Check AST for cfoutput with a query tags
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];


        var queryAttrbutes = node.attributes.filter((it)=>{
            return ( it.name.toLowerCase() == "query" );
        });

        if( queryAttrbutes.len() > 0 ){
            results.append(
                createLintResult(
                    lintRule = this,
                    node = arguments.node,
                    fileName = arguments.fileName,
                    fileContent = arguments.fileContent,
                    // code="cfoutput query=",
                    ruleCode="AVOID_CFOUTPUT_QUERY",
                    message="Avoid leaving cfoutput query statements in committed code. Debug information should be omitted from release code"
                )
            );
        }

       
        return results;
    }
}
