<cfscript>
    Assert( arrayLen(results) EQ 1, "Expected 1 lint result but got #arrayLen(results)#" );
    Assert( IsInstanceOf(results[1], "LintResult"), "Expected LintResult" );
    Assert( results[1].getRuleCode() EQ "AVOID_USING_CFABORT_TAG", "Expected rule code AVOID_USING_CFABORT_TAG but got #results[1].getRuleCode()#" );
    Assert( FindNoCase("cfabort", results[1].getCode()), "Expected no cfquery usage but found #results[1].getCode()#" );
</cfscript>