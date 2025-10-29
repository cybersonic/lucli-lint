/**
 * GlobalLiteralChecker.cfc
 *
 * Checks for literal values used too often globally
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN";
        variables.ruleName = "GlobalLiteralChecker";
        variables.description = "Literal value used too often globally";
        variables.severity = "INFO";
        variables.message = "Literal *variable* occurs several times in one or more files. Consider giving it a name and not hard coding values";
        variables.group = "BadPractice";
        variables.parameters = {
            "maximum": 3,
            "maxWarnings": 5,
            "warningScope": "global",
            "ignoreWords": "numeric,text,textnocase,asc,desc,in,out,inout,one,all,bigdecimal,boolean,byte,char,int,long,float,double,short,string,null"
        };
        return this;
    }
    
    /**
     * Check AST for repeated literal values globally
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for literal values used too often across files
        
        return results;
    }
}
