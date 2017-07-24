. ..\XrmFunctionGenerator\Invoke-Template.ps1

Describe "Invoke-Template" {
    It "Returns template" {
        $result = Invoke-Template -Template "TestTemplate"
        $result | Should Be "TestTemplate"
    }

    It "Returns template using data" {
        $result = Invoke-Template -Template "`$TestTemplate" -TemplateData @{ "TestTemplate" = "TestData" }
        $result | Should Be "TestData"
    }

    It "Returns template using data from object" {
        
        $result = Invoke-Template -Template "`$TestTemplateFoo;`$Test2" -TemplateModel (New-Object PsObject -Property @{ "TestTemplateFoo" = "TestData2"; "Test2" = "Foo3" })
        $result | Should Be "TestData2;Foo3"
    }
}
