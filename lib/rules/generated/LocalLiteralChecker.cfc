/**
 * LocalLiteralChecker.cfc
 *
 * Checks for literal values used too often locally
 *
 * @author  Mark Drew
 * @date 27th Oct 2025
 */
component extends="../../BaseRule" {
    
    function init() {
        variables.ruleCode = "LOCAL_LITERAL_VALUE_USED_TOO_OFTEN";
        variables.ruleName = "LocalLiteralChecker";
        variables.description = "Literal value used too often locally";
        variables.severity = "INFO";
        variables.message = "Literal *variable* occurs several times in the same file. Consider giving it a name and not hard coding values";
        variables.group = "BadPractice";
        variables.parameters = {
            "maximum": 3,
            "maxWarnings": 5,
            "warningScope": "local",
            "ignoreWords": "numeric,text,textnocase,asc,desc,in,out,inout,one,all,bigdecimal,boolean,byte,char,int,long,float,double,short,string,null"
        };
        return this;
    }
    
    /**
     * Check AST for repeated literal values locally
     */
    function check(required struct node, required any helper, string fileName = "", string fileContent="") {
        var results = [];
        
        // TODO: Implement check for literal values used too often in same file
        
        return results;
    }
}
