
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
                expect(ret.len()).toBe( 1 );
                expect(ret[1].getRuleCode()).toBe( "AVOID_USING_ABORT" );
                expect(ret[1].getLine()).toBe( 4 );
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
                expect(ret.len()).toBe( 2 );
                expect(ret[1].getRuleCode()).toBe( "AVOID_USING_ABORT" );
                expect(ret[1].getLine()).toBe( 2 );
                expect(ret[2].getLine()).toBe( 4 );



                // expect(ret[2].getRuleCode()).toBe( "AVOID_USING_ABORT" );

            } );
        } );
    }

}

