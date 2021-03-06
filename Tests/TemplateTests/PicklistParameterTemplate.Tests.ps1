Describe "Testing PicklistValueTemplate"{
    . "$PSScriptRoot\CommonParameters.ps1"
    $CurrentDir = (Get-Location).Path
    $ModuleRootDir = $CurrentDir.Substring(0,$CurrentDir.IndexOf("xrm-powershell-advanced-function-generator")+42)+"\XrmFunctionGenerator"
    $ParameterTemplate =  Get-Content "$ModuleRootDir\Templates\Common\PicklistParameterTemplate.ps1" -Raw

    $AttributeToParameterTypeMapping = @{
        "string" = "string"
        "Double" = "double"
        "DateTime" = "DateTime"
        "Lookup" = "string"
        "Picklist" = "string"
        "Money" = "double"
    }
    $DisplayName = "CustomerType"
    $SchemaName = "customertypecode"
    $Options = @{
        1 = "Competitor"
        3 = "Customer"
    }
    $Pos = 1
    $AttributeType = "picklist"
    $AttributeValueFromPipeline = $true    

    It "Template runs" {
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$Name"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
    }

    It "Return the picklist label" {
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$CustomerType"
        Write-Host Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
        Invoke-TestFunction -CustomerType "Customer" | Should Be "Customer"
    }

    It "Return the picklist value" {
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$CustomerTypeValue"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
        Invoke-TestFunction -CustomerTypeValue 3 | Should Be 3
    }
}