/**
 * BaseRule Component
 * 
 * Abstract base class for all CFML linting rules
 * All rules should extend this class and implement the check() method
 */
component accessors="true" {
    
    // Rule metadata
    property name="ruleCode" type="string";
    property name="ruleName" type="string";
    property name="description" type="string";
    property name="severity" type="string";  default="WARNING"; // ERROR, WARNING, INFO
    property name="message" type="string";
    property name="group" type="string" default="General"; // BugProne, Security, CodeStyle, etc.
    property name="enabled" type="boolean" default="true";
    property name="parameters" type="struct";

   
    /**
     * Main method to check AST node for violations
     * Override this in implementing rules
     * 
     * @param node The AST node to check
     * @param helper The ASTDomHelper instance for traversal
     * @param fileName The name of the file being checked
     * @return Array of LintResult objects
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent = "") {
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
     * Set Paramters, takes in a list of parameters and overrides the existing paramter
     */
    function setParameters(required struct params) {
        for (var param in arguments.params){
            setParameter(param, arguments.params[param]);
        }
        return this;
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
    function createLintResult(
        required any lintRule,
        required any node,
        required string fileName = "",
        required string fileContent = ""
    ){

        var lintResult = new LintResult(
            rule : arguments.lintRule,
            node : arguments.node,
            fileName : arguments.fileName,
            fileContent : arguments.fileContent
        );

        return lintResult;
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
