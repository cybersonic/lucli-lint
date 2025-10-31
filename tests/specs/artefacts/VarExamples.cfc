component {
    function noLocalmode(){
        missingVar = "This variable is not declared with var, so it is missing var scope";

        if(true){
            surpriseVar = "This variable is also missing var scope inside an if block";
        }
    }
    function passingWithVar(){
        var hasVar = "This variable is declared with var, so it has local scope";

        if(true){
            var hasVar = "This variable is also declared with var inside an if block again!";
        }
    }
    function withLocalMode() localmode="yes"{
        localmodeNoVar = "This variable is not declared with var, so it is missing var scope";
        localmodeNovar &= "Another variable without var declaration in localmode";
        if(true){
            irishHelloVar = "The opposite of an irish goodbye! This var appears all of the sudden inside the code ";
        }
    }
}