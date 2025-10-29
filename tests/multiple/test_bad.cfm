<cfset x = "test value">
<cfdump var="#x#">
<cfabort>
<cfset NAME = "Another test">
<cfoutput>#NAME#</cfoutput>
<cfset currentUser = 42>
<cfscript>
    dump("In script");
    abort;

    queryExecute("SELECT * FROM users WHERE id = #currentUser#");
</cfscript>
<cfquery name="getData" dbtype="query">
    SELECT id, name
    FROM users
    WHERE status = 'active' AND role = 'admin' AND created_by = #currentUser#
</cfquery>