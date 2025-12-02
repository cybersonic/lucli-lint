component accessors="true"{
    property name="RuleConfig";
    /**
     * CFML Parser and Linter Module
     * 
     * This is the main entry point for the CFML linting module.
     * It uses Lucee's built-in AST parser and applies configurable linting rules.
     */
    
    function init(
        verboseEnabled=false,
        timingEnabled=false,
        cwd="",
        timer,
        
    ) {
        variables.verboseEnabled = arguments.verboseEnabled;
        variables.timingEnabled = arguments.timingEnabled;
        variables.cwd = arguments.cwd;
        variables.timer = arguments.timer ?: {
            _start = function(name){
                if(variables.timingEnabled){
                    out("Timer start: " & name);
                }
            },
            _stop = function(name){
                if(variables.timingEnabled){
                    out("Timer stop: " & name);
                }
            },
            start = function(name){
                if(variables.timingEnabled){
                    out("Timer start: " & name);
                }
            },
            stop = function(name){
                if(variables.timingEnabled){
                    out("Timer stop: " & name);
                }
            }
        };
        
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
     * @compact boolean whether to compact the JSON output (default: true)
     * @reportPath path to save the report file (optional)
     * @configStruct struct with configuration options (optional)
     * @return struct with linting results
     */
    function main(
        string file="",
        string folder="",
        string format = "text",
        string rules = "",
        string config = "",
        boolean compact = true,
        string reportPath = "",
        struct configStruct = {},
        boolean silent=false
        ) {

        if(variables.verboseEnabled){
            out("CFML Linter Module initialized.");
            out("file = " & file);
            out("folder = " & folder);
            out("format = " & format);
            out("rules = " & rules);
            out("cwd = " & variables.cwd);
            out("config = " & arguments.config);
        }
        
        // out( variables );
       
        variables.Timer.start("CFML Linting Process");

        // File or Folder is required
        if(!len(file) && !len(folder)){
            out("No file or folder specified. Showing help:");
            return showHelp();
        }

          variables.Timer.stop("CFML Linting Process");
        //Create the rule configuration (with all the rules)
        // .cflint.json
        // cfmllint.rc
        // if we find a CFLint we might be able to use that too 
        var configPath = Len(arguments.config) ? arguments.config : variables.cwd & "/.lucli-lint.json";

       
        
        variables.timer.start("Load Rule Configuration");
        var RuleConfig = nullValue();
        RuleConfig = createObject("component", "lib.RuleConfiguration").init(configPath=configPath, configStruct=configStruct);
    
       
        variables.RuleConfig = RuleConfig;
        // Add the timer for debugging
        RuleConfig.setTimer( variables.Timer );
        variables.timer.stop("Load Rule Configuration");

        // If specific rules are provided, enable only those
        if(len(arguments.rules)){
            var ruleList = ListToArray(arguments.rules);
            RuleConfig.enableOnlyRules(ruleList);
        }

        // Create linter 
        var linter = createObject("component", "lib.CFMLLinter").init(RuleConfig);        
            linter.setCWD( variables.cwd ); //Pass the working dir
            linter.setTimer( variables.Timer ); //Pass the timer for debugging
        

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
            // Should return something else, including how manyu files we did.
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
            // dump(var=folderResults.results, label="Folder results");
            ArrayAppend(results, folderResults.results, true);
        }
        // dump(results);
            
        // Output results
        var outputFormat = arguments.format;
        if(outputFormat == "text" && !Len(reportPath)){
            if(!isEmpty(arguments.file)){
                out("Linting file: " & arguments.file);
            } else if(!isEmpty(arguments.folder)){
                out("Linting folder: " & arguments.folder);
            }

            outline("Rules loaded: #RuleConfig.getEnabledRules().KeyList()#");
            
            out("");
            if(variables.verboseEnabled){
                
                outline("Rule Access Counts:");
                var ruleAccessCount = linter.getRuleAccessCount();
                
                for(var rule in ruleAccessCount){
                    out("   #rule# checked : #ruleAccessCount[rule]# times");
                }
                out("");
            }
        }
        
        var formattedResults = linter.formatResults(results, outputFormat, compact);
        
        if(Len(arguments.reportPath)){
            // If we are not absolute, make it relative to cwd
            var reportFilePath = fileObj.init(arguments.reportPath);
            if(!reportFilePath.isAbsolute()) {
                arguments.reportPath = fileObj.init(variables.cwd, arguments.reportPath).getCanonicalPath();
            } else {
                arguments.reportPath = reportFilePath.getAbsolutePath();
            }
            // Save to file
            fileWrite(arguments.reportPath, formattedResults);
            out("Report written to: " & arguments.reportPath);
        } else if(!silent){
            out(formattedResults);
        }
        
        return formattedResults;
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
            // out("Available CFML Linter Rules:");
            outline("Available CFML Linter Rules:");
            // This should come from the RulesConfiguration
            
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
        out("Usage: lucli lint [options]");
        out("Options:");
        out("  file=<file>      Path to the file to lint");
        out("  folder=<folder>  Path to the folder to lint");
        out("  format=text|json|xml|bitbucket  Output format (default: text)");
        out("  rules=<rules>      Only run specified rules (comma-separated)");
        return "Help information displayed";
    }

    function verbose(any message){
        if(variables.verboseEnabled){
            out(message);
        }
    }

    function outline(string message, boolean bShowBorder=false){
        var lineLength = message.len();
        if(bShowBorder){
            lineLength += 4;
        } 
        var border = repeatString("=", lineLength);
        if(bShowBorder){
            out(border);
            out("| " & message & " |");
        }
        else{
            out(message);
        }
        out(border);
    }
    
}
