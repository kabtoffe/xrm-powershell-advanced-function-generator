
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
    },
    [PSCustomObject]@{
        "SchemaName" = "parentaccountid"
        "DisplayName" = "ParentAccount"
        "AttributeType" = "Lookup"
        "TargetEntityLogicalName" = "account"
    },
    [PSCustomObject]@{
        "SchemaName" = "createdon"
        "DisplayName" = "Created"
        "AttributeType" = "DateTime"
    },
    [PSCustomObject]@{
        "SchemaName" = "address1_latitude"
        "DisplayName" = "Latitude"
        "AttributeType" = "Double"
    },
    [PSCustomObject]@{
        "SchemaName" = "creditlimit"
        "DisplayName" = "CreditLimit"
        "AttributeType" = "Money"
    },
    [PSCustomObject]@{
        "SchemaName" = "address1_utcoffset"
        "DisplayName" = "UtcOffset"
        "AttributeType" = "Integer"
    },
    [PSCustomObject]@{
        "SchemaName" = "donotemail"
        "DisplayName" = "DoNotEmail"
        "AttributeType" = "Boolean"
        "Options" = @{
            "`$true" = "Denied"
            "`$false" = "Allowed"
        }
    },
    [PSCustomObject]@{
        "SchemaName" = "description"
        "DisplayName" = "Description"
        "AttributeType" = "Memo"
    }

    
    "Get","Set","New","Remove" | ForEach-Object { Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName Account -EntityLogicalName account -Attributes $Attributes -Template $_) }
    "Get","Set","New","Remove" | ForEach-Object { Get-GeneratedXrmFunction -EntityDisplayName Account -EntityLogicalName account -Attributes $Attributes -Template $_ > ".\GeneratedFunctions\$_-XrmAccount.ps1" }
    
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

    It "Can create record" {
        $global:AccountId = New-XrmAccount -Name "Testaccount"
        $global:ParentAccountId = New-XrmAccount -Name "Testaccount2"
    }

    It "Created account exists" {
        $global:AccountRecord = $global:AccountId | Get-XrmAccount -Fields "name"
        $global:AccountRecord.name | Should Be "Testaccount"
    }

    It "Can update string-value" {
        $global:AccountId | Set-XrmAccount -Phone "911"
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId
        $global:AccountRecord.telephone1 | Should Be "911"
    }

    It "Can update picklist-value" {
        $global:AccountId | Set-XrmAccount -CustomerType Customer
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId
        $global:AccountRecord.customertypecode_Property.Value.Value | Should Be 3
    }

    It "Can update lookup-value" {
        $global:AccountId | Set-XrmAccount -ParentAccountId $global:ParentAccountId
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId -Fields "parentaccountid"
        $global:AccountRecord.parentaccountid_Property.Value.Id | Should Be $global:ParentAccountId
    }

    It "Can update Double-value" {
        $global:AccountId | Set-XrmAccount -Latitude 22.0
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId
        $global:AccountRecord.address1_latitude_Property.Value | Should Be 22.00
    }

    It "Can update Money-value" {
        $global:AccountId | Set-XrmAccount -CreditLimit 40000
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId
        $global:AccountRecord.creditlimit_Property.Value.Value | Should Be 40000
    }

     It "Can update Integer-value" {
        $global:AccountId | Set-XrmAccount -UtcOffset 2
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId
        $global:AccountRecord.address1_utcoffset | Should Be 2
    }

    It "Can update Boolean-value" {
        $global:AccountId | Set-XrmAccount -DoNotEmailValue $true
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId
        $global:AccountRecord.donotemail_Property.Value | Should Be $true
    }

    It "Can update Boolean-value with label" {
        $global:AccountId | Set-XrmAccount -DoNotEmail "Denied"
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId -Fields "donotemail"
        $global:AccountRecord.donotemail_Property.Value | Should Be $true
    }

    It "Can update Memo-value" {
        $global:AccountId | Set-XrmAccount -Description "Description"
        $global:AccountRecord = Get-XrmAccount -AccountId $global:AccountId -Fields "description"
        $global:AccountRecord.description | Should Be "Description"
    }

    It "Can update BigInt-value"{

    }

    It "Can update Decimal-value" {

    }

    It "Can update DateTime-value" {

    }

    It "Can query picklist-value" {
        $Accounts = Get-XrmAccount -CustomerType Customer -Fields "accountid"
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can query lookup-value" {
        $Accounts = Get-XrmAccount -ParentAccountId $global:ParentAccountId
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can query Double-value" {
        $Accounts = Get-XrmAccount -Latitude 22.0 -Fields "name"
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can query DateTime-value" {
        $Accounts = Get-XrmAccount -Created ([DateTime]::Today)
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can query Money-value" {
        $Accounts = Get-XrmAccount -CreditLimit 40000 -Fields "name"
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can query Integer-value" {
        $Accounts = Get-XrmAccount -UtcOffset 2 -Fields "name"
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can query Boolean-value" {
        $Accounts = Get-XrmAccount -DoNotEmailValue $true -Fields "name"
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can query Boolean-value with label" {
        $Accounts = Get-XrmAccount -DoNotEmail "Denied" -Fields "accountid"
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can query Memo-value"{
        $Accounts = Get-XrmAccount -Description "Description" -Fields "accountid"
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can query BigInt-value" {

    }

    It "Can query Decimal-value"{

    }

    It "Can query multiple fields" {
        $Accounts = Get-XrmAccount -CreditLimit 40000 -Created ([DateTime]::Today) -Latitude 22.0 -ParentAccountId $global:ParentAccountId -CustomerType Customer
        $Accounts.accountid -contains $global:AccountId | Should Be $true
    }

    It "Can remove record" {
        $global:AccountId | Remove-XrmAccount
        $global:ParentAccountId | Remove-XrmAccount
        { Get-XrmAccount -AccountId $global:AccountId } | Should Throw "account With Id = $($global:AccountId.ToString()) Does Not Exist"
        { Get-XrmAccount -AccountId $global:ParentAccountId } | Should Throw "account With Id = $($global:ParentAccountId.ToString()) Does Not Exist"
    }

}

}