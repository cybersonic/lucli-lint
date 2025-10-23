/**
 * CFMLLinter Component
 * 
 * Main linting engine that orchestrates AST parsing and rule execution
 */
component {
    
    property name="rules" type="array";
    property name="ruleConfiguration" type="any";
    property name="astHelper" type="any";
    
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
    function lintFile(required string filePath) {

        if (!fileExists(arguments.filePath)) {
            // Try to expand it
            if(!fileExists(expandPath(arguments.filePath))) {
                throw(type="FileNotFound", message="File not found: " & arguments.filePath);
            } else {
                arguments.filePath = expandPath(arguments.filePath);
            }
            // throw(type="FileNotFound", message="File not found: " & arguments.filePath);
        }

        if(!fileExists(arguments.filePath)){
            throw(type="InvalidFile", message="Not a valid file: " & arguments.filePath);
        }
        
        // Parse the file using Lucee's AST parser
        var ast = astFromPath(arguments.filePath);
        
        return lintAST(ast, arguments.filePath);
    }
    
    /**
     * Lint an already parsed AST
     * @param ast The parsed AST structure
     * @param fileName File name for reporting
     * @return Array of LintResult objects  
     */
    function lintAST(required struct ast, string fileName = "") {
        var results = [];
        
        // Create AST helper
        variables.astHelper = new ASTDomHelper(arguments.ast);
        
        var rules = variables.ruleConfiguration.getEnabledRules();
        var fileContent = FileRead(fileName);
        
        // Run all enabled rules
        for (var rule in rules) {
                try {
                    var ruleResults = rules[rule].check(
                        node:arguments.ast,
                        helper: variables.astHelper,
                        filename: arguments.fileName,
                        fileContent: fileContent);

                    if (isArray(ruleResults)) {
                        arrayAppend(results, ruleResults, true);
                    }
                    else {
                        arrayAppend(results, ruleResults);
                    }
                } catch (any e) {
                    echo(e.stackTrace);
                }
        }
        
        // Sort results by severity and location
        results = sortResults(results);
        
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
            total: arrayLen(arguments.results),
            errors: 0,
            warnings: 0,
            info: 0,
            ruleBreakdown: {}
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
    function formatResults(required array results, string format = "text") {
        switch(arguments.format) {
            case "json":
                return formatResultsAsJSON(arguments.results);
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
        arrayAppend(output, "Errors: " & summary.errors & ", Warnings: " & summary.warnings & ", Info: " & summary.info);
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
    function formatResultsAsJSON(required array results) {
        var jsonResults = [];
        for (var result in arguments.results) {
            arrayAppend(jsonResults, result.toStruct());
        }
        
        return serializeJSON({
            "summary": generateSummary(arguments.results),
            "results": jsonResults
        });
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
