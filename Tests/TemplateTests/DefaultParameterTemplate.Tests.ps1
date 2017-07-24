Describe "Testing DefaultValueTempate"{
    . ".\CommonParameters.ps1"
    $ParameterTemplate = Get-Content -Raw "$ModuleRootDir\Templates\Common\DefaultParameterTemplate.ps1"
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