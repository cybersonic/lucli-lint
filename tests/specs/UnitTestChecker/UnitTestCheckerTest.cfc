/**
 * UnitTestChecker Test
 */
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

    /**
     * executes before all suites+specs in the run() method
     */
    function beforeAll(){

    }

    /**
     * executes after all suites+specs in the run() method
     */
    function afterAll(){

    }

    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){
        // all your suites go here.
        describe( "UnitTestChecker", () => {
            var testDir = getDirectoryFromPath(getCurrentTemplatePath());
            var module = new Module(
                verbose : false,
                timing : false,
                cwd : testDir
            );

            it( "should find matching source and test files (INFO)", () => {
                // Test with a source file that has a corresponding test
                var ret = module.main(
                    file = "../artefacts/components/com/myapp/services/SampleService.cfc",
                    format = "silent",
                    rules = "UNIT_TEST_CHECK"
                );

                debug(ret);
                expect( ret ).toBeArray();
                expect( ret.len() ).toBe( 1 );

                var issue = ret[1];
                expect( issue.getRuleCode() ).toBe( "UNIT_TEST_CHECK" );
                expect( issue.getMessage() ).toInclude( "matching source and test files" );
                expect( issue.getSeverity() ).toBe( "INFO" );
            });

            it( "should warn when source exists but test is missing (WARNING)", () => {
                // Test with a source file that does NOT have a corresponding test
                var ret = module.main(
                    file = "../artefacts/components/com/myapp/utils/Helper.cfc",
                    format = "silent",
                    rules = "UNIT_TEST_CHECK"
                );

                debug(ret);
                expect( ret ).toBeArray();
                expect( ret.len() ).toBe( 1 );

                var issue = ret[1];
                expect( issue.getRuleCode() ).toBe( "UNIT_TEST_CHECK" );
                expect( issue.getMessage() ).toInclude( "missing test file" );
                expect( issue.getSeverity() ).toBe( "WARNING" );
            });

            it( "should warn when test exists but source is missing (WARNING)", () => {
                // Test with a test file that does NOT have a corresponding source
                var ret = module.main(
                    file = "../artefacts/unit_tests/testcases/com/myapp/orphan/OrphanTest.cfc",
                    format = "silent",
                    rules = "UNIT_TEST_CHECK"
                );

                debug(ret);
                expect( ret ).toBeArray();
                expect( ret.len() ).toBe( 1 );

                var issue = ret[1];
                expect( issue.getRuleCode() ).toBe( "UNIT_TEST_CHECK" );
                expect( issue.getMessage() ).toInclude( "missing source file" );
                expect( issue.getSeverity() ).toBe( "WARNING" );
            });

            it( "should return empty array when file doesn't match regex pattern", () => {
                // Test with a file that doesn't match the unit test regex pattern
                var ret = module.main(
                    file = "../artefacts/queries.cfm",
                    format = "silent",
                    rules = "UNIT_TEST_CHECK"
                );

                debug(ret);
                expect( ret ).toBeArray();
                expect( ret.len() ).toBe( 0 );
            });

        });
    }

}
