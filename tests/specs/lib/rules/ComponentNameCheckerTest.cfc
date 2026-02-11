
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
        describe( "Component Name Checker Test", () => {

            var  module = new Module(
                    verbose : false,
                    timing : true,
                    cwd : getDirectoryFromPath(getCurrentTemplatePath())
                );
            it( "should check for valid names", () => {
                var config = {
                    "rules" : {
                        "FUNCTION_TOO_COMPLEX" : {
                            "enabled" : false
                        },
                        "COMPONENT_INVALID_NAME" : {
                            "enabled" : true
                        }
                    }
                };




                var ret = module.main(folder="../../../specs/artefacts/filenames/", format="json", configStruct=config, silent=true);
                ret = deserializeJSON(ret);
                debug(ret);

                var InvalidNames = ret.results.filter( (item) => {
                    return item.ruleCode == "COMPONENT_INVALID_NAME";
                } );
                debug(InvalidNames);
                expect(InvalidNames.len()).toBe( 2 );
                
                
            } )

        } )
    }

}
// 