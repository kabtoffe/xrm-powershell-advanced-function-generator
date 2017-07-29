Describe "Testing PicklistValueTemplate"{
    . "$PSScriptRoot\CommonParameters.ps1"
    $CurrentDir = (Get-Location).Path
    $ModuleRootDir = $CurrentDir.Substring(0,$CurrentDir.IndexOf("xrm-powershell-advanced-function-generator")+42)+"\XrmFunctionGenerator"
    $ParameterTemplate =  Get-Content "$ModuleRootDir\Templates\Common\LookupParameterTemplate.ps1" -Raw
    $ParameterTemplate += "`n`n"
    $ParameterTemplate += Get-Content "$ModuleRootDir\Templates\Common\LookupParameterTemplateGet.ps1" -Raw

    $DisplayName = "PrimaryCustomer"
    $SchemaName = "new_primarycustomer"
    $Pos = 1
    $AttributeType = "lookup"
    $AttributeValueFromPipeline = $true

    $TestGuid = [Guid]::NewGuid()

    It "Template runs" {
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$PrimaryCustomerId"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
    }

    It "Return the guid" {
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$PrimaryCustomerId"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
        Invoke-TestFunction -PrimaryCustomerId $TestGuid | Should Be $TestGuid
    }

    It "Should be able to call Get with lookup record name" {
        $TemplateType = "Get"
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$PrimaryCustomer"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
        (get-command Invoke-TestFunction).Parameters.ContainsKey("PrimaryCustomer") | Should Be $true
        Invoke-TestFunction -PrimaryCustomer "Firstname Lastname" | Should Be "Firstname Lastname"
     }


}