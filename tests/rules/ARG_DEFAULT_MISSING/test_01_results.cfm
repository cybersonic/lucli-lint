<cfscript>
    
    Assert( arrayLen(results) EQ 2, "Expected 2 lint results but got #arrayLen(results)#" );
    // Assert( IsInstanceOf(results[1], "LintResult"), "Expected LintResult" );
    // Assert( results[1].getRuleCode() EQ "AVOID_USING_CFABORT_TAG", "Expected rule code AVOID_USING_CFABORT_TAG but got #results[1].getRuleCode()#" );
    // Assert( FindNoCase("cfabort", results[1].getCode()), "Expected no cfquery usage but found #results[1].getCode()#" );
</cfscript>