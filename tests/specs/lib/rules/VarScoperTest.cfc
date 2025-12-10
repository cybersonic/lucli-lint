
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
        describe( "Var Scoper", () => {
            var  module = new Module(
                    verbose : false,
                    timing : true,
                    cwd : getDirectoryFromPath(getCurrentTemplatePath())
                );


            it( "should check for var before a variable is used. Unless localmode=true" , () => {

                var ret = module.main(
                        file="../../../specs/artefacts/VarExamples.cfc", 
                        format="raw", 
                        silent="true", 
                        rules="MISSING_VAR", 
                        silent=true,
                        logfile="varscoper_log.txt"
                );
                debug(ret);
                
            } )

        } )
    }

}
