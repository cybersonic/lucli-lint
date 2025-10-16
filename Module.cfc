component {
    /**
     * CFML Parser and Linter Module
     * 
     * This is the main entry point for the CFML linting module.
     * It uses Lucee's built-in AST parser and applies configurable linting rules.
     */
    function init() {
        // Module initialization code goes here
        return this;
    }
    
    function main(args) {
        try {
            // out("Debug: Starting main function");
            dump(args);
            // Check if we have at least one argument (file path)
            if (arrayLen(args) < 1) {
                show(Help());
                return "Usage information displayed";
            }
            
            // out("Debug: Parsing arguments");
            var filePath = args[1];
            var options = parseCommandLineOptions(args);

            
            dump(options);
            
            // out("Debug: Checking for rules-only option");
            
            // Show rules only if requested
            if (structKeyExists(options, "rules-only")) {
                // out("Debug: Calling showAvailableRules");
                return showAvailableRules();
            }
            
            // out("Debug: Loading configuration");
            
            // Load configuration  
            var configPath = "";
            if (structKeyExists(options, "config")) {
                configPath = options.config;
                // out("Debug: Using provided config: " & configPath);
            } else {
                var currentPath = getCurrentTemplatePath();
                // out("Debug: Current template path: " & currentPath);
                var dirPath = getDirectoryFromPath(currentPath);
                // out("Debug: Directory path: " & dirPath);
                configPath = dirPath & "cflinter.json";
                // out("Debug: Default config path: " & configPath);
            }
            
            var config = nullValue();
            
            
            if (fileExists(configPath)) {
                config = createObject("component", "lib.RuleConfiguration").init(configPath);
                // out("Using configuration: " & configPath);
            } else {
                config = createObject("component", "lib.RuleConfiguration").init();
                // out("Using default configuration (no config file found)");
            }
            
            
            // Create linter instance
            var linter = createObject("component", "lib.CFMLLinter").init(config);
            
            
            // Add our custom rules manually since the auto-discovery might not work yet
            linter.addRule(createObject("component", "lib.rules.AvoidUsingCFDumpTagRule").init());
            linter.addRule(createObject("component", "lib.rules.AvoidUsingCFAbortTagRule").init());
            linter.addRule(createObject("component", "lib.rules.VariableNameChecker").init());
            linter.addRule(createObject("component", "lib.rules.MissingVarRule").init());
            linter.addRule(createObject("component", "lib.rules.QueryParamRule").init());
            linter.addRule(createObject("component", "lib.rules.ExcessiveFunctionLengthRule").init());
            linter.addRule(createObject("component", "lib.rules.FunctionHintMissingRule").init());
            linter.addRule(createObject("component", "lib.rules.GlobalVarRule").init());
            linter.addRule(createObject("component", "lib.rules.AvoidUsingCreateObjectRule").init());
            linter.addRule(createObject("component", "lib.rules.QueryParamRule").init());
            
            
            // Lint the file
            var results = linter.lintFile(filePath);
            
            // Output results
            var outputFormat = structKeyExists(options, "format") ? options.format : "text";
            if(outputFormat == "text"){
                out("Linting file: " & filePath);
                out("Rules loaded: " & arrayLen(linter.getEnabledRules()));
                out("");
            }
            var formattedResults = linter.formatResults(results, outputFormat);
            
            out(formattedResults);
            
            return "Linting completed with " & arrayLen(results) & " issues found";
            
        } catch (any e) {
            out("Error: " & e.message);
            // dump(e);
            if (structKeyExists(e, "detail") && len(e.detail)) {
                out("Details: " & e.detail);
            }
            return "Linting failed";
        }
    }

    function out(any message){
        if(!isSimpleValue(message)){
            message = serializeJson(var=message, compact=false);
        }
        writeOutput(message & chr(10));
    }
    
    /**
     * Parse command line options from arguments array
     */
    function parseCommandLineOptions(required array args) {
        var options = {};
        
        // out("Debug: parseCommandLineOptions - args length: " & arrayLen(arguments.args));
        
        for (var i = 2; i <= arrayLen(arguments.args); i++) {
            var arg = arguments.args[i];
            // out("Debug: Processing arg " & i & ": " & arg);
            
            if (left(arg, 2) == "--") {
                var option = mid(arg, 3, len(arg));
                // out("Debug: Parsed option: " & option);
                
                if (find("=", option)) {
                    var parts = listToArray(option, "=");
                    if (arrayLen(parts) >= 2) {
                        options[parts[1]] = parts[2];
                        // out("Debug: Set option " & parts[1] & " = " & parts[2]);
                    }
                } else {
                    options[option] = true;
                    // out("Debug: Set flag option " & option & " = true");
                }
            }
        }
        
        // out("Debug: Parsed options: " & serializeJSON(options));
        return options;
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
        out("Usage: lucli cfml_parser/Module.cfc <file_path> [options]");
        out("Options:");
        out("  --format=text|json|xml  Output format (default: text)");
        out("  --config=<path>         Configuration file path");
        out("  --rules-only            Show available rules only");
        out("  --rules=<rules>      Only run specified rules (comma-separated)");
        return "Help information displayed";
    }
    
}
