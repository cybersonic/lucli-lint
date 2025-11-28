
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
        describe( "My First Suite", () => {
            var  module = new Module(
                    verbose : false,
                    timing : true,
                    cwd : getDirectoryFromPath(getCurrentTemplatePath())
                );


            it( "A Spec", () => {

                var ret = module.main(file="../artefacts/VarExamples.cfc", format="silent", rules="MISSING_VAR");
                debug(ret);
                fail( 'implement' )
            } )

        } )
    }

}
