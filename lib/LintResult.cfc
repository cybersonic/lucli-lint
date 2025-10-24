/**
 * LintResult Component
 * 
 * Represents a single linting result/violation found during code analysis
 */
component accessors="true" {
    
    property name="ruleCode" type="string";
    property name="ruleName" type="string";
    property name="ruleDescription" type="string";
    property name="severity" type="string"; // ERROR, WARNING, INFO, FAILURE
    property name="message" type="string";
    property name="fileName" type="string";
    property name="line" type="numeric";
    property name="column" type="numeric";
    property name="offset" type="numeric";
    property name="endline" type="numeric";
    property name="endcolumn" type="numeric";
    property name="endOffset" type="numeric";
    property name="code" type="string";
    property name="variable" type="string";

    
    function init(
        required any rule,
        required any node,
        required string fileName,
        required string fileContent,
        

    ) {
       
        // Here is where we do the actual work
        setRuleCode(arguments.rule.getRuleCode());
        setRuleName(arguments.rule.getRuleName());
        setRuleDescription(arguments.rule.getDescription());
        setSeverity(arguments.rule.getSeverity());
        setMessage(arguments.rule.getMessage());
        setFileName(arguments.fileName);
        setLine(arguments.node.start.line);
        setColumn(arguments.node.start.column);
        setOffset(arguments.node.start.offset);
        setEndLine(arguments.node.end.line);
        setEndColumn(arguments.node.end.column);
        setEndOffset(arguments.node.end.offset);

        try{
            var start = arguments.node.start.offset < 1 ? 1 : arguments.node.start.offset;
            var count = arguments.node.end.offset - start;
            setCode(Mid(arguments.fileContent, start, count));

        }
        catch(e){
            dump(e);
            dump(arguments);
        }
        // setVariable(arguments.variable);

        return this;
    }
    
    /**
     * Get formatted message with variable substitution
     */
    function getFormattedMessage() {
        var msg = variables.message;
        var varValue = variables.variable ?: "";
        if (len(varValue)) {
            msg = replace(msg, "*variable*", varValue, "all");
        }
        return msg;
    }
    
    /**
     * Convert to struct for serialization
     */
    function toStruct() {
        return {
            "ruleCode": variables.ruleCode,
            "ruleName": variables.ruleName,
            "ruleDescription": variables.ruleDescription,
            "severity": variables.severity,
            "message": variables.message,
            "fileName": variables.fileName,
            "line": variables.line,
            "column": variables.column,
            "offset": variables.offset,
            "endline": variables.endline,
            "endcolumn": variables.endcolumn,
            "endOffset": variables.endOffset,
            "code": variables.code,
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
