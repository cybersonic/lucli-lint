/**
 * Sample Service Component
 * This is a sample service that has a corresponding test file
 * This is a placeholder file used by UnitTestChecker tests
 */
component {

    function init() {
        return this;
    }

    function doSomething(required string input) {
        return "Processed: " & input;
    }

}
