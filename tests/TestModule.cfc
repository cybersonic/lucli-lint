component {
    function main(args) {
        try {
            // Test basic functionality
            writeOutput("Testing CFML Linter..." & chr(10));
            
            // Test creating a rule
            var rule = createObject("component", "lib.rules.AvoidUsingCFDumpTagRule").init();
            var ruleInfo = rule.getRuleInfo();
            
            writeOutput("Rule Code: " & ruleInfo.ruleCode & chr(10));
            writeOutput("Rule Name: " & ruleInfo.ruleName & chr(10));
            writeOutput("Severity: " & ruleInfo.severity & chr(10));
            
            return "Test successful";
        } catch (any e) {
            writeOutput("Error: " & e.message & chr(10));
            if (structKeyExists(e, "detail")) {
                writeOutput("Detail: " & e.detail & chr(10));
            }
            return "Test failed";
        }
    }
}
