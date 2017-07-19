Import-Module ..\XrmFunctionGenerator\XrmFunctionGenerator.psd1 -Force

Describe "Invoke-Template" {
    It "Returns template" {
        $result = Invoke-Template -Template "TestTemplate"
        $result | Should Be "TestTemplate"
    }

    It "Returns template using data" {
        $result = Invoke-Template -Template "`$TestTemplate" -TemplateData @{ "TestTemplate" = "TestData" }
        $result | Should Be "TestData"
    }
}
