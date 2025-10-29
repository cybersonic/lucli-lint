<cfscript>
    Assert( arrayLen(results) EQ 1, "Expected 1 lint result but got #arrayLen(results)#" );
    Assert( IsInstanceOf(results[1], "LintResult"), "Expected LintResult" );
    Assert( results[1].getRuleCode() EQ "PACKAGE_CASE_MISMATCH", "Expected rule code PACKAGE_CASE_MISMATCH but got #results[1].getRuleCode()#" );
</cfscript>
