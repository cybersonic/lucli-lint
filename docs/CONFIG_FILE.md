# LINT Config file

The config file should be named `.lucli-lint.json` and it should be placed in the root of your project or wherever you will run `lucli lint` from.
```
{
    "global" :{
        "outputFormat": "text",
        "showRuleNames": true,
        "exitOnError": false,
        "maxIssues": 0 
    }
    "rules":{
        "SQL_CHECK": {
            "enabled": true,
            "extensions": ".cfm,cfc"
        },
    }
    "ignoreFiles": [
        "**/vendor/**",
        "**/dependencies/**"
    ]
}
```

## Global Settings
TBD

## Rules
Each rule can be enabled or disabled and can have specific settings. The available rules and their settings can be found in the [rules documentation](../RULES.md).

All rules have the `enabled` setting which can be set to `true` or `false`.

Other paramerters are rule specific. Please refer to the individual rule documentation for more details.


## Ignore Files
You can specify files or directories to ignore using glob patterns. Any file matching these patterns will be skipped during linting.
Remeber that we are looking at the full path rather than a relative path, so use `**/` to match any directory level.


