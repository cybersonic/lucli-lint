<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucli LINT Unit Tests</title>
</head>
<body>
    <h1>Lucli LINT Unit Tests</h1>
    <!--- Load all the rules --->
    <cfscript>
        loadedRules={};
        testsuite = {
            passes:0,
            failures:0
        };
        rules = DirectoryList( expandPath("../lib/rules"), false, "array", "*.cfc" );
        for (rule in rules) {
            ruleObj = createObject("component", pathToDotted( contractPath(rule) ) ).init();
            loadedRules[ ruleObj.getRuleCode() ] = ruleObj;
        }

        
        // For each test folder, run all the *.cf* through the relevant rule and show results
        testFolders = DirectoryList( 
                                    path:expandPath("./rules"),
                                    recurse: false, 
                                    listInfo:"array", 
                                    type:"dir",
                                    sort: "asc"
                                    );
                                    
                                     
        for (folder in testFolders) {
            key = listLast(folder, "/\");
            echo("<h2>Running tests for rule: #key#</h2>");
            ruleObj = loadedRules[ key ];
            tests = DirectoryList(path:folder, recurse:false, listInfo:"array", filter:function(filepath){
                if( FindNoCase("_results.cfm", filepath) ){
                    return false;
                }
                // Cant handle .cfc tests yet
                if( FindNoCase(".cfm", filepath) ){
                    return true;
                }
                return false;
            }, type:"file");
            for (test in tests) {
                echo("<h3>Test file: #getFileFromPath(test)#</h3>");
                ast = astFromPath(test);
                helper = new lib.ASTDomHelper(ast);
                
                results = ruleObj.check(
                    node: ast,
                    helper: helper,
                    filename: test,
                    fileContent: FileRead(test)
                );
                
                // The results file would be called test_01_results.cfm
                resultsFile = getFileFromPath(replace(test, ".cfm", "_results.cfm", "one"));

                if(!fileExists("./rules/#key#/#resultsFile#")){
                    dump(var=results, label="Results for test file: #test#", expand="false");
                    throw(type="FileNotFound", message="Results file not found for test #test#: expected at ./rules/#key#/#resultsFile#");
                }
                include "./rules/#key#/#resultsFile#";
                dump(var=results, label="Results for test file: #test#", expand="false");
                echo("<hr/>");
                
            }
        }

        function pathToDotted(path) {
            var noExt = listFirst(path, ".");
            var parts = listToArray(noExt, "/\");
            return arrayToList(parts, ".");
        }


        function Assert(boolean condition, string message){
            if(!condition){
                testsuite.failures++;
                dump(var=results, label="Results for test file: #test#", expand="false");
                dump(var=ast, label="Abstract Syntax tree for test file: #test#", expand="false");
                throw(type="AssertionError", message=message);
            }
            testsuite.passes++;
            echo("✅Assertion passed: #message# <br/>");
        }
    </cfscript>
    <h1>Component Tests</h1>
    <cfscript>
    cwd = expandPath("./multiple");
    module = new Module(
        verbose : false,
        timing : true,
        cwd : cwd
        

    );
    ret1 = module.main(file="test_sql_query.cfm", format="silent");

    Assert( arrayLen(ret1) EQ 20, "Expected 20 lint result for file test_sql_query.cfm, got #arrayLen(ret1)#" );
    // dump(ret1);
    
    ret = module.main(folder=".", format="silent");
    Assert( arrayLen(ret) EQ 25, "Expected 25 lint results for folder ., got #arrayLen(ret)#" );
    </cfscript>
    <!--- <cfdump var="#expandPath("../lib/rules")#">
    <cfdump var="#expandPPath("./rules")#">
    <cfdump var="#expandPPath("./rules")#"> --->
</body>
</html>