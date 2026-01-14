/**
 * MethodNameChecker.cfc
 *
 * Checks for method naming convention violations
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "METHOD_INVALID_NAME";
        variables.ruleName = "MethodNameChecker";
        variables.description = "Method has invalid name";
        variables.severity = "INFO";
        variables.message = "Method name *function* is not a valid name. Please use camelCase or underscores";
        variables.group = "Naming";
        variables.nodeType = "FunctionDeclaration";
        variables.parameters = {
            "minLength": 3,
            "maxLength": 25,
            "maxWords": 5,
            "case": "camelCase"
        };
        return this;
    }
    
    /**
     * Check AST for method naming issues
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        var functionName = node.name.value ?: "";

      
        // Cant have a method without a name
        if(len(functionName) == 0){
            return results;
        }

        var functionPrototype = functionName & "(...){}";   
     
        if (Len(functionName) < getParameter("minLength", 3) ) {
                 results.append(
                    createLintResult(
                        lintRule = this,
                        node = arguments.node,
                        fileName = arguments.fileName,
                        fileContent = arguments.fileContent,
                        code=functionPrototype,
                        ruleCode="METHOD_TOO_SHORT",
                        message="Method/Function #functionName# should be longer than #getParameter('minLength', 3)# characters"
                    )
                );
        }
        if (Len(functionName) > getParameter("maxLength", 25) ) {
                 results.append(
                    createLintResult(
                        lintRule = this,
                        node = arguments.node,
                        fileName = arguments.fileName,
                        fileContent = arguments.fileContent,
                        code=functionPrototype,
                        ruleCode="METHOD_TOO_LONG",
                        message="Method/Function #functionName# should be shorter than #getParameter('maxLength', 25)# characters"
                    )
                );
        }
        if (Compare(functionName, uCase(functionName)) == 0) {

                 results.append(
                    createLintResult(
                        lintRule = this,
                        node = arguments.node,
                        fileName = arguments.fileName,
                        fileContent = arguments.fileContent,
                        code=functionPrototype,
                        ruleCode="METHOD_ALLCAPS_NAME",
                        message="Method/Function #functionName# should not be in all caps"
                    )
                );
        }
        // Extract words from camelCase string
      
        var words = getWordsFromCamelCase(functionName);
        // Check if too many words
        if (arrayLen(words) > getParameter("maxWords", 5)) {
            results.append(
                createLintResult(
                    lintRule = this,
                    node = arguments.node,
                    fileName = arguments.fileName,
                    fileContent = arguments.fileContent,
                    code = functionPrototype,
                    ruleCode = "METHOD_TOO_WORDY",
                    message = "Method/Function #functionName# has too many words (#arrayLen(words)#). Maximum is #getParameter('maxWords', 5)#"
                )
            );
        }

       
        
        // TODO: Implement check for method naming conventions
        // Should detect: METHOD_INVALID_NAME, ,
        // ,METHOD_TOO_WORDY, METHOD_IS_TEMPORARY, METHOD_HAS_PREFIX_OR_POSTFIX
        
        return results;
    }


    function getWordsFromCamelCase(required string str) {
        var words = [];
        var currentWord = "";
        for (var i = 1; i <= len(arguments.str); i++) {
            var char = mid(arguments.str, i, 1);
            if (reFind("[A-Z]", char) && len(currentWord) > 0) {
                words.append(currentWord);
                currentWord = char;
            } else {
                currentWord &= char;
            }
        }
        if (len(currentWord) > 0) {
            words.append(currentWord);
        }
        return words;
    }
}
