component {
    /**
     * CFML Parser and Linter Module
     * 
     * This is the main entry point for the CFML linting module.
     * It uses Lucee's built-in AST parser and applies configurable linting rules.
     */
    function init(
        verbose=false,
        timing=false,
        cwd=""
    ) {
        variables.verbose = arguments.verbose;
        variables.timing = arguments.timing;
        variables.cwd = arguments.cwd;
        // TOOD
        // verbose(serializeJSON(arguments))
        // timing.start(serializeJSON(arguments))
        // timing.end(serializeJSON(arguments))
        
        return this;
    }

    /**
     * main entry point
     *
     * @file path to the file to lint
     * @folder path to the folder to lint (optional)
     * @format format of the output (text, json, xml, silent (for tests))
     * @rules comma-separated list of rules to apply, if left empty, it will look for rules in config file or use all enabled rules
     * @config path to config file, if not provided, it will look for cflinter.json in the current directory of the file or folder
     * @return struct with linting results
     */
    function main(
        string file="",
        string folder="",
        string format = "json",
        string rules = "",
        string config = ""
        ) {

        if(variables.verbose){
            out("CFML Linter Module initialized.");
            out("file = " & file);
            out("folder = " & folder);
            out("format = " & format);
            out("rules = " & rules);
            out("cwd = " & variables.cwd);
            out("config = " & arguments.config);
        }
        

        // File or Folder is required
        if(!len(file) && !len(folder)){
            out("No file or folder specified. Showing help:");
            return showHelp();
        }

        //Create the rule configuration (with all the rules)
        var configPath = Len(arguments.config) ? arguments.config : getDirectoryFromPath(variables.cwd) & "cflinter.json";
        
        var RuleConfig = nullValue();
        if (fileExists(configPath)) {
            RuleConfig = createObject("component", "lib.RuleConfiguration").init(configPath);
        } else {
            RuleConfig = createObject("component", "lib.RuleConfiguration").init();
        }
               

        // If specific rules are provided, enable only those
        if(len(arguments.rules)){
            var ruleList = ListToArray(arguments.rules);
            RuleConfig.enableOnlyRules(ruleList);
        }

        // Create linter 
        var linter = createObject("component", "lib.CFMLLinter").init(RuleConfig);        
            
        

        // Check if the folder or file path is relative , or absolute

        // Use Java File class for cross-platform path handling
        var fileObj = createObject("java", "java.io.File");

        // Linting Results
        var results = [];

        // Check the file path. 
        if(!isEmpty(arguments.file)) {
            var filePath = fileObj.init(arguments.file);
            if(!filePath.isAbsolute()) {
                arguments.file = fileObj.init(variables.cwd, arguments.file).getCanonicalPath();
            } else {
                arguments.file = filePath.getAbsolutePath();
            }

            var fileResults = linter.lintFile(arguments.file);
            results.append(fileResults, true);
        }

        
        // Check the folder path.
        if(!isEmpty(arguments.folder)) {
            var folderPath = fileObj.init(arguments.folder);
            if(!folderPath.isAbsolute()) {
                arguments.folder = fileObj.init(variables.cwd, arguments.folder).getCanonicalPath();
            } else {
                arguments.folder = folderPath.getAbsolutePath();
            }

            var folderResults = linter.lintFolder(arguments.folder);
            results.append(folderResults, true);
        }
    
            
            // Output results
            var outputFormat = arguments.format;
            if(outputFormat == "text"){
                if(!isEmpty(arguments.file)){
                    out("Linting file: " & arguments.file);
                } else if(!isEmpty(arguments.folder)){
                    out("Linting folder: " & arguments.folder);
                }
                out("Rules loaded: " & arrayLen(linter.getEnabledRules()));
                out("");
            }
            
            var formattedResults = linter.formatResults(results, outputFormat);
            
            out(formattedResults);
            
            return results;
            
        // } catch (any e) {
        //     dump(e);
        //     out("Error: " & e.message);
        //     // dump(e);
        //     if (structKeyExists(e, "detail") && len(e.detail)) {
        //         out("Details: " & e.detail);
        //     }
        //     return "Linting failed";
        // }
    }

    function out(any message){
        if(!isSimpleValue(message)){
            message = serializeJson(var=message, compact=false);
        }
        writeOutput(message & chr(10));
    }
    
    /**
     * Show available rules and their descriptions
     */
    function showAvailableRules() {
        try {
            out("Available CFML Linter Rules:");
            out("==============================");
            
            // Create rules directly
            var rules = [
                createObject("component", "lib.rules.AvoidUsingCFDumpTagRule").init(),
                createObject("component", "lib.rules.AvoidUsingCFAbortTagRule").init(),
                createObject("component", "lib.rules.VariableNameChecker").init(),
                createObject("component", "lib.rules.MissingVarRule").init(),
                createObject("component", "lib.rules.QueryParamRule").init(),
                createObject("component", "lib.rules.ExcessiveFunctionLengthRule").init(),
                createObject("component", "lib.rules.FunctionHintMissingRule").init(),
                createObject("component", "lib.rules.GlobalVarRule").init(),
                createObject("component", "lib.rules.AvoidUsingCreateObjectRule").init()
            ];
            
            for (var rule in rules) {
                var ruleInfo = rule.getRuleInfo();
                out("[" & ruleInfo.ruleCode & "] " & ruleInfo.ruleName);
                out("  Description: " & ruleInfo.description);
                out("  Severity: " & ruleInfo.severity);
                out("  Group: " & ruleInfo.group);
                out("  Enabled: " & ruleInfo.enabled);
                out("");
            }
            
            return "Rules information displayed";
        } catch (any e) {
            out("Error in showAvailableRules: " & e.message);
            if (structKeyExists(e, "detail")) {
                out("Detail: " & e.detail);
            }
            return "Failed to show rules";
        }
    }


    function showHelp() {
        
        out("CFML Linter Module Help:");
        out("=========================");
        out("Usage: lucli cfml_parser/Module.cfc file=<file_path> [options]");
        out("Options:");
        out("  format=text|json|xml  Output format (default: text)");
        out("  rules=<rules>      Only run specified rules (comma-separated)");
        return "Help information displayed";
    }
    
}
