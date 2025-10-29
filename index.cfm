<cfscript>
    echo("Starting linting process...#SERVER.lucee.version#<br/>");
    
    module = new Module(
        verbose : false,
        timing : true,
        cwd : getDirectoryFromPath(getCurrentTemplatePath())
        

    );
    echo("<pre>");
    ret = module.main(file="tests/rules/SQL_CHECK/test_02.cfm", format="json", rules="AVOID_USING_SQL");
    echo("</pre>");
    echo("Found #arrayLen(ret)# lint results");
    
</cfscript>