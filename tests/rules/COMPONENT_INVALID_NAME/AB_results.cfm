<cfscript>
    Assert( arrayLen(results) EQ 1, "Expected 1 lint result but got #arrayLen(results)#" );
    Assert( IsInstanceOf(results[1], "LintResult"), "Expected LintResult" );
    Assert( results[1].getRuleCode() EQ "COMPONENT_TOO_SHORT", "Expected rule code COMPONENT_TOO_SHORT but got #results[1].getRuleCode()#" );
</cfscript>
