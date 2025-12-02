
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


            it( "A Spec", () => {

                
                
                var config = {
                    "rules" : {
                        "AVOID_USING_ABORT" : {
                            "enabled" : true,
                            "severity" : "INFO",
                            "parameters" : {
                                "tagOnly" : true
                            }
                        }
                    }
                };
                var ret = module.main(file="../specs/artefacts/AbortExample.cfm", format="silent", configStruct=config);
                debug(ret);
                expect(ret.len()).toBe( 1 );
                expect(ret[1].getRuleCode()).toBe( "AVOID_USING_ABORT" );
                expect(ret[1].getLine()).toBe( 4 );

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
                var ret = module.main(file="../specs/artefacts/AbortExample.cfm", format="silent", configStruct=config);
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

