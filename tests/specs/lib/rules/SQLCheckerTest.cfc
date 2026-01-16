
/**
 * My BDD Test
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
        describe( "SQLChecker", () => {
                var  module = new Module(
                    verbose : false,
                    timing : true,
                    cwd : getDirectoryFromPath(getCurrentTemplatePath())
                );
    
                debug(module);
            it( "should find all sql variables in a page", () => {
                var ret = module.main(file="../../artefacts/queries.cfm", format="raw", rules="SQL_CHECK", silent=true);
                debug(ret);
                expect( ret ).toBeArray( );
                expect( ret.len() ).toBe( 25 );

                var firstIssue = ret[1];
                expect( firstIssue.getRuleCode() ).toBe( "SQL_CHECK" );
                expect( firstIssue.getCode() ).toBe( 'qry = new Query("SELECT * FROM ELVIS")' );
            } )

            it( "should find all sql variables in a CFC file", () => {
                var ret = module.main(file="../../artefacts/components/com/myapp/services/SampleService.cfc", format="raw", rules="SQL_CHECK", silent=true);
                debug(ret);
                expect( ret ).toBeArray( );
                expect( ret.len() ).toBe( 1 );

                var firstIssue = ret[1];
                expect( firstIssue.getRuleCode() ).toBe( "SQL_CHECK" );
                expect( firstIssue.getCode() ).toBe( 'var queryResult = queryExecute(
            sql: "
                select * from customers;
            "
        )' );
            } )

        } )
    }

}
