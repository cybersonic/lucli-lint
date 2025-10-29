/**
 * CFQUERYPARAM_REQ Rule
 * 
 * Detects SQL queries that should use <cfqueryparam> for variables
 * This is a critical security rule to prevent SQL injection
 */
component extends="../BaseRule" {
    
    function init() {
        variables.ruleCode = "CFQUERYPARAM_REQ";
        variables.ruleName = "QueryParamChecker";
        variables.description = "cfquery should use <cfqueryparam>";
        variables.severity = "WARNING";
        variables.message = "<*tag*> should use <cfqueryparam/> for variable '*variable*'";
        variables.group = "Security";
        return this;
    }
    
    /**
     * Check AST for queries without cfqueryparam
     */
    function check(required struct node, required any helper, string fileName = "") {
        var results = [];
        
        // Find all cfquery tags
        var queryTags = helper.getCFMLTagsByName("query");
        
      
        for (var queryTag in queryTags) {
            var violations = checkQueryForParams(queryTag, helper);
            
            for (var violation in violations) {
                results.append(
                    createResultFromNode(
                        message = replace(variables.message, "*tag*", "cfquery"),
                        node = queryTag,
                        fileName = arguments.fileName,
                        variable = violation.variable
                    )
                );
            }
        }
        
        return results;
    }
    
    /**
     * Check a query tag for missing cfqueryparam usage
     */
    function checkQueryForParams(required struct queryTag, required any helper) {
        var violations = [];
        var sqlText = extractSQLText(queryTag);
        
        if (len(sqlText)) {
            var variables = findVariablesInSQL(sqlText);
            var queryParams = findQueryParamsInQuery(queryTag);
            
            // Check each variable to see if it has a corresponding queryparam
            for (var variable in variables) {
                if (!hasMatchingQueryParam(variable, queryParams)) {
                    violations.append({
                        variable: variable,
                        location: variables[variable]
                    });
                }
            }
        }
        
        return violations;
    }
    
    /**
     * Extract SQL text from query tag body
     */
    function extractSQLText(required struct queryTag) {
        var sqlText = "";
        
        // The SQL is typically in the body of the cfquery tag
        if (structKeyExists(queryTag, "body") && 
            structKeyExists(queryTag.body, "body") &&
            isArray(queryTag.body.body)) {
            
            for (var item in queryTag.body.body) {
                if (structKeyExists(item, "type") && item.type == "StringLiteral") {
                    sqlText &= item.value;
                } else if (structKeyExists(item, "raw")) {
                    sqlText &= item.raw;
                }
            }
        }
        
        return sqlText;
    }
    
    /**
     * Find variables in SQL text (simplified pattern matching)
     */
    function findVariablesInSQL(required string sqlText) {
        var variables = {};
        
        // Look for #variable# patterns
        var hashPattern = "##([a-zA-Z_][a-zA-Z0-9_.]*)##";
        var matches = reMatchNoCase(hashPattern, arguments.sqlText);
        
        for (var match in matches) {
            var varName = reReplaceNoCase(match, "##([^##]+)##", "\\1");
            variables[varName] = {
                name: varName,
                pattern: match
            };
        }
        
        return variables;
    }
    
    /**
     * Find cfqueryparam tags within the query
     */
    function findQueryParamsInQuery(required struct queryTag) {
        var queryParams = [];
        
        // Look for cfqueryparam tags in the query body
        if (structKeyExists(queryTag, "body")) {
            var paramTags = findTagsInNode(queryTag.body, "queryparam");
            
            for (var paramTag in paramTags) {
                var paramInfo = extractParamInfo(paramTag);
                if (len(paramInfo.value)) {
                    queryParams.append(paramInfo);
                }
            }
        }
        
        return queryParams;
    }
    
    /**
     * Recursively find tags of a specific name in a node
     */
    function findTagsInNode(required struct node, required string tagName) {
        var tags = [];
        
        // Check current node
        if (structKeyExists(node, "type") && 
            node.type == "CFMLTag" &&
            structKeyExists(node, "name") && 
            node.name == arguments.tagName) {
            tags.append(node);
        }
        
        // Recursively search child nodes
        for (var key in node) {
            var child = node[key];
            if (isArray(child)) {
                for (var item in child) {
                    if (isStruct(item)) {
                        var childTags = findTagsInNode(item, arguments.tagName);
                        tags.append(childTags, true);
                    }
                }
            } else if (isStruct(child)) {
                var childTags = findTagsInNode(child, arguments.tagName);
                tags.append(childTags, true);
            }
        }
        
        return tags;
    }
    
    /**
     * Extract parameter information from cfqueryparam tag
     */
    function extractParamInfo(required struct paramTag) {
        var paramInfo = {
            value: "",
            cfsqltype: "",
            null: false
        };
        
        // Extract attributes from cfqueryparam
        if (structKeyExists(paramTag, "attributes") && isArray(paramTag.attributes)) {
            for (var attr in paramTag.attributes) {
                if (structKeyExists(attr, "name") && structKeyExists(attr, "value")) {
                    switch(attr.name) {
                        case "value":
                            paramInfo.value = getAttributeValue(attr);
                            break;
                        case "cfsqltype":
                            paramInfo.cfsqltype = getAttributeValue(attr);
                            break;
                        case "null":
                            paramInfo.null = getAttributeValue(attr);
                            break;
                    }
                }
            }
        }
        
        return paramInfo;
    }
    
    /**
     * Get attribute value from attribute node
     */
    function getAttributeValue(required struct attr) {
        if (structKeyExists(attr, "value")) {
            if (isStruct(attr.value) && structKeyExists(attr.value, "value")) {
                return attr.value.value;
            } else if (isSimpleValue(attr.value)) {
                return attr.value;
            }
        }
        return "";
    }
    
    /**
     * Check if a variable has a matching cfqueryparam
     */
    function hasMatchingQueryParam(required string variable, required array queryParams) {
        for (var param in queryParams) {
            // Check if the param value references this variable
            if (find("##" & arguments.variable & "##", param.value) ||
                find("#" & arguments.variable & "#", param.value)) {
                return true;
            }
        }
        return false;
    }
}
