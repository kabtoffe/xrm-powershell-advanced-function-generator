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
            "name" = "Testaccount1"
    }
    $account2 =  [pscustomobject]@{
        "accountid" = $AccountGuid2
        "customertypecode" = "Competitor"
    }

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

    Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName "Account" -EntityLogicalName "account" -Attributes $attributes -Prefix "Xrm" -Template (Get-Content .\Templates\Get\MainGetTemplate.ps1 -Raw))


    It "Can be called using Guid" {
        $result = Get-XrmAccount -AccountId $AccountGuid1
        $result.accountid | Should Be $AccountGuid1
        $Global:GetCrmRecordCalled | Should Be 1
    }

    It "Can be called without using Guid" {
        $result = Get-XrmAccount
        $result.Count | Should Be 2
        $result[1].accountid | Should Be $AccountGuid2
        $Global:GetCrmRecordsCalled | Should Be 1
    }
     

    It "Can be called with valid parameter"{
        $result = Get-XrmAccount -CustomerType "Competitor"
        $result.accountid | Should Be $AccountGuid2
        $Global:GetCrmRecordsCalled | Should Be 2
    }

    It "Can query without including field to query in Fields" {
        $result = Get-XrmAccount -Name "Testaccount1" -Fields "customertypecode"
        $result.accountid | Should Be $AccountGuid1
        $Global:GetCrmRecordsCalled | Should Be 3
    }

    #It "Can't be called with invalid parameter"{
    #    $result = Get-XrmAccount -CustomerType "Foo" -Name "Laa" | Should Throw "ParameterBindingValidationException"
    #    $Global:GetCrmRecordsCalled | Should Be 2
    #}


}
