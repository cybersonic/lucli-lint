# Creating Rules
Rules are the core of the LINT module. They define the checks that will be performed on your CFML code. You can create custom rules to enforce specific coding standards or best practices in your projects.

## Rule Structure
A rule is defined as a Lucee component (CFC) that extends the `lint.rules.BaseRule` component. Each rule must implement the following methods:

`inti()` :

`check()` : This method contains the logic for the rule. It receives a `CFMLFile` object and should return an array of `LintResult` objects representing any issues found.