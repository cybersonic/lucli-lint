/**
 * VAR_INVALID_NAME Rule
 * 
 * Checks variable names against naming conventions
 */
component extends="../BaseRule" {
    
    // Default parameters
    variables.parameters = {
        "case": "camelCase",
        "minLength": 3,
        "maxLength": 20,
        "maxWords": 4
    };


    function init() {
        variables.ruleCode = "VAR_INVALID_NAME";
        variables.ruleName = "VariableNameChecker";
        variables.description = "Variable has invalid name";
        variables.severity = "INFO";
        variables.message = "Variable *variable* is not a valid name. Please use camelCase or underscores";
        variables.group = "Naming";
        return this;
    }
    
    /**
     * Check AST for variable naming violations
     */
    function check(required struct node, required any helper, string fileName = "") {
        var results = [];
        
        // Get all identifier nodes (variables)
        var identifiers = helper.getAllIdentifiers();
        
        for (var identifier in identifiers) {
            var name = helper.getIdentifierName(identifier);
            
            if (len(name) > 0) {
                // Check various naming violations
                var violations = checkVariableName(name);
                
                for (var violation in violations) {
                    results.append(
                        createResultFromNode(
                            message = violation.message,
                            node = identifier,
                            fileName = arguments.fileName,
                            variable = name
                        )
                    );
                }
            }
        }
        
        return results;
    }
    
    /**
     * Check a variable name for violations
     * @param name The variable name to check
     * @return Array of violation structs
     */
    function checkVariableName(required string name) {
        var violations = [];
        var caseStyle = getParameter("case", "camelCase");
        var minLength = getParameter("minLength", 3);
        var maxLength = getParameter("maxLength", 20);
        var maxWords = getParameter("maxWords", 4);
        
        // Remove any scope prefixes
        var cleanName = listLast(arguments.name, ".");
        
        // Check length
        if (len(cleanName) < minLength) {
            violations.append({
                code: "VAR_TOO_SHORT",
                message: "Variable *variable* should be longer than " & minLength & " characters"
            });
        }
        
        if (len(cleanName) > maxLength) {
            violations.append({
                code: "VAR_TOO_LONG", 
                message: "Variable *variable* should be shorter than " & maxLength & " characters"
            });
        }
        
        // Check for all caps
        if (cleanName == uCase(cleanName) && len(cleanName) > 1) {
            violations.append({
                code: "VAR_ALLCAPS_NAME",
                message: "Variable *variable* should not be upper case"
            });
        }
        
        // Check case style
        if (!isValidCaseStyle(cleanName, caseStyle)) {
            violations.append({
                code: "VAR_INVALID_NAME",
                message: "Variable *variable* is not a valid name. Please use " & caseStyle & " or underscores"
            });
        }
        
        // Check for temporary-looking names
        if (isTemporaryName(cleanName)) {
            violations.append({
                code: "VAR_IS_TEMPORARY",
                message: "Temporary variable *variable* could be named better"
            });
        }
        
        // Check word count (approximate by counting transitions)
        var wordCount = countWords(cleanName);
        if (wordCount > maxWords) {
            violations.append({
                code: "VAR_TOO_WORDY",
                message: "Variable *variable* is too wordy. Try to think of a more concise name"
            });
        }
        
        return violations;
    }
    
    /**
     * Check if name follows the specified case style
     */
    function isValidCaseStyle(required string name, required string caseStyle) {
        switch(arguments.caseStyle) {
            case "camelCase":
                // Should start with lowercase, then camelCase
                return reFind("^[a-z][a-zA-Z0-9]*$", arguments.name) > 0;
            case "PascalCase":
                // Should start with uppercase, then PascalCase
                return reFind("^[A-Z][a-zA-Z0-9]*$", arguments.name) > 0;
            case "snake_case":
                // Should be lowercase with underscores
                return reFind("^[a-z][a-z0-9_]*$", arguments.name) > 0;
            default:
                return true;
        }
    }
    
    /**
     * Check if name looks temporary
     */
    function isTemporaryName(required string name) {
        var tempPatterns = [
            "^temp",
            "^tmp",
            "^test",
            "^foo",
            "^bar",
            "^baz",
            "^x$",
            "^y$",
            "^z$",
            "^i$",
            "^j$",
            "^k$"
        ];
        
        var lowerName = lCase(arguments.name);
        
        for (var pattern in tempPatterns) {
            if (reFind(pattern, lowerName)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Count approximate number of words in a name
     */
    function countWords(required string name) {
        // Count uppercase letters (camelCase transitions) and underscores
        var words = 1;
        
        for (var i = 1; i <= len(arguments.name); i++) {
            var char = mid(arguments.name, i, 1);
            if (char == "_" || (asc(char) >= 65 && asc(char) <= 90)) {
                words++;
            }
        }
        
        return words;
    }
}
