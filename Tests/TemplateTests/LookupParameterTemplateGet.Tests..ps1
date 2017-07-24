Describe "Testing PicklistValueTemplateGet"{
    . ".\CommonParameters.ps1"
    $ParameterTemplate = Get-Content -Raw "$ModuleRootDir\Templates\Common\LookupParameterTemplateGet.ps1"
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

     It "Should be able to call Get with lookup record name" {
        $ParameterCodeBlock = Invoke-Expression ("@`"`n" + $ParameterTemplate + "`n`"@")
        $MainCodeBlock = "`$PrimaryCustomer"
        Invoke-Expression (Invoke-Expression ("@`"`n" + $TestTemplate + "`n`"@"))
        (get-command Invoke-TestFunction).Parameters.ContainsKey("PrimaryContact") | Should Be $false
        Invoke-TestFunction -PrimaryCustomer "Firstname Lastname" | Should Be "Firstname Lastname"
     }


}