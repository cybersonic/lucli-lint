component {

    this.name = "lucli_lint_tests";
    // Module.cfc extends modules.BaseModule; point /modules at parent of module root so BaseModule resolves
    this.mappings["/modules"] = getDirectoryFromPath(getCurrentTemplatePath()) & "../../";

    function onError(exception, eventName) {
        dump(exception);
    }
}
