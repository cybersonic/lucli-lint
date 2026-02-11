
/**
 * My BDD Test
 */
component extends="testbox.system.BaseSpec"{


    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){
        // all your suites go here.
        describe( "Configuration file check", () => {

          
            var sut = new Module(
                    verboseEnabled : false,
                    timingEnabled : true,
                    cwd : expandPath("specs/artefacts/testconfig")
                );
            debug(sut);

            it( "should return a results key", () => {
                var ret = sut.main(folder=".", format="raw", silent=true);
                debug(sut.getRuleConfig() );
                debug(ret, "results");
                expect(ret).toBeArray();
               
            } )

        } )
    }

}

