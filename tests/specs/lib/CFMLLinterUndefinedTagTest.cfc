component extends="testbox.system.BaseSpec" {

    function run( testResults, testBox ) {
        describe( "CFMLLinter undefined custom tag fallback", () => {
            var module = new Module(
                verbose: false,
                timing: false,
                cwd: getDirectoryFromPath(getCurrentTemplatePath())
            );

            it( "should lint SQL inside a self-closing unknown custom tag", () => {
                var ret = module.main(
                    file="../artefacts/selfClosingCustomTag.cfm",
                    format="raw",
                    rules="SQL_CHECK",
                    silent=true
                );

                expect( ret ).toBeArray();
                expect( ret.len() ).toBe( 1 );
                expect( ret[1].getRuleCode() ).toBe( "SQL_CHECK" );
                expect( ret[1].getCode() ).toInclude( "SELECT id" );
            } );

            it( "should lint SQL inside an opening-only unknown custom tag", () => {
                var ret = module.main(
                    file="../artefacts/openingOnlyCustomTag.cfm",
                    format="raw",
                    rules="SQL_CHECK",
                    silent=true
                );

                expect( ret ).toBeArray();
                expect( ret.len() ).toBe( 1 );
                expect( ret[1].getRuleCode() ).toBe( "SQL_CHECK" );
                expect( ret[1].getCode() ).toInclude( "SELECT name" );
            } );

            it( "should continue linting when fallback still cannot parse and ignoreParseErrors is true", () => {
                var ret = module.main(
                    file="../artefacts/selfClosingCustomTag.cfm",
                    format="raw",
                    rules="SQL_CHECK",
                    configStruct={
                        global: { ignoreParseErrors: true, allRulesEnabled: false },
                        rules: { SQL_CHECK: { enabled: true } }
                    },
                    silent=true
                );

                expect( ret ).toBeArray();
            } );
        } );
    }

}
