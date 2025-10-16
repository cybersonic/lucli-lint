/**
 * BaseRule Component
 * 
 * Abstract base class for all CFML linting rules
 * All rules should extend this class and implement the check() method
 */
component {
    
    // Rule metadata
    property name="ruleCode" type="string";
    property name="ruleName" type="string";
    property name="description" type="string";
    property name="severity" type="string"; // ERROR, WARNING, INFO
    property name="message" type="string";
    property name="group" type="string"; // BugProne, Security, CodeStyle, etc.
    property name="enabled" type="boolean" default="true";
    property name="parameters" type="struct";
    
    function init() {
        variables.enabled = true;
        variables.parameters = {};
        variables.severity = "WARNING";
        variables.group = "General";
        
        // Initialize rule-specific properties
        initRuleProperties();
        
        return this;
    }
    
    /**
     * Override this method in subclasses to set rule-specific properties
     */
    function initRuleProperties() {
        // Default implementation - override in subclasses
    }
    
    /**
     * Main method to check AST node for violations
     * Override this in implementing rules
     * 
     * @param node The AST node to check
     * @param helper The ASTDomHelper instance for traversal
     * @param fileName The name of the file being checked
     * @return Array of LintResult objects
     */
    function check(required struct node, required any helper, string fileName = "") {
        throw(type="NotImplemented", message="check() method must be implemented by subclasses");
    }
    
    /**
     * Check if this rule is enabled
     */
    function isEnabled() {
        return variables.enabled;
    }
    
    /**
     * Enable or disable this rule
     */
    function setEnabled(required boolean enabled) {
        variables.enabled = arguments.enabled;
        return this;
    }
    
    /**
     * Get rule parameter value
     */
    function getParameter(required string name, any defaultValue) {
        if (structKeyExists(variables.parameters, arguments.name)) {
            return variables.parameters[arguments.name];
        }
        return structKeyExists(arguments, "defaultValue") ? arguments.defaultValue : "";
    }
    
    /**
     * Set rule parameter
     */
    function setParameter(required string name, required any value) {
        variables.parameters[arguments.name] = arguments.value;
        return this;
    }
    
    /**
     * Create a LintResult for this rule
     */
    function createResult(
        required string message,
        string fileName = "",
        numeric line = 0,
        numeric column = 0,
        numeric offset = 0,
        string variable = ""
    ) {
        return createObject("component", "LintResult").init(
            ruleCode = variables.ruleCode ?: "",
            severity = variables.severity ?: "WARNING",
            message = arguments.message,
            fileName = arguments.fileName,
            line = arguments.line,
            column = arguments.column,
            offset = arguments.offset,
            variable = arguments.variable,
            ruleName = variables.ruleName ?: "",
            ruleDescription = variables.description ?: ""
        );
    }
    
    /**
     * Create a LintResult from an AST node location
     */
    function createResultFromNode(
        required string message,
        required struct node,
        string fileName = "",
        string variable = ""
    ) {
        var location = getNodeLocation(arguments.node);
        
        return createResult(
            message = arguments.message,
            fileName = arguments.fileName,
            line = location.line,
            column = location.column,
            offset = location.offset,
            variable = arguments.variable
        );
    }
    
    /**
     * Extract location information from AST node
     */
    function getNodeLocation(required struct node) {
        var location = {
            line: 0,
            column: 0,
            offset: 0
        };
        
        if (structKeyExists(arguments.node, "start") && isStruct(arguments.node.start)) {
            if (structKeyExists(arguments.node.start, "line")) {
                location.line = arguments.node.start.line;
            }
            if (structKeyExists(arguments.node.start, "column")) {
                location.column = arguments.node.start.column;
            }
            if (structKeyExists(arguments.node.start, "offset")) {
                location.offset = arguments.node.start.offset;
            }
        }
        
        return location;
    }
    
    /**
     * Check if node matches given type
     */
    function nodeHasType(required struct node, required string type) {
        return structKeyExists(arguments.node, "type") && arguments.node.type == arguments.type;
    }
    
    /**
     * Get rule metadata as struct
     */
    function getRuleInfo() {
        return {
            "ruleCode": variables.ruleCode,
            "ruleName": variables.ruleName,
            "description": variables.description,
            "severity": variables.severity,
            "message": variables.message,
            "group": variables.group,
            "enabled": variables.enabled,
            "parameters": variables.parameters
        };
    }
}
