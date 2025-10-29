/**
 * FileCaseChecker.cfc
 *
 * Checks that CFM files start with lowercase
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "FILE_SHOULD_START_WITH_LOWERCASE";
        variables.ruleName = "FileCaseChecker";
        variables.description = "CFM File starts with upper case";
        variables.severity = "INFO";
        variables.message = "File *filename* starts with an upper case letter. Only components (.cfc files) should start with an upper case letter";
        variables.group = "Experimental";
        variables.nodeType = "Program";

        
        return this;
    }
    
    /**
     * Check file naming conventions
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // Only check if we have a fileName
        if (len(arguments.fileName) == 0) {
            return results;
        }
        
        // Get just the file name without path
        var fileNameOnly = listLast(arguments.fileName, "/\\");
        var extension = listLast(fileNameOnly, ".");
        var baseFileName = listFirst(fileNameOnly, ".");
        
        // Only check .cfm files (not .cfc files)
        if (lcase(extension) == "cfm" && len(baseFileName) > 0) {
            // Check if first character is uppercase
            var firstChar = left(baseFileName, 1);
            if (firstChar == ucase(firstChar) && reFind("[A-Z]", firstChar)) {
                var res = createLintResult(
                    lintRule = this,
                    node = arguments.node,
                    fileName = arguments.fileName,
                    fileContent = arguments.fileContent
                );
                res.setVariable(fileNameOnly);
                results.append(res);
            }
        }
        
        return results;
    }
}
