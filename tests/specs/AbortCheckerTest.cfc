
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

                var ret = module.main(file="../specs/artefacts/AbortExample.cfm", format="silent", rules="AVOID_USING_ABORT");
                debug(ret);
                expect(ret.len()).toBe( 2 );
                expect(ret[1].getRuleCode()).toBe( "AVOID_USING_ABORT" );
                expect(ret[2].getRuleCode()).toBe( "AVOID_USING_ABORT" );
                
            } );
        } );
    }

}

