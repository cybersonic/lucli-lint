/**
 * Avoid using SQL Rule
 * 
 * Detects usage of SQL and quueries in a file. Returns all the usages where there are query calls and the locations of any sql variables. 
 */
component extends="../BaseRule" {
    
    
    function init() {
        variables.ruleCode = "UNIT_TEST_CHECK";
        variables.ruleName = "UnitTestChecker";
        variables.description = "Find unit tests in code files";
        variables.severity = "WARNING";
        variables.message = "Found unit test and related variables in code";
        variables.group = "OptionalRules";
        variables.enabled = false;
        variables.nodeType = "Program"; //Will only run once per file


        variables.parameters = {
            "unit_test_regex": ""
        };

        return this;
    }
    
    /**
     * Check AST for cfquerytags and sql variables
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];

        if(reFindNoCase("#variables.parameters.unit_test_regex#", fileName)) {
            arrayAppend(results, createLintResult(
                lintRule = this,
                node = node,
                fileName = fileName,
                fileContent = fileContent,
                message = "Unit test related code found matching regex: #variables.parameters.unit_test_regex#"
            ));
        }      
        return results;
        
    }

    
}
