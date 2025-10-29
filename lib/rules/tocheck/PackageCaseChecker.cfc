/**
 * PackageCaseChecker.cfc
 *
 * Checks for package case mismatches
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "PACKAGE_CASE_MISMATCH";
        variables.ruleName = "PackageCaseChecker";
        variables.description = "Package case does not match its use";
        variables.severity = "WARNING";
        variables.message = "The case of the package folder and the object declaration do not match for *variable*";
        variables.group = "Naming";
        return this;
    }
    
    /**
     * Check AST for package case mismatches
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // Only check if we have a fileName
        if (len(arguments.fileName) == 0) {
            return results;
        }
        
        // Only check .cfc files
        var extension = listLast(arguments.fileName, ".");
        if (lcase(extension) != "cfc") {
            return results;
        }
        
        // Get the component name from file system path
        var fileNameOnly = listLast(arguments.fileName, "/\\");
        var fileBaseName = listFirst(fileNameOnly, ".");
        
        // Get all components/objects from the AST
        var components = arguments.helper.getAllComponents();
        
        if (arrayLen(components) == 0) {
            return results;
        }
        
        // Check the component name against the file name
        for (var component in components) {
            // If component has a name attribute, check if it matches the file name case
            if (structKeyExists(component, "name") && isSimpleValue(component.name)) {
                var componentName = component.name;
                
                // Compare case-insensitively but check if exact case matches
                if (lcase(componentName) == lcase(fileBaseName) && componentName != fileBaseName) {
                    var res = createLintResult(
                        lintRule = this,
                        node = component,
                        fileName = arguments.fileName,
                        fileContent = arguments.fileContent
                    );
                    res.setVariable(fileBaseName);
                    results.append(res);
                }
            }
        }
        
        return results;
    }
}
