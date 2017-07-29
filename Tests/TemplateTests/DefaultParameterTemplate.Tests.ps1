Describe "Testing DefaultValueTempate"{
    . "$PSScriptRoot\CommonParameters.ps1"
    $CurrentDir = (Get-Location).Path
    $ModuleRootDir = $CurrentDir.Substring(0,$CurrentDir.IndexOf("xrm-powershell-advanced-function-generator")+42)+"\XrmFunctionGenerator"
    $ParameterTemplate =  Get-Content "$ModuleRootDir\Templates\Common\DefaultParameterTemplate.ps1" -Raw
    $DisplayName = "Name"
    $SchemaName = "name"
    
    $AttributeType = "string"
    $AttributeValueFromPipeline = $true    

    It "Template runs" {
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$Name"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
    }

    It "Return a value" {
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$Name"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
        Invoke-TestFunction -Name "A name" | Should Be "A name"
    }
}