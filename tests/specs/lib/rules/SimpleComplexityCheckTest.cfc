
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
                
                expect( sample.switchLike("new") ).toBe( "New" );
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
                        },
                        "COMPONENT_INVALID_NAME" : {
                            "enabled" : false
                        }
                    }
                };
                var ret = module.main(file="../../../specs/artefacts/ComplexitySample.cfc", format="raw", configStruct=config, silent=true);
               

                debug(ret);
               
                var results = ret.filter( (item) => {
                    return item.getRuleCode() == "FUNCTION_TOO_COMPLEX";
                } );
                expect(results.len()).toBe( 6 );
                expect(results[1].getRuleCode()).toBe( "FUNCTION_TOO_COMPLEX" );

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
                        },
                         "COMPONENT_INVALID_NAME" : {
                            "enabled" : false
                        }
                    }
                };
                var ret = module.main(file="../../../specs/artefacts/ComplexitySample.cfc", format="raw", configStruct=config, silent=true, codeFilters="FUNCTION_TOO_COMPLEX");
    

                debug(ret);

                var results = ret.filter( (item) => {
                    return item.getRuleCode() == "FUNCTION_TOO_COMPLEX";
                } );
                
                expect(results.len()).toBe( 1 );
                expect(results[1].getRuleCode()).toBe( "FUNCTION_TOO_COMPLEX" );
            })
        } );
    }

}

