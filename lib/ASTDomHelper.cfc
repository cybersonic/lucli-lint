/**
 * ASTDomHelper Component
 * 
 * Enhanced helper for traversing and querying Lucee CFML AST
 */
component {

    function init(astParseResult){
        variables.parseResult = astParseResult;
        return this;
    }

    /**
     * Get the root AST node
     */
    function getRoot() {
        return variables.parseResult;
    }

    /**
     * Get all function declarations in the AST
     */
    public array function getAllFunctions(){
        return getNodesByType(variables.parseResult, "FunctionDeclaration");
    }

    /**
     * Get all CFML tags in the AST
     */
    public array function getAllCFMLTags(){
        return getNodesByType(variables.parseResult, "CFMLTag");
    }

    /**
     * Get all CFML tags by tag name (e.g., "dump", "output")
     */
    public array function getCFMLTagsByName(required string tagName){
        var allTags = getAllCFMLTags();
        
        var matchingTags = [];
        for(var tag in allTags){
            if(structKeyExists(tag, "name") && tag.name == arguments.tagName){
                arrayAppend(matchingTags, tag);
            }
        }
        return matchingTags;
    }

    /**
     * Get all variable identifiers in the AST
     */
    public array function getAllIdentifiers(){
        return getNodesByType(variables.parseResult, "Identifier");
    }

    /**
     * Get all string literals in the AST
     */
    public array function getAllStringLiterals(){
        return getNodesByType(variables.parseResult, "StringLiteral");
    }

    /**
     * Get all assignment expressions in the AST
     */
    public array function getAllAssignments(){
        return getNodesByType(variables.parseResult, "AssignmentExpression");
    }

    /**
       * Get all assignment expressions in the AST
     */
    public array function getAssignmentsByVariableName(required string varName, any fromNode = null){
        
        var allAssignments = getNodesByType(variables.parseResult, "AssignmentExpression");
        var matchingAssignments = [];

        //TODO: The line of the assignment should be before the fromNode line

        for(var assignment in allAssignments){
            if(!isEmpty(assignment?.left?.property?.name) && isSimpleValue(assignment.left.property.name) && assignment.left.property.name == varName){
                if(assignment.start.line <= fromNode.start.line){
                    matchingAssignments.append(assignment);
                }
                continue;
            }
            if(!isEmpty(assignment?.left?.name) && assignment.left.name == varName){
                arrayAppend(matchingAssignments, assignment);
                continue;
            }
        }

        // UnaryExpression
        var unaryExpressions = getNodesByType(variables.parseResult, "UnaryExpression");
        for(var unary in unaryExpressions){
            if(!isEmpty(unary?.variable?.name) && unary.variable.name == varName){
                if(unary.start.line <= fromNode.start.line){
                matchingAssignments.append(unary);
                }
                continue;
            }
            if(!isEmpty(unary?.variable?.property?.name) && unary.variable.property.name == varName){
                if(unary.start.line <= fromNode.start.line){
                    matchingAssignments.append(unary);
                }
                continue;
            }
        }

        matchingAssignments = matchingAssignments.filter(
            function(item){
                return item.start.line <= fromNode.start.line;
            }
        );
        return matchingAssignments;
    }


    /**
     * Get all Call Expressions in the AST
     */
    public array function getAllCallExpressions(){
        return getNodesByType(variables.parseResult, "CallExpression");
    }



    /**
     * Recursively find all nodes of a specific type in the AST
     * @param root The root node to start searching from
     * @param type The node type to search for
     * @return Array of matching nodes
     */
    function getNodesByType(any root, required string type){
        var results = []; 
        if(!isEmpty(root?.type) && root.type == arguments.type){
            results.append(root);
        }

        if(isArray(root.body?:nullValue())){
            for(var item in root.body){
                results.append( getNodesByType(item, type), true);
            }
        }
        if(isStruct(root.body?:nullValue())){
            results.append( getNodesByType(root.body, type) , true);
        }

        if(
                isStruct(root.consequent?:nullValue())
                AND isArray(root.consequent.body?:nullValue())
            ){
           
           for(var item in root.consequent.body){
                results.append( getNodesByType(item, type), true);
            }
        }
        

       
        if(isArray(root.attributes?:nullValue())){
            for(var item in root.attributes){
                results.append( getNodesByType(item, type), true);
            }
            
        }

        if(isArray(root.arguments?:nullValue())){
            // dump(var="going through the arguments key", label="getNodesByType");
            for(var item in root.arguments){
                results.append( getNodesByType(item, type), true);
            }
        }


        if(isStruct(root.expression?:nullValue()) && root.expression.type == "type"){
            results.append( root.expression );
        }

        return results;
    }

    /**
     * Traverse all nodes in the AST and call a callback function for each
     * @param node The current node
     * @param callback Function to call for each node
     */
    function traverseNode(any node, required function callback){
        if( !isStruct(node) ) {
            return;
        }
        
        // Call callback for current node
        callback(node);
        
        // Traverse all properties of the node
        for(var key in node){
            
            if(isNull(node[key])){
                continue;
            }
            var value = node[key];
            
            if(isArray(value)){
                // Traverse array elements
                for(var item in value){
                    traverseNode(item, callback);
                }
            }
            else if(isStruct(value)){
                // Traverse struct properties
                traverseNode(value, callback);
            }
        }
    }

    /**
     * Find nodes that match a custom predicate function
     * @param predicate Function that returns true for matching nodes
     * @return Array of matching nodes
     */
    function findNodes(required function predicate){
        var results = [];
        
        traverseNode(variables.parseResult, function(node) {
            if(predicate(node)){
                arrayAppend(results, node);
            }
        });
        
        return results;
    }

    /**
     * Get all variables declared in var statements
     */
    function getAllVarDeclarations(){
        // Look for variable declarations - in CFML this could be various forms
        return findNodes(function(node) {
            return isStruct(node) && 
                   structKeyExists(node, "type") && 
                   (node.type == "VariableDeclaration" || 
                    (node.type == "AssignmentExpression" && 
                     structKeyExists(node, "left") && 
                     structKeyExists(node.left, "type") && 
                     node.left.type == "Identifier"));
        });
    }

    /**
     * Check if a variable name follows naming conventions
     * @param name The variable name to check
     * @param caseStyle Expected case style (camelCase, PascalCase, etc.)
     */
    function isValidVariableName(required string name, string caseStyle = "camelCase"){
        // Remove any scope prefixes
        var cleanName = listLast(arguments.name, ".");
        
        switch(arguments.caseStyle) {
            case "camelCase":
                // Should start with lowercase, then camelCase
                return reFind("^[a-z][a-zA-Z0-9]*$", cleanName) > 0;
            case "PascalCase":
                // Should start with uppercase, then PascalCase
                return reFind("^[A-Z][a-zA-Z0-9]*$", cleanName) > 0;
            case "snake_case":
                // Should be lowercase with underscores
                return reFind("^[a-z][a-z0-9_]*$", cleanName) > 0;
            default:
                return true;
        }
    }

    /**
     * Extract the name from an identifier node
     */
    function getIdentifierName(required struct node){
        if(structKeyExists(node, "name")){
            return node.name;
        }
        return "";
    }

    /**
     * Get the source code location of a node
     */
    function getNodeLocation(required struct node){
        var location = {
            line: 0,
            column: 0,
            offset: 0
        };
        
        if (structKeyExists(node, "start") && isStruct(node.start)) {
            if (structKeyExists(node.start, "line")) {
                location.line = node.start.line;
            }
            if (structKeyExists(node.start, "column")) {
                location.column = node.start.column;
            }
            if (structKeyExists(node.start, "offset")) {
                location.offset = node.start.offset;
            }
        }
        
        return location;
    }

    /**
     * Count lines of code in a function or component
     */
    function countLinesInNode(required struct node){
        if(!structKeyExists(node, "start") || !structKeyExists(node, "end")) {
            return 0;
        }
        
        var startLine = structKeyExists(node.start, "line") ? node.start.line : 0;
        var endLine = structKeyExists(node.end, "line") ? node.end.line : 0;
        
        return endLine - startLine + 1;
    }

    /**
     * Find the parent node of a given node
     */
    function findNodeParent(required struct node){
        var parent = variables.parseResult;
        traverseNode(variables.parseResult, function(currentNode) {
            // dump(var=parent, label="parent");
            // dump(var=node, label="node to find parent for");
            // dump(var=currentNode, label="currentNode");
            if(currentNode.keyExists("start")){

            }
            try {
                if(currentNode.keyExists("start") && currentNode.start.line == node.start.line ){
                    return;
                }
            }
            catch (e) {
                out(e);
                out({var=node, label="node to find parent for"});
                out({var=currentNode, label="currentNode"});
                
            }
            
            // for(var key in currentNode){
            //     var value = currentNode[key];
            //     if(isArray(value)){
            //         for(var item in value){
            //             if(item EQ node){
            //                 parent = currentNode;
            //             }
            //         }
            //     }
            //     else if(isStruct(value)){
            //         if(value EQ node){
            //             parent = currentNode;
            //         }
            //     }
            // }
        });
        return parent;
    }
}
