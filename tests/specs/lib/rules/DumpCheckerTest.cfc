
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
                        },
                        "SQL_CHECK": {
                            "enabled" : false
                        }
                    }
                };
                var ret = module.main(file="../../../specs/artefacts/DumpExample.cfm", format="raw", configStruct=config, silent=true);
                debug(ret);
                // filter to see only the dump results
                results = ret.filter( (item) => {
                    return item.getRuleCode() == "AVOID_USING_DUMP";
                } );
                expect(results.len()).toBe( 3 );
                expect(results[1].getRuleCode()).toBe( "AVOID_USING_DUMP" );
                expect(results[1].getCode()).toBe( 'dump("elvis")' );
                expect(results[2].getRuleCode()).toBe( "AVOID_USING_DUMP" );
                expect(results[2].getCode()).toBe( 'writeDump(var="elvis")' );
                expect(results[3].getRuleCode()).toBe( "AVOID_USING_DUMP" );
                expect(results[3].getCode()).toInclude( 'cfdump' );

            } );
        } );
    }

}

