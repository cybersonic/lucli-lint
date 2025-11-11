<cfscript>
    echo("Starting linting process...#SERVER.lucee.version#<br/>");
    
    module = new Module(
        verboseEnabled : true,
        timingEnabled : true,
        cwd : getDirectoryFromPath(getCurrentTemplatePath())
        

    );
    echo("<pre>");
    ret = module.main(folder="tests/specs/artefacts", format="text", rules="UNIT_TEST_CHECK,SQL_CHECK");
    echo("</pre>");
    echo("Found #arrayLen(ret)# lint results");
    

    // We should be able to 
</cfscript>