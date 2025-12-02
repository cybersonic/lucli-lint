
component extends="testbox.system.BaseSpec"{


    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){
        // all your suites go here.
        describe( "Simple Complexity Checker", () => {


            var  module = new Module(
                    verbose : false,
                    timing : true,
                    cwd : getDirectoryFromPath(getCurrentTemplatePath())
                );


            it("sample should be valid", function(){
                var sample = new tests.specs.artefacts.ComplexitySample();
                debug(sample);
                debug(sample.switchLike("new"));
            });
            it( "should find basic functions and measure complexity", () => {
                var config = {
                    "rules" : {
                        "FUNCTION_TOO_COMPLEX" : {
                            "enabled" : true,
                            "severity" : "INFO",
                            "parameters" : {
                                "maximum" : 1
                            }
                        }
                    }
                };
                var retJSON = module.main(file="../specs/artefacts/ComplexitySample.cfc", format="json", configStruct=config, silent=true);
                expect(isJSON(retJSON)).toBeTrue();
                var ret = deserializeJSON(retJSON);

                debug(ret);
                expect(ret).toHaveKey("results");
                expect(ret.results.len()).toBe( 6 );
                expect(ret.results[1].ruleCode).toBe( "FUNCTION_TOO_COMPLEX" );

            } );

            it("should only return complexity > 10 functions", ()=>{
                 var config = {
                    "rules" : {
                        "FUNCTION_TOO_COMPLEX" : {
                            "enabled" : true,
                            "severity" : "INFO",
                            "parameters" : {
                                "maximum" : 10
                            }
                        }
                    }
                };
                var retJSON = module.main(file="../specs/artefacts/ComplexitySample.cfc", format="json", configStruct=config, silent=true);
                expect(isJSON(retJSON)).toBeTrue();
                var ret = deserializeJSON(retJSON);

                debug(ret);
                expect(ret).toHaveKey("results");
                expect(ret.results.len()).toBe( 1 );
                expect(ret.results[1].ruleCode).toBe( "FUNCTION_TOO_COMPLEX" );
            })
        } );
    }

}

