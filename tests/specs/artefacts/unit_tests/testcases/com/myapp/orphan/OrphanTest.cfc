/**
 * Orphan Test
 * This test file does NOT have a corresponding source file
 * This is a sample test file used by UnitTestChecker tests
 */
component extends="testbox.system.BaseSpec" {

    function run() {
        describe("Orphan", function() {
            it("should be a valid test file", function() {
                // This is a placeholder test file for testing UnitTestChecker rule
                expect(true).toBe(true);
            });
        });
    }

}
