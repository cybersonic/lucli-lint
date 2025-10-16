<cfscript>
    local.maQuery = "INSERT IGNORE INTO tblDistroUserRoles (userid, role) VALUES #sqlValues.ToList()#";

    echo("My day is #Now()#");

    
    local.maQuery &= "AND ELVIS=true";
    
    QueryExecute( sql=maQuery, params=sqlParams, options={ datasource: application.Datasource, result:"local.rstDistroUserRoles"}  );
    QueryExecute( sql="Select bobby from DropTables", params=sqlParams, options={ datasource: application.Datasource, result:"local.rstDistroUserRoles"}  );
</cfscript>

<cfquery name="elvis">
    SELECT * FROM users WHERE NAME = "Bobby Drop Tables"
</cfquery>

<Cfquery name="elvis2">
    #local.maQuery#    
</Cfquery>