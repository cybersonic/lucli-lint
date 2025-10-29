/**
 * ComponentNameChecker.cfc
 *
 * Checks for component naming convention violations
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "COMPONENT_INVALID_NAME";
        variables.ruleName = "ComponentNameChecker";
        variables.description = "Component has invalid name";
        variables.severity = "INFO";
        variables.message = "Component name *component* is not a valid name. Please use PascalCase and start with a capital letter";
        variables.group = "Naming";
        variables.parameters = {
            "minLength": 3,
            "maxLength": 15,
            "maxWords": 3,
            "case": "PascalCase"
        };
        return this;
    }
    
    /**
     * Check AST for component naming issues
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // Only check .cfc files
        if (len(arguments.fileName) > 0) {
            var extension = listLast(arguments.fileName, ".");
            if (lcase(extension) != "cfc") {
                return results;
            }
            
            // Get the component name from file name
            var fileNameOnly = listLast(arguments.fileName, "/\\");
            var componentName = listFirst(fileNameOnly, ".");
            
            // Get configuration parameters
            var minLength = getParameter("minLength", 3);
            var maxLength = getParameter("maxLength", 15);
            var maxWords = getParameter("maxWords", 3);
            var caseStyle = getParameter("case", "PascalCase");
            
            var issueCode = "";
            var issueMessage = "";
            
            // Check if name is all caps
            if (componentName == ucase(componentName) && reFind("[A-Z]", componentName)) {
                issueCode = "COMPONENT_ALLCAPS_NAME";
                issueMessage = "Component name #componentName# should not be all upper case";
            }
            // Check if name is too short
            else if (len(componentName) < minLength) {
                issueCode = "COMPONENT_TOO_SHORT";
                issueMessage = "Component name #componentName# should be longer than #minLength# characters";
            }
            // Check if name is too long
            else if (len(componentName) > maxLength) {
                issueCode = "COMPONENT_TOO_LONG";
                issueMessage = "Component name #componentName# should be shorter than #maxLength# characters";
            }
            // Check PascalCase (should start with uppercase)
            else if (caseStyle == "PascalCase" && left(componentName, 1) != ucase(left(componentName, 1))) {
                issueCode = "COMPONENT_INVALID_NAME";
                issueMessage = "Component name #componentName# is not a valid name. Please use PascalCase and start with a capital letter";
            }
            // Check for too many words (count uppercase letters as word boundaries)
            else if (len(componentName) - len(reReplace(componentName, "[A-Z]", "", "all")) > maxWords) {
                issueCode = "COMPONENT_TOO_WORDY";
                issueMessage = "Component name #componentName# is too wordy. Try to think of a more concise name";
            }
            // Check for temporary-looking names
            else if (reFindNoCase("^(temp|tmp|test|foo|bar|baz)", componentName)) {
                issueCode = "COMPONENT_IS_TEMPORARY";
                issueMessage = "Component name #componentName# could be named better";
            }
            // Check for common prefixes/postfixes
            else if (reFindNoCase("(Helper|Util|Manager|Handler|Processor|Controller|Service)$", componentName)) {
                // This is actually acceptable for components, so we'll skip this check
                // but leaving the structure in case we want to add it back
            }
            
            // If we found an issue, create a lint result
            if (len(issueCode) > 0) {
                var res = createLintResult(
                    lintRule = this,
                    node = arguments.node,
                    fileName = arguments.fileName,
                    fileContent = arguments.fileContent
                );
                res.setVariable(componentName);
                // Override the rule code and message for specific issues
                res.ruleCode = issueCode;
                res.message = issueMessage;
                results.append(res);
            }
        }
        
        return results;
    }
}
