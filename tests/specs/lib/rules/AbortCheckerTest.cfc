
component extends="testbox.system.BaseSpec"{


    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){
        // all your suites go here.
        describe( "Abort Checker", () => {
            var  module = new Module(
                    verbose : false,
                    timing : true,
                    cwd : getDirectoryFromPath(getCurrentTemplatePath())
                );


            it( "should find abort Tags", () => {

                
                
                var config = {
                    "rules" : {
                        "AVOID_USING_ABORT" : {
                            "enabled" : true,
                            "severity" : "INFO",
                            "parameters" : {
                                "tagOnly" : true
                            }
                        },
                        "SQL_CHECK": {
                            "enabled" : false
                        }
                    }
                };
                var ret = module.main(file="../../../specs/artefacts/AbortExample.cfm", format="raw", silent="true" ,configStruct=config);
                debug(ret);

                var results = ret.filter( (item) => {
                    return item.getRuleCode() == "AVOID_USING_ABORT";
                } );

                expect(results.len()).toBe( 1 );
                expect(results[1].getRuleCode()).toBe( "AVOID_USING_ABORT" );
                expect(results[1].getLine()).toBe( 4 );
            } );
            it( "should find all abort statements", () => {
                config = {
                    "rules" : {
                        "AVOID_USING_ABORT" : {
                            "enabled" : true,
                            "severity" : "INFO",
                            "parameters" : {
                                "tagOnly" : false
                            }
                        }
                    }
                };
                var ret = module.main(file="../../../specs/artefacts/AbortExample.cfm", format="raw",  silent="true", configStruct=config);
                debug(ret);

                results = ret.filter( (item) => {
                    return item.getRuleCode() == "AVOID_USING_ABORT";
                } );

                debug(results);
                expect(results.len()).toBe( 2 );
                expect(results[1].getRuleCode()).toBe( "AVOID_USING_ABORT" );
                expect(results[1].getLine()).toBe( 2 );
                expect(results[2].getLine()).toBe( 4 );



                // expect(ret[2].getRuleCode()).toBe( "AVOID_USING_ABORT" );

            } );
        } );
    }


    
}

