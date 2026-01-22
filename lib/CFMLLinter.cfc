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
    property name="timer" type="any" default="#{}#";
    property name="ruleAccessCount" type="struct" default="#{}#";

    //Helper libs    
    variables.filenameUtils = createObject("java", "org.apache.commons.io.FilenameUtils");
    variables.fileSystems = createObject("java", "java.nio.file.FileSystems").getDefault();
    variables.paths = createObject("java", "java.nio.file.Paths");
    // variables.cwdPath = variables.paths.get(variables.cwd, []);


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
            if(variables.ruleConfiguration.getGlobalSetting("ignoreParseErrors", false)){
                return [];
            }
            var ErrorLintResult = createObject("component", "LintResult").init(
                    rule: {
                        getRuleCode: function(){ return "ERROR"; },
                        getRuleName: function(){ return "General Error"; },
                        getDescription: function(){ return e.message; },
                        getSeverity: function(){ return "FAILURE"; },
                        getMessage: function(){ return  e.message; }
                    },
                    node: {
                        start: { line: 0, column: 0, offset: 0 },
                        end: { line: 0, column: 0, offset: 0 }
                    },
                    fileName: arguments.filePath,
                    fileContent: "",
                    severity: "FAILURE"
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

        // if we have an includes array, use that to build the search paths      
        var includePaths = variables.ruleConfiguration.getIncludes();

        var searchPaths = includePaths.map(
            function(includePath){
                return variables.paths.get(variables.cwd, [includePath]).toString();
            }
        );
      
        // If no includes, just use the folderPath
        if(isEmpty(searchPaths)){
            searchPaths = [arguments.folderPath];
        }

        var files = [];
        var skippedFiles = [];
        for(var searchPath in searchPaths){
            var searchFiles = directoryList(
                                    path:searchPath,
                                    recurse: true,
                                    listInfo: "array",
                                    filter=pathFilter,
                                    type="file",
                                    sort: "asc"
                                    );
            files.append(searchFiles, true);
        }
        // We should also filter the files based on excludes, rather than in pathFilter, so that we can report on files skipped?
    
        for (var row in files) {
            var fileResults = lintFile(row);    
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
        var ignorePatterns = getRuleConfiguration().getIgnoreFiles();
        var isIgnored = false;

        for(var ignoredPattern in ignorePatterns){
            var pathMatcher = variables.fileSystems.getPathMatcher("glob:" & ignoredPattern)
            var thePath = variables.paths.get(arguments.path, []);

            if(pathMatcher.matches(thePath)){
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

        var logTimeUnits = variables.ruleConfiguration.getGlobalSetting("logTimeUnits", "ms");

        var start = getTickCount(logTimeUnits);

        logEvent(
            file: fileName,
            event: "Start Linting",
            duration: "0",
            unit: logTimeUnits
            );

        var recursiveResults = recursiveNodeParser(
                node: arguments.ast,
                document: arguments.ast,
                fileName: arguments.fileName,
                fileContent: fileContent,
                helper: variables.astHelper,
                allrules: rules
                );
        
        var end = getTickCount(logTimeUnits) - start;

        logEvent(
            file: fileName,
            event: "End Linting",
            duration: end,
            unit: logTimeUnits
            );
        

        return recursiveResults;
    }
    

    function logEvent(String file, String event, String duration, String unit){
        if(variables.ruleConfiguration.hasLogFile()){  
            fileAppend( variables.ruleConfiguration.getLogFile(), "#getTickCount()#,#file#, #event#, #duration# #unit# #Chr(10)#");
        }
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
        node.type = node.type ?: "";
        for(var rule in arguments.allrules){
            var ruleItem = "Rule: #rule#"; 
            var ruleObj = arguments.allrules[rule];
            var nodeTypes = [];

            
            if( len(ruleObj.getNodeType()) ){
                nodeTypes = listToArray(ruleObj.getNodeType());
            }
            // If we have the nodeTypeS (plural) we check against that
            if( len(ruleObj.getNodeTypes()) ){
                nodeTypes = listToArray(ruleObj.getNodeTypes());
            }
        
            if(Len(nodeTypes) AND not arrayContainsNoCase(nodeTypes, node.type)){
                // skip this rule as it does not apply to this node type
                continue;
            }
            
            if(not StructKeyExists(variables.ruleAccessCount, rule)){
                variables.ruleAccessCount[rule] = 0;
            }
            variables.ruleAccessCount[rule]++;

            var logTimeUnits = variables.ruleConfiguration.getGlobalSetting("logTimeUnits", "milli");
            var start = getTickCount(logTimeUnits);
            var ruleResults = arguments.allrules[rule].check(
                node: arguments.node,
                helper: variables.astHelper,
                filename: arguments.fileName,
                fileContent: fileContent
                );
            var end = getTickCount(logTimeUnits) - start;
            
            logEvent(
                file: fileName,
                event: rule,
                duration: end,
                unit: logTimeUnits
                );



            // variables.timer.stop(ruleItem);
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
                return formatResultsAsBitbucket(arguments.results, arguments.compact);
            case "raw":
                return arguments.results;
            case "tsc":
                return formatResultsAsTSC(arguments.results);
            case "report":
                return formatResultsAsReport(arguments.results);
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
            var line = result.getSeverity() & " - " & result.getFileName() & ":#result.getLine()#:#result.getColumn()#";
            if (result.getLine() > 0) {
                line &= " (line " & result.getLine();
                if (result.getColumn() > 0) {
                    line &= ", col " & result.getColumn();
                }
                line &= ")";
            }
            line &= ": [" & result.getRuleCode() & "] " & result.getFormattedMessage();
            // line &= result.getCode();
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
     * Returns the result in gcc format so that vscode can use them directly.
     *
     * @results 
     */
    function formatResultsAsTSC(required array results) {
        var output = [];

        // src/test.cfs(10,5): error: Variable 'foo' is not defined
        for (var result in arguments.results) {
            // var line = result.getFileName() & "(" & result.getLine() & "," & result.getColumn() & "): " & lcase(result.getSeverity()) & ": [" & result.getRuleCode() & "] " & result.getFormattedMessage();
            var line = "#result.getFileName()#(#result.getLine()#,#result.getColumn()#,#result.getEndLine()#,#result.getEndColumn()#): #lcase(result.getSeverity())#: [ #result.getRuleCode()# ]  #result.getFormattedMessage()#";
            arrayAppend(output, line);
        }
        return arrayToList(output, chr(10));
    }


    function formatResultsAsReport(required array results) {
        var output = [];
        var summary = generateSummary(arguments.results);
        
        arrayAppend(output, "CFML Linter Report");
        arrayAppend(output, "=================");
        arrayAppend(output, "Total issues: " & summary.total);
        arrayAppend(output, "Errors:  #summary.errors# , Warnings:  #summary.warnings# , Info:  #summary.info#, Failures:  #summary.failure#");
        arrayAppend(output, "");
        
        // for (var result in arguments.results) {
        //     var line = result.getSeverity() & " - " & result.getFileName() & ":#result.getLine()#:#result.getColumn()#";
        //     if (result.getLine() > 0) {
        //         line &= " (line " & result.getLine();
        //         if (result.getColumn() > 0) {
        //             line &= ", col " & result.getColumn();
        //         }
        //         line &= ")";
        //     }
        //     line &= ": [" & result.getRuleCode() & "] " & result.getFormattedMessage();
        //     // line &= result.getCode();
        //     arrayAppend(output, line);
        // }
        
        return arrayToList(output, chr(10));
    }
    /**
     * Format results as Bitbucket Report
     *  The bitbucekt report should look like this (see https://developer.atlassian.com/cloud/bitbucket/rest/api-group-reports/#api-repositories-workspace-repo-slug-commit-commit-reports-reportid-put):
        * {
            "type": "<string>", 
            "uuid": "<string>",
            "title": "<string>",
            "details": "<string>",
            "external_id": "<string>",
            "reporter": "<string>",
            "link": "<string>",
            "remote_link_enabled": true,
            "logo_url": "<string>",
            "report_type": "SECURITY", #report_type: SECURITY, COVERAGE, TEST, BUG 
            "result": "PASSED", #result: PASSED, FAILED, PENDING
            "data": [
                {
                "type": "BOOLEAN", #data.type: BOOLEAN, DATE, DURATION, LINK, NUMBER, PERCENTAGE, TEXT#
                "title": "<string>",
                "value": {}
                }
            ],
            "created_on": "<string>",
            "updated_on": "<string>"
            }
     * 
     * There is a separate call to add annotations. we could add them to report.annotaions = [], so that report is in one file. 
     * see https://developer.atlassian.com/cloud/bitbucket/rest/api-group-reports/#api-repositories-workspace-repo-slug-commit-commit-reports-reportid-annotations-post
     * Note: annotation_type and summary are the only mandatory fields in the payload.
     * An annotation looks like:
     * 
     * {
            "type": "<string>", 
            "external_id": "<string>",
            "uuid": "<string>",
            "annotation_type": "VULNERABILITY",  #annotation_type: VULNERABILITY, CODE_SMELL, BUG
            "path": "<string>",
            "line": 199,
            "summary": "<string>",
            "details": "<string>",
            "result": "PASSED", #result: PASSED, FAILED, IGNORED, SKIPPED 
            "severity": "CRITICAL",
            "link": "<string>",
            "created_on": "<string>",
            "updated_on": "<string>"
        }
     * 
     */
    function formatResultsAsBitbucket(required array results, boolean compact = false) {
        // Bitbucket Code Insights format
        var bitbucketReport = {       
            "title": "Linter Report",
            "details": "Static analysis results for CFML code",
            "type": "COVERAGE",
            "report_type": "COVERAGE",
            "result": "PASSED", // Default to FAILED, will set to PASSED if no errors
            "reporter": "LuCLI Linter",
            "reporter_link": "https://github.com/cybersonic/lucli-lint",
            "data": [],
            "annotations": []
        }
        
        // the path for each item has to be relative to the cwd/repo root
        var summary = generateSummary(arguments.results);
        bitbucketReport.data = [
            {
                "type": "NUMBER",
                "title": "Total Issues",
                "value": summary.total
            },
            {
                "type": "NUMBER",
                "title": "Errors",
                "value": summary.errors
            },
            {
                "type": "NUMBER",
                "title": "Warnings",
                "value": summary.warnings
            },
            {
                "type": "NUMBER",
                "title": "Info",
                "value": summary.info
            },
            {
                "type": "NUMBER",
                "title": "Failures",
                "value": summary.failure
            }
        ];


        
        // Set result based on error count
        if (summary.errors > 0 OR summary.failure > 0) {
            bitbucketReport.result = "FAILED";
        }
        
        var count = 0;
        // for each result, create an annotation
        // Convert lint results to Bitbucket annotations format
        for (var result in arguments.results) {
            // TODO: check windows vs unix paths
            var relativePath = Right(
                result.getFileName(),
                Len(result.getFileName()) - Len(variables.filenameUtils.normalize(variables.cwd & "/")) + 1
                );

            //If we forgot the front slash, remove it    
            if(Left(relativePath,1) EQ "/" ){
                relativePath = Mid(relativePath,2);
            }

            count++;
            var annotation = {
                "external_id": "lucee_lint_report-#numberFormat(count, "000")#",
                "title": "[" & result.getRuleCode() & "] " & result.getFormattedMessage(),
                "annotation_type": "CODE_SMELL", //TODO: map type 
                "summary": result.getCode(),
                "path": relativePath,
                "severity": uCase(result.getSeverity()),
                "line": result.getLine(),
                // This is not part of the spec, but useful for linking back
                "end_line": result.getEndLine()
            };
            
            // Map severity to Bitbucket types
            if (result.getSeverity() == "ERROR" OR result.getSeverity() == "FAILURE") {
                annotation.type = "BUG";
                annotation.severity = "HIGH";
            } else if (result.getSeverity() == "WARNING") {
                annotation.type = "CODE_SMELL";
                annotation.severity = "MEDIUM";
            } else {
                annotation.type = "CODE_SMELL";
                annotation.severity = "LOW";
            }
            
            arrayAppend(bitbucketReport.annotations, annotation);
        }
        
        return serializeJSON(var=bitbucketReport, compact: arguments.compact);
    }

    function out(any message){
        if(!isSimpleValue(message)){
            message = serializeJson(var=message, compact=false);
        }
        writeOutput(message & chr(10));
    }
}
