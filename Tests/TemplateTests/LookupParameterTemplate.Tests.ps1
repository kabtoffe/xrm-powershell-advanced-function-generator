Describe "Testing PicklistValueTemplate"{
    . ".\CommonParameters.ps1"
    $ParameterTemplate = Get-Content -Raw "$ModuleRootDir\Templates\Common\LookupParameterTemplate.ps1"
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

     It "Should not be able to call Set with lookup record name" {
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$PrimaryCustomerId"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
        (get-command Invoke-TestFunction).Parameters.ContainsKey("PrimaryContact") | Should Be $false
        { Invoke-TestFunction -PrimaryContact "Firstname Lastname" } | Should Throw
     }

     It "Should be able to call Get with lookup record name" {
        $TemplateType = "Get"
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$PrimaryCustomer"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
        (get-command Invoke-TestFunction).Parameters.ContainsKey("PrimaryContact") | Should Be $false
        Invoke-TestFunction -PrimaryContact "Firstname Lastname" | Should Be "Firstname Lastname"
     }


}