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
        describe( "ExcessiveFunctionLengthRule Suite", () => {

           var  module = new Module(
                    verbose : false,
                    timing : true,
                    cwd : getDirectoryFromPath(getCurrentTemplatePath())
                );
            it( "Should pass and fail functions that are too long", () => {
                var config = {
                    "rules" : {
                        "EXCESSIVE_FUNCTION_LENGTH" : {
                            "enabled" : true
                        },
                        "COMPONENT_INVALID_NAME" : {
                            "enabled" : false
                        },
                        "FUNCTION_TOO_COMPLEX" : {
                            "enabled" : false
                        }
                    }
                };
                var ret = module.main(file="../../../specs/artefacts/functions/function_checks.cfm", format="raw", configStruct=config, silent=true);
    

                    debug(ret);
                
                expect(ret.len()).toBe( 1 );
                expect(ret[1].getRuleCode()).toBe( "EXCESSIVE_FUNCTION_LENGTH" );
            } )

        } )
    }

}

