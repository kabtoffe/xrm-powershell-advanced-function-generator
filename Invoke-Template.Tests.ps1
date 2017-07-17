$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

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
