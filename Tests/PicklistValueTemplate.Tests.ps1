$ModuleRootDir = "..\XrmFunctionGenerator"
$Template = "@`"`n" + (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistValueTemplate.ps1") + "`n`"@"

Describe "Testing PicklistValueTemplate"{
    $DisplayName = "CustomerType"
    $Options = @{
        1 = "Customer"
        3 = "Competitor"
    }

    It "Template runs" {
        Invoke-Expression $Template
        Invoke-Expression (Invoke-Expression $Template)
    }

    It "Return valid picklist value" {
        $CustomerType = "Customer"
        Invoke-Expression (Invoke-Expression $Template)
        $CustomerTypeValue | Should Be 1
    }
}