<cfscript>
    module = new Module();
    module.main(["tests/test_sql_query.cfm", "--format=json", "--rules=no_sql"]);
</cfscript>