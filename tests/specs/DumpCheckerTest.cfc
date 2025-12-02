
component extends="testbox.system.BaseSpec"{


    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){
        // all your suites go here.
        describe( "Dump Checker", () => {
            var  module = new Module(
                    verbose : false,
                    timing : true,
                    cwd : getDirectoryFromPath(getCurrentTemplatePath())
                );


            it( "A Spec", () => {
                config = {
                    "rules" : {
                        "AVOID_USING_DUMP" : {
                            "enabled" : true
                        }
                    }
                };
                var ret = module.main(file="../specs/artefacts/DumpExample.cfm", format="silent", configStruct=config);
                debug(ret);
                expect(ret.len()).toBe( 2 );
                expect(ret[1].getRuleCode()).toBe( "AVOID_USING_DUMP" );
                expect(ret[1].getLine()).toBe( 2 );
                expect(ret[2].getLine()).toBe( 4 );

            } );
        } );
    }

}

