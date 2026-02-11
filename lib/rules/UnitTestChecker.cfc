/**
 * Checks if components in the source_folder defined in .lucli-lint.json have
 * a corresponding test in the test_folder
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
            "unit_test_regex": "",
            "source_folder": "",
            "test_folder": ""
        };

        return this;
    }
    
    /**
     * Check for corresponding test files for source files and vice versa
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        var fullPath = expandPath(fileName);
        if (isNull(variables.parameters.unit_test_regex) || trim(variables.parameters.unit_test_regex) EQ "") {
            systemOutput("unit_test_regex is empty or not set. Skipping regex check.");
            return results;
        }
        var matchResult = reFindNoCase("#variables.parameters.unit_test_regex#", fullPath, 1, true);
        // The unit_test_regex should have a format similar to the .lucli-lint.json file in this repo
        // "unit_test_regex": "(com/myapp/.*/)(.*)\\.(?:cfc|cfm)$" so that the first capturing group
        // holds the folder path of the component, and the second group holds the base name of the file.
        if(matchResult.pos[1] NEQ 0 && ArrayLen(matchResult.match) GT 2) {
            // Extract the path and filename components
            var folderPath = matchResult.match[2];
            var baseName = matchResult.match[3];

            // Determine if this is a test file by checking if it ends with "Test"
            var isTestFile = right(baseName, 4) == "Test";

            // If it's a test file, strip the "Test" suffix to get the actual base name
            if (isTestFile) {
                baseName = left(baseName, len(baseName) - 4);
            }

            // Construct relative paths for both source and test files
            var sourceRelativePath = variables.parameters.source_folder & folderPath & baseName & ".cfc";
            var testRelativePath = variables.parameters.test_folder & folderPath & baseName & "Test.cfc";

            // Extract base directory from the absolute fileName
            // fileName is already absolute (Module.cfc converted it using cwd)
            // We need to remove the relative path portion to get the base directory
            var baseDir = "";

            // Check if current file is a source file
            if (right(fullPath, len(sourceRelativePath)) == sourceRelativePath) {
                baseDir = left(fullPath, len(fullPath) - len(sourceRelativePath));
            }
            // Check if current file is a test file
            else if (right(fullPath, len(testRelativePath)) == testRelativePath) {
                baseDir = left(fullPath, len(fullPath) - len(testRelativePath));
            }

            // Use Java File to construct absolute paths
            var fileObj = createObject("java", "java.io.File");
            var fullSourcePath = fileObj.init(baseDir & sourceRelativePath).getAbsolutePath();
            var fullTestPath = fileObj.init(baseDir & testRelativePath).getAbsolutePath();

            // Check if files exist
            var sourceExists = fileExists(fullSourcePath);
            var testExists = fileExists(fullTestPath);

            // Debug output
            /*dump(var={
                "currentFile": fileName,
                "folderPath": folderPath,
                "baseName": baseName,
                "sourcePath": sourcePath,
                "testPath": testPath,
                "fullSourcePath": fullSourcePath,
                "fullTestPath": fullTestPath,
                "sourceExists": sourceExists,
                "testExists": testExists,
                "baseTemplatePath": GetBaseTemplatePath()
            }, label="File Comparison");*/

            // Build detailed message based on what exists
            var message = "";
            var severity = "INFO";

            if (sourceExists && !testExists) {
                message = "Source file exists but missing test file. Expected: #testRelativePath#";
                severity = "WARNING";
            } else if (!sourceExists && testExists) {
                message = "Test file exists but missing source file. Expected: #sourceRelativePath#";
                severity = "WARNING";
            } else if (!sourceExists && !testExists) {
                message = "Neither source nor test file found at expected locations #sourceRelativePath# <-> #testRelativePath#";
                severity = "ERROR";
            }

            arrayAppend(results, createLintResult(
                lintRule = this,
                node = node,
                fileName = fileName,
                fileContent = fileContent,
                message = message,
                severity = severity
            ));
        }

        return results;
    }

    
}
