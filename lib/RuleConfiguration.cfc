/**
 * RuleConfiguration Component
 * 
 * Manages configuration for linting rules including enabled/disabled status and parameters
 */
component accessors="true" {
    
    property name="ruleSettings" type="struct" default="#{}#";
    property name="globalSettings" type="struct" default="#{}#";
    property name="rules" type="struct" default="#{}#";
    property name="ignoreFiles" type="array" default="#[]#";
    property name="rulesByNodeType" type="struct" default="#{}#";



    function init(string configFile = "") {
        variables.ruleSettings = {};
        variables.globalSettings = {
            outputFormat: "text",
            showRuleNames: true,
            exitOnError: false,
            maxIssues: 0 // 0 = unlimited
        }; 

        if (len(arguments.configFile) && fileExists(arguments.configFile)) {
            loadConfigurationFromFile(arguments.configFile);
        }
         // Add all the installed rules
        
        var rules = directoryList("#getDirectoryFromPath(getCurrentTemplatePath())#/rules/", false, "name", "*.cfc");
        for(var ruleClass in rules) {
            
            var ruleName = listFirst(ruleClass, ".");
            var rule = createObject("component", "rules.#ruleName#").init();
            var ruleCode = rule.getRuleCode();
            if(variables.ruleSettings.KeyExists(ruleCode)){
                // Override the paramters from the config
                rule.setParameters(variables.ruleSettings[ruleCode]);
            }
            variables.rules[ruleCode] = rule; 

            // Group them by type
            if(not structKeyExists(variables.rulesByNodeType, rule.getNodeType())){
                variables.rulesByNodeType[rule.getNodeType()] = [];
            }
            variables.rulesByNodeType[rule.getNodeType()].append(rule);
        }

        return this;
    }
    
    /**
     * Load configuration from JSON file
     * @param configFile Path to the configuration JSON file
     */
    function loadConfigurationFromFile(required string configFile) {
        try {
            var configJson = fileRead(arguments.configFile);
            var config = deserializeJSON(configJson);
            
            // Load global settings
            if (structKeyExists(config, "global")) {
                structAppend(variables.globalSettings, config.global, true);
            }
            
            // Load rule settings
            if (structKeyExists(config, "rules")) {
                variables.ruleSettings = config.rules;
            }

            // Load ignore files glob patterns
            if (structKeyExists(config, "ignoreFiles")) {
                variables.ignoreFiles = config.ignoreFiles;
            }
            
        } catch (any e) {
            throw(type="ConfigurationError", message="Failed to load configuration file: " & e.message);
        }
    }
    
    /**
     * Save current configuration to JSON file
     * @param configFile Path where to save the configuration
     */
    function saveConfigurationToFile(required string configFile) {
        // We need to actually get each rule item here
        var config = {
            "global": variables.globalSettings,
            "rules": variables.ruleSettings
        };
        
        try {
            fileWrite(arguments.configFile, serializeJSON(config));
        } catch (any e) {
            throw(type="ConfigurationError", message="Failed to save configuration file: " & e.message);
        }
    }


    public array function getRulesByNodeType(required string nodeType){
        return variables.rulesByNodeType[arguments.nodeType] ?: [];
    }


    public struct function getEnabledRules(){
        return variables.rules.filter(function(key,value){
            return value.isEnabled();
        });
    }
    
    /**
     * Check if a rule is enabled
     * @param ruleCode The rule code to check
     * @return Boolean indicating if the rule is enabled
     */
    function isRuleEnabled(required string ruleCode) {
        if (structKeyExists(variables.ruleSettings, arguments.ruleCode)) {
            var ruleSetting = variables.ruleSettings[arguments.ruleCode];
            if (isStruct(ruleSetting) && structKeyExists(ruleSetting, "enabled")) {
                return ruleSetting.enabled;
            }
            // If it's just a boolean value
            if (isBoolean(ruleSetting)) {
                return ruleSetting;
            }
        }
        // Default to enabled if not specified
        return true;
    }
    
    /**
     * Enable or disable a rule
     * @param ruleCode The rule code
     * @param enabled Whether the rule should be enabled
     */
    function setRuleEnabled(required string ruleCode, required boolean enabled) {
        if (!structKeyExists(variables.ruleSettings, arguments.ruleCode)) {
            variables.ruleSettings[arguments.ruleCode] = {};
        }
        
        if (isStruct(variables.ruleSettings[arguments.ruleCode])) {
            variables.ruleSettings[arguments.ruleCode].enabled = arguments.enabled;
        } else {
            variables.ruleSettings[arguments.ruleCode] = arguments.enabled;
        }
        
        return this;
    }


    /**
     * Only enable the following rules. Good for specific rule matching
     *
     * @ruleCodes an array of rule codes to enable
     */
    function enableOnlyRules(required array ruleCodes) {
        // Disable all rules first
        for (var ruleCode in structKeyArray(variables.rules)) {
            setRuleEnabled(ruleCode, false);
        }
        // Enable only specified rules
        for (var code in arguments.ruleCodes) {
            setRuleEnabled(code, true);
        }
        return this;
    }


    
    /**
     * Get a rule parameter value
     * @param ruleCode The rule code
     * @param paramName The parameter name
     * @param defaultValue Default value if parameter is not set
     * @return The parameter value or default value
     */
    function getRuleParameter(required string ruleCode, required string paramName, any defaultValue) {
        if (structKeyExists(variables.ruleSettings, arguments.ruleCode)) {
            var ruleSetting = variables.ruleSettings[arguments.ruleCode];
            if (isStruct(ruleSetting) && 
                structKeyExists(ruleSetting, "parameters") && 
                isStruct(ruleSetting.parameters) &&
                structKeyExists(ruleSetting.parameters, arguments.paramName)) {
                return ruleSetting.parameters[arguments.paramName];
            }
        }
        
        return structKeyExists(arguments, "defaultValue") ? arguments.defaultValue : nullValue();
    }
    
    /**
     * Set a rule parameter value
     * @param ruleCode The rule code
     * @param paramName The parameter name
     * @param value The parameter value
     */
    function setRuleParameter(required string ruleCode, required string paramName, required any value) {
        if (!structKeyExists(variables.ruleSettings, arguments.ruleCode)) {
            variables.ruleSettings[arguments.ruleCode] = {
                enabled: true,
                parameters: {}
            };
        }
        
        var ruleSetting = variables.ruleSettings[arguments.ruleCode];
        
        // Convert boolean setting to struct if needed
        if (isBoolean(ruleSetting)) {
            variables.ruleSettings[arguments.ruleCode] = {
                enabled: ruleSetting,
                parameters: {}
            };
            ruleSetting = variables.ruleSettings[arguments.ruleCode];
        }
        
        if (!structKeyExists(ruleSetting, "parameters")) {
            ruleSetting.parameters = {};
        }
        
        ruleSetting.parameters[arguments.paramName] = arguments.value;
        
        return this;
    }
    
    /**
     * Get global setting value
     * @param settingName The setting name
     * @param defaultValue Default value if setting is not found
     * @return The setting value or default value
     */
    function getGlobalSetting(required string settingName, any defaultValue) {
        if (structKeyExists(variables.globalSettings, arguments.settingName)) {
            return variables.globalSettings[arguments.settingName];
        }
        return structKeyExists(arguments, "defaultValue") ? arguments.defaultValue : nullValue();
    }
    
    /**
     * Set global setting value
     * @param settingName The setting name
     * @param value The setting value
     */
    function setGlobalSetting(required string settingName, required any value) {
        variables.globalSettings[arguments.settingName] = arguments.value;
        return this;
    }
    
    /**
     * Enable rules by group
     * @param group The rule group name (e.g., "Security", "BugProne")
     * @param enabled Whether rules in this group should be enabled
     */
    function setRuleGroupEnabled(required string group, required boolean enabled) {
        // This would need to be called with a list of rules in the group
        // For now, we'll store it as a group setting
        var groupKey = "group_" & arguments.group;
        setGlobalSetting(groupKey, arguments.enabled);
        return this;
    }
    
    /**
     * Check if a rule group is enabled
     * @param group The rule group name
     * @return Boolean indicating if the group is enabled
     */
    function isRuleGroupEnabled(required string group) {
        var groupKey = "group_" & arguments.group;
        return getGlobalSetting(groupKey, true); // Default to enabled
    }
    
    /**
     * Get all rule settings
     * @return Struct containing all rule settings
     */
    function getAllRuleSettings() {
        return variables.ruleSettings;
    }
    
    /**
     * Get all global settings
     * @return Struct containing all global settings
     */
    function getAllGlobalSettings() {
        return variables.globalSettings;
    }
    
    /**
     * Reset configuration to defaults
     */
    function resetToDefaults() {
        variables.ruleSettings = {};
        variables.globalSettings = {
            outputFormat: "text",
            showRuleNames: true,
            exitOnError: false,
            maxIssues: 0
        };
        return this;
    }
    
    /**
     * Create a sample configuration file content
     * @return JSON string with sample configuration
     */
    function generateSampleConfig() {
        var sampleConfig = {
            "global": {
                "outputFormat": "text",
                "showRuleNames": true,
                "exitOnError": false,
                "maxIssues": 0
            },
            "rules": {
                "AVOID_USING_CFDUMP_TAG": {
                    "enabled": true
                },
                "VAR_INVALID_NAME": {
                    "enabled": true,
                    "parameters": {
                        "case": "camelCase",
                        "minLength": 3,
                        "maxLength": 20
                    }
                },
                "EXCESSIVE_FUNCTION_LENGTH": {
                    "enabled": true,
                    "parameters": {
                        "length": 100
                    }
                },
                "CFQUERYPARAM_REQ": {
                    "enabled": true
                }
            }
        };
        
        return serializeJSON(sampleConfig);
    }
    
    /**
     * Merge configuration from another configuration object
     * @param otherConfig Another RuleConfiguration instance
     */
    function mergeConfiguration(required any otherConfig) {
        // Merge global settings
        var otherGlobal = arguments.otherConfig.getAllGlobalSettings();
        structAppend(variables.globalSettings, otherGlobal, true);
        
        // Merge rule settings
        var otherRules = arguments.otherConfig.getAllRuleSettings();
        structAppend(variables.ruleSettings, otherRules, true);
        
        return this;
    }
}
