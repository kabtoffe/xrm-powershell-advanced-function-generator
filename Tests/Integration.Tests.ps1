
if ($conn -eq $null){
    return "Need to be connected to CRM"
}
Describe "Test function genereration and use against CRM instance" {

    Context "Testing using Account" {
        $Attributes = [PSCustomObject]@{
        "SchemaName" = "name"
        "DisplayName" = "Name"
        "AttributeType" = "string"
    },
    [PSCustomObject]@{
        "SchemaName" = "telephone1"
        "DisplayName" = "Phone"
        "AttributeType" = "string"
    },
    [PSCustomObject]@{
        "SchemaName" = "customertypecode"
        "DisplayName" = "CustomerType"
        "AttributeType" = "Picklist"
        "Options" = @{
            1 = "Competitor"
            3 = "Customer"
        }
    }
    
    "Get","Set","New","Remove" | ForEach-Object { Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName Account -EntityLogicalName account -Attributes $Attributes -Template $_) }
    
    It "Get-XrmAccount exists" {
        Get-Command Get-XrmAccount | Should Not Be $null
    }

    It "Set-XrmAccount exists" {
        Get-Command Set-XrmAccount | Should Not Be $null
    }

    It "New-XrmAccount exists" {
        Get-Command New-XrmAccount | Should Not Be $null
    }

    It "Remove-XrmAccount exists" {
        Get-Command Remove-XrmAccount | Should Not Be $null
    }

    It "Account creation works" {
        $global:AccountId = New-XrmAccount -Name "Testaccount"
    }

    It "Created account exists" {
        $global:AccountRecord = $global:AccountId | Get-XrmAccount -Fields "name"
        $global:AccountRecord.name | Should Be "Testaccount"
    }

    It "Can update phonenumber" {
        $global:AccountId | Set-XrmAccount -Phone "911"
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId
        $global:AccountRecord.telephone1 | Should Be "911"
    }

    It "Can update customertypecode" {
        $global:AccountId | Set-XrmAccount -CustomerType Customer
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId
        $global:AccountRecord.customertypecode_Property.Value.Value | Should Be 3
    }

    It "Can query using customertypecode" {
        $Accounts = Get-XrmAccount -CustomerType Customer -Fields "accountid"
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Removing account works" {
        $global:AccountId | Remove-XrmAccount
        { Get-XrmAccount -AccountId $global:AccountId } | Should Throw "account With Id = $($global:AccountId.ToString()) Does Not Exist"
    }

}

}