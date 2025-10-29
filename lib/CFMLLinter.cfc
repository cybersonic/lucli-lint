/**
 * CFMLLinter Component
 * 
 * Main linting engine that orchestrates AST parsing and rule execution
 */
component accessors="true" {
    
    property name="rules" type="array";
    property name="ruleConfiguration" type="any";
    property name="astHelper" type="any";
    property name="cwd" type="string" default="";
    variables.filenameUtils = createObject("java", "org.apache.commons.io.FilenameUtils");



    function init(any ruleConfiguration) {
        variables.rules = [];
        
        if (structKeyExists(arguments, "ruleConfiguration") && !isNull(arguments.ruleConfiguration)) {
            variables.ruleConfiguration = arguments.ruleConfiguration;
        } else {
            variables.ruleConfiguration = createObject("component", "RuleConfiguration").init();
        }
        
    
        return this;
    }
    
    /**
     * Lint a CFML file by file path
     * @param filePath Path to the CFML file to lint
     * @return Array of LintResult objects
     */
    public array function lintFile(required string filePath) {

      
        if (!fileExists(arguments.filePath)) {
            // Try to expand it
            if(!fileExists(expandPath(arguments.filePath))) {
                throw(type="FileNotFound", message="File not found: " & arguments.filePath);
            } else {
                arguments.filePath = expandPath(arguments.filePath);
            }
            // throw(type="FileNotFound", message="File not found: " & arguments.filePath);
        }

        try{
            var ast = astFromPath(arguments.filePath);
            var lintResults = lintAST(ast, arguments.filePath);
            return lintResults;
        }
        catch(e){
            dump(e);
            abort;
            var ErrorLintResult = createObject("component", "LintResult").init(
                    rule: {
                        getRuleCode: function(){ return "AST_PARSE_ERROR"; },
                        getRuleName: function(){ return "AST Parser"; },
                        getDescription: function(){ return "Error parsing AST"; },
                        getSeverity: function(){ return "FAILURE"; },
                        getMessage: function(){ return "Error parsing AST: " & e.message; }
                    },
                    node: {
                        start: { line: 0, column: 0, offset: 0 },
                        end: { line: 0, column: 0, offset: 0 }
                    },
                    fileName: arguments.filePath,
                    fileContent: ""
                );
            
            var TagContext = e.TagContext ?: [];
            if(ArrayLen(TagContext)){
                ErrorLintResult.setLine(TagContext[1].line?:0);
                ErrorLintResult.setCode(TagContext[1].codePrintPlain?:"");
                ErrorLintResult.setColumn(TagContext[1].column ?: 0);
                ErrorLintResult.setStackTrace(e.stackTrace ?: "");
            }
            return [
                ErrorLintResult
            ];
        }
        // Parse the file using Lucee's AST parser
    }
    /**
     * Lint all CFML files in a folder (recursively)
     * @param folderPath Path to the folder to lint
     * @return Array of LintResult objects
     */
    public struct function lintFolder(required string folderPath) {
        var results = [];
        var errors = [];
        var filesScanned = []
        if (!directoryExists(arguments.folderPath)) {
            throw(type="DirectoryNotFound", message="Directory not found: " & arguments.folderPath);
        }
        // Recursively get all .cfm and .cfc files in the folder
        var files = directoryList(
                                path:arguments.folderPath,
                                recurse: true,
                                listInfo: "array",
                                filter=pathFilter,
                                type="file",
                                sort: "asc"
                                );
        for (var row in files) {
            var fileResults = lintFile(row);
            // dump(var=fileResults, label="File results for #row#");
            results.append(fileResults, true);
        }

        // dump(var=results, label="Final results");
        return {
            results: results,
            filesScanned: files,
            errors: errors
        };
    }




    // This is used by directoryList to filter paths
    private function pathFilter(path,type,ext){

        if(!arrayContains(["cfm","cfc","cfs"],arguments.ext)){
            return false;
        }
        var ignorePatterns = getruleConfiguration().getIgnoreFiles();
        
        for(var ignoredPattern in ignorePatterns){
            if(variables.filenameUtils.wildcardMatch(path, ignoredPattern)){
                return false;
            }
        }
        return true;
    }
    /**
     * Lint an already parsed AST
     * @param ast The parsed AST structure
     * @param fileName File name for reporting
     * @return Array of LintResult objects  
     */
    array function lintAST(required struct ast, string fileName = "") {
        var results = [];
        
        // Create AST helper
        variables.astHelper = new ASTDomHelper(arguments.ast);
        
        var rules = variables.ruleConfiguration.getEnabledRules();
        var fileContent = FileRead(fileName);

        var recursiveResults = recursiveNodeParser(
                node: arguments.ast,
                document: arguments.ast,
                fileName: arguments.fileName,
                fileContent: fileContent,
                helper: variables.astHelper,
                allrules: rules
                );

        return recursiveResults;
    }
    


    array function recursiveNodeParser(
            required struct node, 
            required struct document, 
            string fileName="",
            string fileContent="",
            required any helper,
            struct allrules = {}
            )
    {
        var results = []

        
        for(var rule in arguments.allrules){
            var ruleResults = arguments.allrules[rule].check(
                node: arguments.node,
                helper: variables.astHelper,
                filename: arguments.fileName,
                fileContent: fileContent
                );
            results.append(ruleResults, true);
        }

        if(!StructKeyExists(node, "body")){
            return results;
        }
        if(isArray(node.body)){
            for(var childNode in node.body){
                var child_results = recursiveNodeParser(
                    node: childNode,    
                    document: arguments.document,
                    fileName: arguments.fileName,
                    fileContent: fileContent,
                    helper: arguments.helper,
                    allrules: arguments.allrules
                    );
                results.append(child_results, true);
            }
            
        }
        elseif(isStruct(node.body) && node.body.keyExists("body") && isArray(node.body.body)){ 

                for(var childNode in node.body.body){
                    var child_results = recursiveNodeParser(
                        node: childNode,
                        document: arguments.document,
                        fileName: arguments.fileName,
                        fileContent: fileContent,
                        helper: arguments.helper,
                        allrules: arguments.allrules
                        );
                    results.append(child_results, true);
            }
        }
        else {
            throw("Unknown node body type: " & getMetaData(node.body).name);
        }
        return results;

    }
    /**
     * Add a rule to the linter
     * @param rule The rule instance to add
     */
    function addRule(required any rule) {
        arrayAppend(variables.rules, arguments.rule);
        return this;
    }
    
  
    /**
     * Get a rule by code
     * @param ruleCode The rule code to find
     * @return The rule instance or null if not found
     */
    function getRule(required string ruleCode) {
        for (var rule in variables.rules) {
            if (rule.getRuleInfo().ruleCode == arguments.ruleCode) {
                return rule;
            }
        }
        return nullValue();
    }
    
    /**
     * Enable or disable a rule
     * @param ruleCode The rule code
     * @param enabled Whether the rule should be enabled
     */
    function setRuleEnabled(required string ruleCode, required boolean enabled) {
        var rule = getRule(arguments.ruleCode);
        if (!IsNull(rule)) {
            rule.setEnabled(arguments.enabled);
        }
        return this;
    }
    
    /**
     * Get all rules
     * @return Array of rule instances
     */
    function getRules() {
        return variables.rules;
    }
    
    /**
     * Get enabled rules only
     * @return Array of enabled rule instances
     */
    function getEnabledRules() {
        var enabledRules = [];
        for (var rule in variables.rules) {
            if (rule.isEnabled()) {
                arrayAppend(enabledRules, rule);
            }
        }
        return enabledRules;
    }
    
    /**
     * Get rules by group
     * @param group The rule group (e.g., "Security", "BugProne")
     * @return Array of rules in the specified group
     */
    function getRulesByGroup(required string group) {
        var groupRules = [];
        for (var rule in variables.rules) {
            var ruleInfo = rule.getRuleInfo();
            if (ruleInfo.group == arguments.group) {
                arrayAppend(groupRules, rule);
            }
        }
        return groupRules;
    }
    
    
    /**
     * Sort results by severity (highest first) and then by line number
     * @param results Array of LintResult objects
     * @return Sorted array of LintResult objects
     */
    function sortResults(required array results) {

        
        arraySort(arguments.results, function(a, b) {
            // First sort by severity (ERROR > WARNING > INFO)
            var severityA = a.getSeverityLevel();
            var severityB = b.getSeverityLevel();
            
            if (severityA != severityB) {
                return severityB - severityA; // Descending order
            }
            
            // Then sort by line number
            if (a.getLine() != b.getLine()) {
                return a.getLine() - b.getLine(); // Ascending order
            }
            
            // Finally by column
            return a.getColumn() - b.getColumn(); // Ascending order
        });
        
        return arguments.results;
    }
    
    /**
     * Generate summary report of linting results
     * @param results Array of LintResult objects
     * @return Struct with summary information
     */
    function generateSummary(required array results) {
        var summary = {
            "total": arrayLen(arguments.results),
            "errors": 0,
            "warnings": 0,
            "info": 0,
            "failure": 0,
            "ruleBreakdown": {}
        };
        
        for (var result in arguments.results) {
            // Count by severity
            switch(result.getSeverity()) {
                case "ERROR":
                    summary.errors++;
                    break;
                case "WARNING":
                    summary.warnings++;
                    break;
                case "INFO":
                    summary.info++;
                    break;
                case "FAILURE":
                    summary.failure++;
                    break;
            }
            
            // Count by rule
            if (!structKeyExists(summary.ruleBreakdown, result.getRuleCode())) {
                summary.ruleBreakdown[result.getRuleCode()] = 0;
            }
            summary.ruleBreakdown[result.getRuleCode()]++;
        }
        
        return summary;
    }
    
    /**
     * Format results for display
     * @param results Array of LintResult objects
     * @param format Output format ("text", "json", "xml")
     * @return Formatted string
     */
    function formatResults(required array results, string format = "text", boolean compact = true) {
        switch(arguments.format) {
            case "json":
                return formatResultsAsJSON(arguments.results, arguments.compact );
            case "xml":
                return formatResultsAsXML(arguments.results);
            case "bitbucket":
                // Placeholder for Bitbucket format
                return formatResultsAsBitbucket(arguments.results);
            case "silent":
                return ""; // No output
            default:
                return formatResultsAsText(arguments.results);
        }
    }
    
    /**
     * Format results as plain text
     */
    function formatResultsAsText(required array results) {
        var output = [];
        var summary = generateSummary(arguments.results);
        
        arrayAppend(output, "CFML Linter Results");
        arrayAppend(output, "====================");
        arrayAppend(output, "Total issues: " & summary.total);
        arrayAppend(output, "Errors:  #summary.errors# , Warnings:  #summary.warnings# , Info:  #summary.info#, Failures:  #summary.failure#");
        arrayAppend(output, "");
        
        for (var result in arguments.results) {
            var line = result.getSeverity() & " - " & result.getFileName();
            if (result.getLine() > 0) {
                line &= " (line " & result.getLine();
                if (result.getColumn() > 0) {
                    line &= ", col " & result.getColumn();
                }
                line &= ")";
            }
            line &= ": [" & result.getRuleCode() & "] " & result.getFormattedMessage();
            arrayAppend(output, line);
        }
        
        return arrayToList(output, chr(10));
    }
    
    /**
     * Format results as JSON
     */
    function formatResultsAsJSON(required array results, boolean compact = true) {
        var jsonResults = [];
        for (var result in arguments.results) {
            arrayAppend(jsonResults, result.toStruct());
        }
        
        return serializeJSON(var:{
            "summary": generateSummary(arguments.results),
            "results": jsonResults
        },
        compact: arguments.compact);
        // TODO: make sure we can choose whetere the options has compact or not
    }
    
    /**
     * Format results as XML
     */
    function formatResultsAsXML(required array results) {
        // Basic XML formatting - could be enhanced
        var xml = [];
        arrayAppend(xml, '<?xml version="1.0" encoding="UTF-8"?>');
        arrayAppend(xml, "<lintResults>");
        
        var summary = generateSummary(arguments.results);
        arrayAppend(xml, "  <summary>");
        arrayAppend(xml, "    <total>" & summary.total & "</total>");
        arrayAppend(xml, "    <errors>" & summary.errors & "</errors>");
        arrayAppend(xml, "    <warnings>" & summary.warnings & "</warnings>");
        arrayAppend(xml, "    <info>" & summary.info & "</info>");
        arrayAppend(xml, "    <failure>" & summary.failure & "</failure>");
        arrayAppend(xml, "  </summary>");
        
        arrayAppend(xml, "  <issues>");
        for (var result in arguments.results) {
            arrayAppend(xml, "    <issue>");
            arrayAppend(xml, "      <ruleCode>" & xmlFormat(result.ruleCode) & "</ruleCode>");
            arrayAppend(xml, "      <severity>" & xmlFormat(result.severity) & "</severity>");
            arrayAppend(xml, "      <message>" & xmlFormat(result.getFormattedMessage()) & "</message>");
            arrayAppend(xml, "      <fileName>" & xmlFormat(result.fileName) & "</fileName>");
            arrayAppend(xml, "      <line>" & result.line & "</line>");
            arrayAppend(xml, "      <column>" & result.column & "</column>");
            arrayAppend(xml, "    </issue>");
        }
        arrayAppend(xml, "  </issues>");
        arrayAppend(xml, "</lintResults>");
        
        return arrayToList(xml, chr(10));
    }

    /**
     * Format results as Bitbucket Report
     */
    function formatResultsAsBitbucket(required array results) {
        // Bitbucket Code Insights format
        var bitbucketReport = {
            "title": "CFML Linter Report",
            "details": "Static analysis results for CFML code",
            "result": "PASS", // Will be set to FAIL if there are errors
            "data": []
        };
        
        var summary = generateSummary(arguments.results);
        
        // Set result based on error count
        if (summary.errors > 0) {
            bitbucketReport.result = "FAIL";
        }
        
        // Convert lint results to Bitbucket annotations format
        for (var result in arguments.results) {
            var annotation = {
            "path": result.getFileName(),
            "line": result.getLine(),
            "message": "[" & result.getRuleCode() & "] " & result.getFormattedMessage(),
            "severity": lcase(result.getSeverity()), // Bitbucket uses lowercase
            "type": "CODE_SMELL" // Default type, could be BUG for errors
            };
            
            // Map severity to Bitbucket types
            if (result.getSeverity() == "ERROR") {
            annotation.type = "BUG";
            annotation.severity = "high";
            } else if (result.getSeverity() == "WARNING") {
            annotation.type = "CODE_SMELL";
            annotation.severity = "medium";
            } else {
            annotation.type = "CODE_SMELL";
            annotation.severity = "low";
            }
            
            arrayAppend(bitbucketReport.data, annotation);
        }
        
        return serializeJSON(bitbucketReport);
    }
}
