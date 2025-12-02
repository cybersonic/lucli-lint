/**
 * ComplexitySample.cfc
 *
 * Functions of increasing cyclomatic complexity to exercise SimpleComplexityChecker.
 */
component {
/**/    
    // Complexity ~1
    function simpleNoBranch() {
        var x = 1;
        var y = x + 1;
        return y;
    }

    // Complexity ~2 (1 base + 1 if)
    function singleIf(required numeric x) {
        var y = x;
        if (x GT 10) {
            y = x * 2;
        }
        return y;
    }

    // Complexity ~3 (1 base + 1 if + 1 else if)
    function ifElseIf(required numeric x) {
        var result = "small";
        if (x GT 10) {
            result = "medium";
        } else if (x GT 20) {
            result = "large";
        }
        return result;
    }

    // Complexity ~4 (1 base + 1 if + 1 loop + 1 logical operator)
    function loopAndCondition(required array items) {
        var total = 0;
        for (var i = 1; i LTE arrayLen(items); i++) {
            if (isNumeric(items[i]) AND items[i] GT 0) {
                total += items[i];
            }
        }
        return total;
    }

    // Complexity ~5-6 using switch/case style
    function switchLike(required string status) {
        var message = "";
        switch (status) {
            case "NEW":
                message = "New";
                break;
            case "PENDING":
                message = "Pending";
                break;
            case "DONE":
                message = "Done";
                break;
            default:
                message = "Unknown";
        }
        return message;
    }

    // Higher complexity: nested ifs, multiple logical operators, loop, ternary
    function highComplexity(required struct data) {
        var score = 0;

        if (structKeyExists(data, "age") AND data.age GT 18) {
            score++;
        }

        if (structKeyExists(data, "country") AND (data.country EQ "US" OR data.country EQ "UK")) {
            score++;
        }

        // // Loop with inner decision
        for (var i = 1; i LTE (arrayLen(data.tags ?: [])); i++) {
            if (data.tags[i] EQ "vip" OR data.tags[i] EQ "priority") {
                score++;
            }
        }

        // Ternary-like conditional expression
        var flag = (score GT 2) ? true : false;

        return flag;
    }

}
