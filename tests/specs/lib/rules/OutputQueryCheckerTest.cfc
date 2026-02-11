
component extends="testbox.system.BaseSpec"{


    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){
        // all your suites go here.
        describe( "CFoutput Query Checker", () => {
            var  module = new Module(
                    verbose : false,
                    timing : true,
                    cwd : getDirectoryFromPath(getCurrentTemplatePath())
                );


            it( "should find cfoutput query Tags", () => {

                var config = {
                    
                    "rules" : {
                        "AVOID_CFOUTPUT_QUERY" : {
                            "enabled" : true
                        }
                    }
                };

                var ret = module.main(file="../../../specs/artefacts/tags/output.cfm", format="raw", configStruct=config, silent=true);
                debug(ret);

                var results = ret.filter( (item) => {
                    return item.getRuleCode() == "AVOID_CFOUTPUT_QUERY";
                } );

                expect(results.len()).toBe( 1 );
                expect(results[1].getRuleCode()).toBe( "AVOID_CFOUTPUT_QUERY" );
                

            } );
        } );
    }


    
}

