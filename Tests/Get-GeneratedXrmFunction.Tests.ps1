Import-Module ..\XrmFunctionGenerator\XrmFunctionGenerator.psd1 -Force

Describe "Generate-XrmFunction" {

    $Global:GetCrmRecordCalled = 0
    $Global:GetCrmRecordsCalled = 0

    $AccountGuid1 = [guid]"065973af-c822-4593-b740-70b3d7e345d3"
    $AccountGuid2 = [guid]"065973af-c822-4593-b740-70b3d7e345d3"

    $attributes = [PSCustomObject]@{
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
        "SchemaName" = "new_primarycontact"
        "DisplayName" = "PrimaryContact"
        "AttributeType" = "Lookup"
        "TargetEntityLogicalName" = "contact"
    }
    

    $account1 =  [pscustomobject]@{
            "accountid" = $AccountGuid1
            "name" = "Testaccount1"
    }
    $account2 =  [pscustomobject]@{
        "accountid" = $AccountGuid2
        "customertypecode" = "Competitor"
    }

    $ContactId = [Guid]::NewGuid()

    Context "Get-template"{
        Mock Get-CrmRecord {
            $Global:GetCrmRecordCalled++
            if ($Fields -eq "*"){
                $account1
            }
            else{
                $account1| Select-Object ($Fields + "accountid")
            }
        }

        Mock Get-CrmRecords {
            $Global:GetCrmRecordsCalled++
            
            [psobject]@{
                "CrmRecords" = if ($Fields -ne "*") { ($account1,$account2) | Select-Object ($Fields + "accountid") } else { ($account1,$account2) }
            }
            
        }

        Mock Get-CrmRecordsByFetch {
            [psobject]@{ "CrmRecords" = $Fetch }
        }

        Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName "Account" -EntityLogicalName "account" -Attributes $attributes -Prefix "Xrm" -Template "Get")


        It "Can be called using Guid" {
            $result = Get-XrmAccount -AccountId $AccountGuid1
            $result.accountid | Should Be $AccountGuid1
            $Global:GetCrmRecordCalled | Should Be 1
        }

        

        It "Can be called using query" {
            $result = [xml](Get-XrmAccount -Name "Testaccount")
            $result.fetch.entity.name | Should be "account"
            $result.fetch.entity.filter.condition.attribute  | Should Be "name"
            $result.fetch.entity.filter.condition.operator  | Should Be "eq"
            $result.fetch.entity.filter.condition.value  | Should Be "Testaccount"
        }

        It "Can be called using multiple conditions" {
            $result = [xml](Get-XrmAccount -Name "Testaccount" -Phone "911")
            $result.fetch.entity.filter.condition.attribute[0]  | Should Be "name"
            $result.fetch.entity.filter.condition.operator[0]  | Should Be "eq"
            $result.fetch.entity.filter.condition.value[0]  | Should Be "Testaccount"
            $result.fetch.entity.filter.condition.attribute[1]  | Should Be "telephone1"
            $result.fetch.entity.filter.condition.operator[1]  | Should Be "eq"
            $result.fetch.entity.filter.condition.value[1]  | Should Be "911"
        }

        It "Can be called using picklist condition" {
            $result = [xml](Get-XrmAccount -CustomerType Competitor)
            $result.fetch.entity.filter.condition.attribute  | Should Be "customertypecode"
            $result.fetch.entity.filter.condition.operator  | Should Be "eq"
            $result.fetch.entity.filter.condition.value  | Should Be 1
        }

        It "Can be called using lookup with name condition" {
            $result = [xml](Get-XrmAccount -PrimaryContact "Firstname Lastname")
            $result.fetch.entity.filter.condition.attribute  | Should Be "new_primarycontactname"
            $result.fetch.entity.filter.condition.operator  | Should Be "eq"
            $result.fetch.entity.filter.condition.value  | Should Be "Firstname Lastname"
        }

        It "Can be called using lookup with id condition" {
            $result = [xml](Get-XrmAccount -PrimaryContactId $ContactId)
            $result.fetch.entity.filter.condition.attribute  | Should Be "new_primarycontact"
            $result.fetch.entity.filter.condition.operator  | Should Be "eq"
            $result.fetch.entity.filter.condition.value  | Should Be $ContactId.ToString()
        }



        It "If Fields is not provided get all fields" {
            $result = [xml](Get-XrmAccount -CustomerType Competitor)
            $result.fetch.entity | Get-Member -Name all-attributes | Should Not Be $null
        }

        It "If Fields is * get all fields" {
            $result = [xml](Get-XrmAccount -CustomerType Competitor -Fields '*')
            $result.fetch.entity | Get-Member -Name all-attributes | Should Not Be $null
        }

        It "If fields are provided only get those" {
            $result = [xml](Get-XrmAccount -CustomerType Competitor -Fields "name","customertypecode")
            $result.fetch.entity | Get-Member -Name all-attributes | Should Be $null
            $result.fetch.entity.attribute.name -join ";" | Should Be "name;customertypecode"
        }

        It "Can be called without using Guid" -Skip {
            $result = Get-XrmAccount
            $result.Count | Should Be 2
            $result[1].accountid | Should Be $AccountGuid2
            $Global:GetCrmRecordsCalled | Should Be 1
        }
        

        It "Can be called with valid parameter" -Skip {
            $result = Get-XrmAccount -CustomerType "Competitor"
            $result.accountid | Should Be $AccountGuid2
            $Global:GetCrmRecordsCalled | Should Be 2
        }

        It "Can query without including field to query in Fields" -Skip {
            $result = Get-XrmAccount -Name "Testaccount1" -Fields "customertypecode"
            $result.accountid | Should Be $AccountGuid1
            $Global:GetCrmRecordsCalled | Should Be 3
        }

        #It "Can't be called with invalid parameter"{
        #    $result = Get-XrmAccount -CustomerType "Foo" -Name "Laa" | Should Throw "ParameterBindingValidationException"
        #    $Global:GetCrmRecordsCalled | Should Be 2
        #}
    }

    Context "Set-template" {
        Mock Set-CrmRecord {
            return $Fields
        }

        Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName "Account" -EntityLogicalName "account" -Attributes $attributes -Prefix "Xrm" -Template "Set")

        It "Can be called" {
            Set-XrmAccount -AccountId $AccountGuid1
        }

        It "String parameters work" {
            $result = Set-XrmAccount -AccountId $AccountGuid1 -Name "NewTestAccount"
            $result["name"] | Should Be "NewTestAccount"
        }

        It "Should not be able to call Set with lookup record name" {
            { Set-XrmAccount -AccountId $AccountGuid1 -PrimaryContact "Firstname Lastname" } | Should Throw
        }

        It "Picklist parameters work" {
            $result = Set-XrmAccount -AccountId $AccountGuid1 -CustomerType Competitor
            $result["customertypecode"].Value | Should Be 1
        }

        It "Takes pipeline input" {
            $result = $account1 | Set-XrmAccount -CustomerType Customer
            $result["customertypecode"].Value | Should Be 3
        }

        It "Can be called via pipeline with two objects" {
            $result = $account1,$account2 | Set-XrmAccount -CustomerType Customer  | ForEach-Object {
                $_["customertypecode"].Value | Should Be 3
            }
        }

        It "Can be used with splatting" {
            $propertiesToSet = @{
                "CustomerType" = "Customer"
                "Name" = "NewName"
            }

            $account1,$account2 | Set-XrmAccount @propertiesToSet | ForEach-Object {
                $_["customertypecode"].Value | Should Be 3
                $_["name"] | Should Be "NewName"
            }
        }

        It "Can provide custom properties via Fields" {
            $result = $account1 | Set-XrmAccount -Fields @{ "name" = "NewCustomName" }
            $result["name"] | Should Be "NewCustomName"
        }

        It "Can use picklist value as parameter" {
            $result = Set-XrmAccount -CustomerTypeValue 3 -AccountId $AccountGuid1
            $result["customertypecode"].Value | Should Be 3
        }

        It "Should fail when picklist value provided by two parameters" {
           { Set-XrmAccount -CustomerTypeValue 3 -CustomerType "Competitor" -AccountId $AccountGuid1 } | Should Throw
        }

        It "Can use string schemaname as parameter (alias)" {
            $result = Set-XrmAccount -AccountId $AccountGuid1 -telephone1 "911"
            $result["telephone1"] | Should Be "911"
        }

        It "Can use picklist (value) schemaname as parameter (alias)" {
            $result = Set-XrmAccount -AccountId $AccountGuid1 -customertypecode 1
            $result["customertypecode"].Value | Should Be 1
        }

        It "Providing field via both parameters and Fields should fail"  {
            { $account1 | Set-XrmAccount -Name "OtherCustomName" -Fields @{ "name" = "NewCustomName" } } | Should Throw
        }

        Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName "NotAccount" -EntityLogicalName "account" -Attributes $attributes -Prefix "Xrm" -Template "Set")

        It "Can be called via pipeline when logicalname doesn't match display name" {
            $account1,$account2 | Set-XrmNotAccount -CustomerType Customer | ForEach-Object {
                $_["customertypecode"].Value | Should Be 3
            }
        }



    }

    Context "New-template" {
        Mock New-CrmRecord {
            return $Fields
        }

        Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName "Account" -EntityLogicalName "account" -Attributes $attributes -Prefix "Xrm" -Template "New")

        It "Can be called" {
            New-XrmAccount
        }

        It "String parameters work" {
            $result = New-XrmAccount  -Name "NewTestAccount"
            $result["name"] | Should Be "NewTestAccount"
        }

        It "Picklist parameters work" {
            $result = New-XrmAccount -CustomerType Customer
            $result["customertypecode"].Value | Should Be 3
        }

        It "Can accept new object from pipeline" {
            $result = [pscustomobject]@{ "Name" = "New account"  } | New-XrmAccount
            $result["name"] | Should Be "New account"
        }


        It "Can accept two new object from pipeline" {
            $result = [pscustomobject]@{ "Name" = "New account"  },[pscustomobject]@{ "Name" = "New account2"  } | New-XrmAccount
            $result[0]["name"] | Should Be "New account"
        }

    }

    Context "Remove-template" {
        Mock Remove-CrmRecord {
            return "$EntityLogicalName-$Id"
        }

        Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName "Account" -EntityLogicalName "account" -Attributes $attributes -Prefix "Xrm" -Template "Remove")

        It "Can be called and calls Remove-CrmRecord with entitylogicalname and id" {
            $result = Remove-XrmAccount -AccountId $AccountGuid1
            $result | Should Be "account-$AccountGuid1"
        }

        It "Can be called via pipeline with one object" {
            $result = $account1 | Remove-XrmAccount
            $result | Should Be "account-$AccountGuid1"
        }

        It "Can be called via pipeline with two objects" {
            $result = $account1,$account2 | Remove-XrmAccount
            $result[1] | Should Be "account-$AccountGuid2"
        }

        Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName "NotAccount" -EntityLogicalName "account" -Attributes $attributes -Prefix "Xrm" -Template "Remove")

        It "Can be called via pipeline when logicalname doesn't match display name" {
            $result = $account1,$account2 | Remove-XrmNotAccount
            $result[1] | Should Be "account-$AccountGuid2"
        }

    }
}
