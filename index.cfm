<cfscript>
    module = new Module(
        verbose : false,
        timing : true,
        cwd : getDirectoryFromPath(getCurrentTemplatePath())
        

    );
    echo("<pre>");
    ret = module.main(folder="webroot/cron/", format="text", rules="AVOID_USING_SQL");
    echo("</pre>");
    echo("Found #arrayLen(ret)# lint results");
    
</cfscript>