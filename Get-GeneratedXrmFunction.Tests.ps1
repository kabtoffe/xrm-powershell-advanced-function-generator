$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

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
        "SchemaName" = "customertypecode"
        "DisplayName" = "CustomerType"
        "AttributeType" = "Picklist"
        "Options" = @{
            1 = "Competitor"
            3 = "Customer"
        }
    }
    
    

    $account1 =  [pscustomobject]@{
            "accountid" = $AccountGuid1
    }
    $account2 =  [pscustomobject]@{
        "accountid" = $AccountGuid2
    }

    Mock Get-CrmRecord {
        $Global:GetCrmRecordCalled++
        $account1
    }

    Mock Get-CrmRecords {
        $Global:GetCrmRecordsCalled++
        
        [psobject]@{
            "CrmRecords" = $account1,$account2
        }
        
    }

    Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName "Account" -EntityLogicalName "account" -Attributes $attributes -Template (Get-Content .\Templates\Get\MainGetTemplate.ps1 -Raw))


    It "Can be called using Guid" {
        $result = Get-Account -AccountId ([guid]::Empty)
        $result.accountid | Should Be $AccountGuid1
        $Global:GetCrmRecordCalled | Should Be 1
    }

    It "Can be called without using Guid" {
        $result = Get-Account -Name "Foo"
        $result.Count | Should Be 2
        $result[1].accountid | Should Be $AccountGuid2
        $Global:GetCrmRecordsCalled | Should Be 1
    }

    It "Can be called with valid parameter"{
        $result = Get-Account -CustomerType "Competitor" -Name "Laa"
        $result.Count | Should Be 2
        $result[1].accountid | Should Be $AccountGuid2
        $Global:GetCrmRecordsCalled | Should Be 2
    }

    #It "Can't be called with invalid parameter"{
    #    $result = Get-Account -CustomerType "Foo" -Name "Laa" | Should Throw "ParameterBindingValidationException"
    #    $Global:GetCrmRecordsCalled | Should Be 2
    #}


}
