/**
 * LintResult Component
 * 
 * Represents a single linting result/violation found during code analysis
 */
component accessors="true" {
    
    property name="ruleCode" type="string";
    property name="severity" type="string"; // ERROR, WARNING, INFO
    property name="message" type="string";
    property name="fileName" type="string";
    property name="line" type="numeric";
    property name="column" type="numeric";
    property name="offset" type="numeric";
    property name="variable" type="string"; // Variable name involved in the issue
    property name="ruleName" type="string";
    property name="ruleDescription" type="string";
    
    function init(
        required string ruleCode,
        required string severity,
        required string message,
        string fileName = "",
        numeric line = 0,
        numeric column = 0,
        numeric offset = 0,
        string variable = "",
        string ruleName = "",
        string ruleDescription = ""
    ) {
        variables.ruleCode = arguments.ruleCode;
        variables.severity = arguments.severity;
        variables.message = arguments.message;
        variables.fileName = arguments.fileName;
        variables.line = arguments.line;
        variables.column = arguments.column;
        variables.offset = arguments.offset;
        variables.variable = arguments.variable;
        variables.ruleName = arguments.ruleName;
        variables.ruleDescription = arguments.ruleDescription;
        
        return this;
    }
    
    /**
     * Get formatted message with variable substitution
     */
    function getFormattedMessage() {
        var msg = variables.message;
        if (len(variables.variable)) {
            msg = replace(msg, "*variable*", variables.variable, "all");
        }
        return msg;
    }
    
    /**
     * Convert to struct for serialization
     */
    function toStruct() {
        return {
            "ruleCode": variables.ruleCode,
            "severity": variables.severity,
            "message": getFormattedMessage(),
            "fileName": variables.fileName,
            "line": variables.line,
            "column": variables.column,
            "offset": variables.offset,
            "variable": variables.variable,
            "ruleName": variables.ruleName,
            "ruleDescription": variables.ruleDescription
        };
    }
    
    /**
     * Get severity level as numeric (for sorting)
     */
    function getSeverityLevel() {
        switch(variables.severity) {
            case "ERROR":
                return 3;
            case "WARNING":
                return 2;
            case "INFO":
                return 1;
            default:
                return 0;
        }
    }
}
