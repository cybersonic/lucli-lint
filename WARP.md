# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Project overview
- CFML linter module for LuCLI that parses CFML via Lucee’s AST and applies rules defined under lib/rules.
- Primary entrypoint for CLI usage is Module.cfc (main), orchestrating configuration, linting, and output formatting.

Common commands
- Show help
  - lucli lint
- Lint a single file
  - lucli lint file=path/to/file.cfm format=text
- Lint a folder (recursive), restrict to specific rules, JSON output (pretty)
  - lucli lint folder=. rules=SQL_CHECK format=json compact=false
- Use a specific config file instead of repo default .lucli-lint.json
  - lucli lint folder=. config=./path/to/config.json
- Run the shell smoke tests in this repo
  - bash test_suite.sh
- Build and publish the Docker image that bundles LuCLI + this module (uses buildx and jq)
  - ./build.sh
- Use Docker image to lint the current working directory (mounts PWD and runs LuCLI in the container)
  - docker run --rm -v "$PWD":/work -w /work markdrew/lucli-lint:latest lucli lint folder=. format=json

Running tests (TestBox)
- This repo includes TestBox specs under tests/specs and an HTML runner at tests/index.cfm.
- Serve the repo root with a Lucee server (webroot is ./; lucee.json provided) and hit the runner:
  - All tests: http://localhost:8000/tests/
  - Run a single bundle: http://localhost:8000/tests/?bundles=tests.specs.SQLChecker.SQLCheckerTest
  - Select reporter: http://localhost:8000/tests/?reporter=simple

Configuration
- Default config file name: .lucli-lint.json (at the lint invocation CWD). Example fields are documented in docs/CONFIG_FILE.md.
- Top-level keys:
  - global: outputFormat (text|json|xml|bitbucket|silent|tsc), showRuleNames, exitOnError, ignoreParseErrors, maxIssues
  - rules: per-rule settings, including enabled and parameters
  - ignoreFiles: array of glob patterns; matched against absolute paths (use **/ to match any depth)

High-level architecture
- Module.cfc
  - init(verbose, timingEnabled, cwd, timer) and main(file, folder, format, rules, config, compact).
  - Resolves config path (defaults to cwd/.lucli-lint.json), initializes RuleConfiguration, and enables only specified rules if rules=... is provided.
  - Instantiates CFMLLinter, normalizes file/folder paths, aggregates results, and delegates formatting based on format.
- RuleConfiguration.cfc
  - Loads JSON configuration (global, rules, ignoreFiles).
  - Discovers and instantiates all rule components under lib/rules/*.cfc; merges config parameters into each rule and builds an enabled rules map.
  - Supports enableOnlyRules([...]) and retrieval of rules grouped by node type.
- CFMLLinter.cfc
  - Core engine: lintFile(path) -> parse AST -> lintAST; lintFolder(path) -> directoryList with pathFilter honoring ignoreFiles.
  - recursiveNodeParser walks AST and runs each enabled rule’s check(node, helper, fileName, fileContent), returning LintResult instances.
  - Output formatters: formatResultsAsText/json/xml/bitbucket/tsc/silent, plus summary generation and gcc/tsc-compatible lines.
- ASTDomHelper.cfc
  - Utilities to query/traverse Lucee AST: getNodesByType, getCFMLTagsByName, getAssignmentsByVariableName, findNodes, etc.
- BaseRule.cfc
  - Abstract base with rule metadata (ruleCode, severity, message, group, parameters, enabled) and helpers to set/get parameters and create LintResult.
- LintResult.cfc
  - Encapsulates a single finding; captures source location, snippet, severity, and supports serialization and message formatting.
- Rules
  - Real example: lib/rules/SQLChecker.cfc (code search and assignment tracing around cfquery/queryExecute; disabled by default, enable via config rules.SQL_CHECK.enabled=true).
  - Additional rules exist under lib/rules/generated and lib/rules/tocheck and are auto-loaded by RuleConfiguration.

Notes for development
- The linter defaults to loading all rule classes found under lib/rules and then toggles enablement via configuration. To run just a subset, prefer rules=RULE1,RULE2 at invocation time for fast iterations.
- For Bitbucket-compatible reports, use format=bitbucket. For editor-friendly diagnostics, format=tsc prints gcc-like lines.
- The ignoreFiles globs are matched against absolute paths using Java NIO PathMatcher with glob:. When patterns don’t match as expected, include **/ at the start of directories you want to ignore.
