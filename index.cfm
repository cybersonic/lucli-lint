<cfscript>
    module = new Module(
        verbose : true,
        timing : true,
        cwd : getDirectoryFromPath(getCurrentTemplatePath())
        

    );
    ret = module.main(file="tests/test_sql_query.cfm", format="silent", rules="AVOID_USING_SQL");
    dump(ret);
</cfscript>