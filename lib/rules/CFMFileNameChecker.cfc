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
        variables.ruleCode = "CFM_FILE_INVALID_NAME";
        variables.ruleName = "FileCaseChecker";
        variables.description = "CFM File has an invalid name";
        variables.severity = "INFO";
        variables.message = "File *filename*is not a valid name. Only components (.cfc files) should start with an upper case letter";
        variables.group = "Naming";
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
        var extension = listLast(arguments.fileName, ".");

        // We could register interest in extension only so we dont have to keep doing this. Although we might only do it in. a couple of components.
        if(!ListFindNoCase("cfm,cfs", extension)){
            return results;
        }

     
        var fileNameOnly = getFileFromPath(arguments.fileName);
        // There could be other dots in the the name, such as main.display.cfm
        var baseFileName = listDeleteAt(fileNameOnly,ListLen(fileNameOnly, "."), ".");

        // Get the first character of the base filename
        var firstChar = left(baseFileName, 1);
        var componentName = baseFileName;

        // Check if first character is uppercase (and not a number)
        if (reFind("^[A-Z]", firstChar)) {
                 results.append(
                    createLintResult(
                        lintRule = this,
                        node = arguments.node,
                        fileName = arguments.fileName,
                        fileContent = arguments.fileContent,
                        variable=componentName,
                        ruleCode="FILE_SHOULD_START_WITH_LOWERCASE",
                        message="CFML File name #componentName# should start with a lowercase letter"
                    )
                );
            }


        // dump(fileNameOnly);
        // dump(fileName);
        // dump(baseFileName);
        
        // // Only check .cfm files (not .cfc files)
        // if ((lcase(extension) == "cfm" || lcase(extension) == "cfs") && len(baseFileName) > 0) {
        //     // Check if first character is uppercase
        //     var firstChar = left(baseFileName, 1);
        //     if (firstChar == ucase(firstChar) && reFind("[A-Z]", firstChar)) {
        //         var res = createLintResult(
        //             lintRule = this,
        //             node = arguments.node,
        //             fileName = arguments.fileName,
        //             fileContent = arguments.fileContent
        //         );
        //         res.setVariable(fileNameOnly);
        //         results.append(res);
        //     }
        // }
        
        return results;
    }
}
