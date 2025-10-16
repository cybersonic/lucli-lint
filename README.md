# CFML Parser and Linter

A comprehensive CFML linter built on Lucee's native AST parser. This module provides static analysis for CFML code, replicating and extending the functionality of CFLint with a more modern, extensible architecture.

## Features

- **AST-Based Analysis**: Uses Lucee's built-in AST parser for accurate code analysis
- **Extensible Rule System**: Easy to add new rules by extending the BaseRule class
- **Configurable**: JSON-based configuration for enabling/disabling rules and setting parameters
- **Multiple Output Formats**: Support for text, JSON, and XML output
- **Rule Categories**: Rules organized by groups (Security, BugProne, Naming, etc.)
- **CFLint Compatibility**: Implements many CFLint rules with the same rule codes

## Usage

```cfml
// Programmatic usage (CFScript)

// Create linter and configuration
var ruleConfig = createObject("component", "lib.RuleConfiguration").init();
var linter = createObject("component", "lib.CFMLLinter").init(ruleConfig);

// Register rules (add what you need)
linter
    .addRule(createObject("component", "lib.rules.AvoidUsingCFDumpTagRule").init())
    .addRule(createObject("component", "lib.rules.QueryParamRule").init());

// Lint a file
var results = linter.lintFile(expandPath("tests/test_bad.cfm"));
writeOutput(linter.formatResults(results, "text"));

// Or lint a source string
var srcResults = linter.lintSource('<cfset x = "test"><cfdump var="#x#">', "inline.cfm");
writeOutput(linter.formatResults(srcResults, "json"));
```

## Architecture

The linter is built with a modular architecture:

### Core Components

- **CFMLLinter**: Main orchestration class that manages rules and executes linting
- **ASTDomHelper**: Enhanced AST traversal and querying utilities
- **BaseRule**: Abstract base class for all linting rules
- **LintResult**: Data structure for individual linting violations
- **RuleConfiguration**: Configuration management system

### Rule System

Rules extend the `BaseRule` class and implement a `check()` method:

```cfml
component extends="../BaseRule" {
    
    function initRuleProperties() {
        variables.ruleCode = "AVOID_USING_CFDUMP_TAG";
        variables.ruleName = "CFDumpChecker";
        variables.description = "Avoid use of cfdump tags";
        variables.severity = "WARNING";
        variables.message = "Avoid leaving <cfdump> tags in committed code";
        variables.group = "BadPractice";
    }
    
    function check(required struct node, required any helper, string fileName = "") {
        var results = [];
        var dumpTags = helper.getCFMLTagsByName("dump");
        
        for (var tag in dumpTags) {
            results.append(
                createResultFromNode(
                    message = variables.message,
                    node = tag,
                    fileName = arguments.fileName
                )
            );
        }
        
        return results;
    }
}
```

## Available rules

Rules live under `lib/rules/` and can be added via `linter.addRule(...)`:
- AvoidUsingCFAbortTagRule.cfc
- AvoidUsingCFDumpTagRule.cfc
- AvoidUsingCreateObjectRule.cfc
- AvoidUsingSQL.cfc
- ExcessiveFunctionLengthRule.cfc
- FunctionHintMissingRule.cfc
- GlobalVarRule.cfc
- MissingVarRule.cfc
- QueryParamRule.cfc
- VariableNameChecker.cfc

## Implemented Rules

### BadPractice Group
- **AVOID_USING_CFDUMP_TAG**: Detects `<cfdump>` tags that shouldn't be in production code
- **AVOID_USING_CFABORT_TAG**: Detects `<cfabort>` tags that shouldn't be in production code

### Naming Group
- **VAR_INVALID_NAME**: Validates variable naming conventions (camelCase, length, etc.)

## Configuration

Create a `cflinter.json` file to configure the linter:

```json
{
    "global": {
        "outputFormat": "text",
        "showRuleNames": true,
        "exitOnError": false,
        "maxIssues": 0
    },
    "rules": {
        "AVOID_USING_CFDUMP_TAG": {
            "enabled": true
        },
        "VAR_INVALID_NAME": {
            "enabled": true,
            "parameters": {
                "case": "camelCase",
                "minLength": 3,
                "maxLength": 20,
                "maxWords": 4
            }
        }
    }
}
```

## Rule Categories (from CFLint)

### BugProne
Rules that catch potential bugs and logic errors

### Security
Rules that identify potential security vulnerabilities

### BadPractice
Rules that enforce coding best practices

### CodeStyle
Rules for code formatting and style consistency

### Naming
Rules for consistent naming conventions

### ModernSyntax
Rules that encourage modern CFML syntax

### Complexity
Rules that identify overly complex code

## Adding New Rules

1. Create a new CFC in `/lib/rules/` extending `BaseRule`
2. Implement the `initRuleProperties()` and `check()` methods
3. Register the rule by calling `linter.addRule(...)` wherever you bootstrap the linter
4. Add configuration options if needed

## Output Formats

### Text (default)
```
CFML Linter Results
====================
Total issues: 2
Errors: 0, Warnings: 1, Info: 1

WARNING - test_bad.cfm (line 2): [AVOID_USING_CFDUMP_TAG] Avoid leaving <cfdump> tags
INFO - test_bad.cfm (line 1): [VAR_INVALID_NAME] Variable x should be longer than 3 characters
```

### JSON
```json
{
  "summary": {
    "total": 2,
    "errors": 0,
    "warnings": 1,
    "info": 1
  },
  "results": [...]
}
```

### XML
```xml
<lintResults>
  <summary>
    <total>2</total>
    <errors>0</errors>
    <warnings>1</warnings>
    <info>1</info>
  </summary>
  <issues>...</issues>
</lintResults>
```

## Test Files

The module includes test files to verify functionality:

- `test_bad.cfm`: Contains multiple linting violations
- `test_good.cfm`: Clean code with no violations

## Future Enhancements

- Automatic rule discovery and loading
- More CFLint rule implementations
- Integration with CI/CD systems
- IDE plugins and integrations
- Performance optimizations for large codebases

## Contributing

To contribute new rules or improvements:

1. Follow the existing rule pattern in `/lib/rules/`
2. Add comprehensive tests
3. Update configuration examples
4. Document the new rule in this README
## Development

This module was created as an extensible alternative to CFLint, leveraging Lucee's native AST parsing capabilities for better accuracy and performance.

## Create a GitHub repository for this module (optional)

If you use GitHub CLI, you can create and push a repo from the current directory:

```
gh repo create --source=. --public --remote=origin --push
```
