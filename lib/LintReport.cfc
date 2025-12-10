//This componennt represents a report that is created from a linting operation.
component accessors="true" {

 
    property name="lintResults" type="array" hint="An array of LintResult objects";
    property name="files" type="array" hint="An array of file paths that were linted";

    property name="file" type="string" hint="The file that was linted, if applicable";
    property name="folder" type="string" hint="The folder that was linted, if applicable";


    // Add any other properties or methods needed for the report.
    function init(lintResults){
        variables.lintResults = arguments.lintResults;
        return this;
    }
}