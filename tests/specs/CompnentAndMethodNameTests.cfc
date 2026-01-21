
/**
 * this is a generic test for the most usual style guide rules For example:
 * COMPONENT_ALLCAPS_NAME
COMPONENT_INVALID_NAME
COMPONENT_TOO_WORDY
COMPONENT_IS_TEMPORARY
FILE_SHOULD_START_WITH_LOWERCASE
PACKAGE_CASE_MISMATCH
EXCESSIVE_FUNCTION_LENGTH
METHOD_INVALID_NAME
VAR_INVALID_NAME
TAG_ALLCAPS
VAR_ALLCAPS_NAME
ACRONYM_NAME_CHECK
VAR_ACRONYM_CECK
VAR_SCOPER
FUNCTION_TYPE_MISSING
FUNCTION_TYPE_ANY
GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN
GLOBAL_VAR
ARG_TYPE_MISSING
ARG_TYPE_ANY
ARGUMENT_MISSING_NAME
ARGUMENT_INVALID_NAME
ARGUMENT_ALLCAPS_NAME
ARGUMENT_TOO_SHORT
ARGUMENT_TOO_LONG
ARGUMENT_TOO_WORDY
ARGUMENT_IS_TEMPORARY
ARGUMENT_HAS_PREFIX_OR_POSTFIX
AVOID_USING_CREATEOBJECT
OPERATOR_ALLCAPS
NO_DEFAULT_INSIDE_SWITCH
AVOID_USING_EVALUATE
AVOID_USING_IIF
 */
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

   
    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){

        
        describe("CFML Linter - Code Style Guide Rules", function(){
            var  module = new Module(
                            verboseEnabled : false,
                            timingEnabled : false,
                            cwd : getDirectoryFromPath(getCurrentTemplatePath())
                        );

                    var ret = module.main(folder="./artefacts/filenames", format="json", silent=true);

                    var results = deserializeJSON(ret);
                  
                    debug(results);
   

            it("should detect COMPONENT_ALLCAPS_NAME", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("COMPONENT_ALLCAPS_NAME");
                    expect(results.summary.ruleBreakdown.COMPONENT_ALLCAPS_NAME).toBeGT(0);
            });
            

            it("should detect COMPONENT_INVALID_NAME", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("COMPONENT_INVALID_NAME");
                    expect(results.summary.ruleBreakdown.COMPONENT_INVALID_NAME).toBeGT(0);
            });

            it("should detect COMPONENT_TOO_WORDY", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("COMPONENT_TOO_WORDY");
                    expect(results.summary.ruleBreakdown.COMPONENT_TOO_WORDY).toBeGT(0);
            });

            it("should detect COMPONENT_IS_TEMPORARY", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("COMPONENT_IS_TEMPORARY");
                    expect(results.summary.ruleBreakdown.COMPONENT_IS_TEMPORARY).toBeGT(0);
            });

            it("should detect FILE_SHOULD_START_WITH_LOWERCASE", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("FILE_SHOULD_START_WITH_LOWERCASE");
                    expect(results.summary.ruleBreakdown.FILE_SHOULD_START_WITH_LOWERCASE).toBeGT(0);
            });

            // TODO in a different component. This would need a component registry
            xit("should detect PACKAGE_CASE_MISMATCH", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("PACKAGE_CASE_MISMATCH");
                    expect(results.summary.ruleBreakdown.PACKAGE_CASE_MISMATCH).toBeGT(0);
            });

            it("should detect EXCESSIVE_FUNCTION_LENGTH", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("EXCESSIVE_FUNCTION_LENGTH");
                    expect(results.summary.ruleBreakdown.EXCESSIVE_FUNCTION_LENGTH).toBeGT(0);
            });

            it("should detect METHOD_TOO_SHORT", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("METHOD_TOO_SHORT");
                    expect(results.summary.ruleBreakdown.METHOD_TOO_SHORT).toBeGT(0);
            });

            
            it("should detect METHOD_TOO_LONG", function(){
                expect(results.summary.ruleBreakdown).toHaveKey("METHOD_TOO_LONG");
                expect(results.summary.ruleBreakdown.METHOD_TOO_LONG).toBeGT(0);
            });
            
            it("should detect METHOD_ALLCAPS_NAME", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("METHOD_ALLCAPS_NAME");
                    expect(results.summary.ruleBreakdown.METHOD_ALLCAPS_NAME).toBeGT(0);
            });
            
            it("should detect METHOD_TOO_WORDY", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("METHOD_TOO_WORDY");
                    expect(results.summary.ruleBreakdown.METHOD_TOO_WORDY).toBeGT(0);
            });


            it("should detect METHOD_IS_TEMPORARY", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("METHOD_IS_TEMPORARY");
                    expect(results.summary.ruleBreakdown.METHOD_IS_TEMPORARY).toBeGT(0);
            });

            xit("should detect VAR_INVALID_NAME", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("VAR_INVALID_NAME");
                    expect(results.summary.ruleBreakdown.VAR_INVALID_NAME).toBeGT(0);
            });

            xit("should detect TAG_ALLCAPS", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("TAG_ALLCAPS");
                    expect(results.summary.ruleBreakdown.TAG_ALLCAPS).toBeGT(0);
            });

            xit("should detect VAR_ALLCAPS_NAME", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("VAR_ALLCAPS_NAME");
                    expect(results.summary.ruleBreakdown.VAR_ALLCAPS_NAME).toBeGT(0);
            });

            xit("should detect ACRONYM_NAME_CHECK", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ACRONYM_NAME_CHECK");
                    expect(results.summary.ruleBreakdown.ACRONYM_NAME_CHECK).toBeGT(0);
            });

            xit("should detect VAR_ACRONYM_CECK", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("VAR_ACRONYM_CECK");
                    expect(results.summary.ruleBreakdown.VAR_ACRONYM_CECK).toBeGT(0);
            });
            
            xit("should detect VAR_SCOPER", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("VAR_SCOPER");
                    expect(results.summary.ruleBreakdown.VAR_SCOPER).toBeGT(0);
            });

            xit("should detect FUNCTION_TYPE_MISSING", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("FUNCTION_TYPE_MISSING");
                    expect(results.summary.ruleBreakdown.FUNCTION_TYPE_MISSING).toBeGT(0);
            });

            xit("should detect FUNCTION_TYPE_ANY", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("FUNCTION_TYPE_ANY");
                    expect(results.summary.ruleBreakdown.FUNCTION_TYPE_ANY).toBeGT(0);
            });

            xit("should detect GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN");
                    expect(results.summary.ruleBreakdown.GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN).toBeGT(0);
            });
            xit("should detect GLOBAL_VAR", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("GLOBAL_VAR");
                    expect(results.summary.ruleBreakdown.GLOBAL_VAR).toBeGT(0);
            });
            xit("should detect ARG_TYPE_MISSING", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARG_TYPE_MISSING");
                    expect(results.summary.ruleBreakdown.ARG_TYPE_MISSING).toBeGT(0);
            });
            xit("should detect ARG_TYPE_ANY", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARG_TYPE_ANY");
                    expect(results.summary.ruleBreakdown.ARG_TYPE_ANY).toBeGT(0);
            });
            xit("should detect ARGUMENT_MISSING_NAME", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARGUMENT_MISSING_NAME");
                    expect(results.summary.ruleBreakdown.ARGUMENT_MISSING_NAME).toBeGT(0);
            });
            xit("should detect ARGUMENT_INVALID_NAME", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARGUMENT_INVALID_NAME");
                    expect(results.summary.ruleBreakdown.ARGUMENT_INVALID_NAME).toBeGT(0);
            });
            
            xit("should detect ARGUMENT_ALLCAPS_NAME", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARGUMENT_ALLCAPS_NAME");
                    expect(results.summary.ruleBreakdown.ARGUMENT_ALLCAPS_NAME).toBeGT(0);
            });

            xit("should detect ARGUMENT_TOO_SHORT", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARGUMENT_TOO_SHORT");
                    expect(results.summary.ruleBreakdown.ARGUMENT_TOO_SHORT).toBeGT(0);
            });

            xit("should detect ARGUMENT_TOO_LONG", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARGUMENT_TOO_LONG");
                    expect(results.summary.ruleBreakdown.ARGUMENT_TOO_LONG).toBeGT(0);
            });

            xit("should detect ARGUMENT_TOO_WORDY", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARGUMENT_TOO_WORDY");
                    expect(results.summary.ruleBreakdown.ARGUMENT_TOO_WORDY).toBeGT(0);
            });

            xit("should detect ARGUMENT_IS_TEMPORARY", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARGUMENT_IS_TEMPORARY");
                    expect(results.summary.ruleBreakdown.ARGUMENT_IS_TEMPORARY).toBeGT(0);
            });

            xit("should detect ARGUMENT_HAS_PREFIX_OR_POSTFIX", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("ARGUMENT_HAS_PREFIX_OR_POSTFIX");
                    expect(results.summary.ruleBreakdown.ARGUMENT_HAS_PREFIX_OR_POSTFIX).toBeGT(0);
            });

            xit("should detect AVOID_USING_CREATEOBJECT", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("AVOID_USING_CREATEOBJECT");
                    expect(results.summary.ruleBreakdown.AVOID_USING_CREATEOBJECT).toBeGT(0);
            });
            xit("should detect OPERATOR_ALLCAPS", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("OPERATOR_ALLCAPS");
                    expect(results.summary.ruleBreakdown.OPERATOR_ALLCAPS).toBeGT(0);
            });

            xit("should detect NO_DEFAULT_INSIDE_SWITCH", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("NO_DEFAULT_INSIDE_SWITCH");
                    expect(results.summary.ruleBreakdown.NO_DEFAULT_INSIDE_SWITCH).toBeGT(0);
            });

            xit("should detect AVOID_USING_EVALUATE", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("AVOID_USING_EVALUATE");
                    expect(results.summary.ruleBreakdown.AVOID_USING_EVALUATE).toBeGT(0);
            });

            xit("should detect AVOID_USING_IIF", function(){
                    expect(results.summary.ruleBreakdown).toHaveKey("AVOID_USING_IIF");
                    expect(results.summary.ruleBreakdown.AVOID_USING_IIF).toBeGT(0);
            });
 
         

         });
      
    }

}
