$ModuleRootDir = "..\XrmFunctionGenerator"
. "$ModuleRootDir\Invoke-Template.ps1"
. "$ModuleRootDir\Get-FetchXml.ps1"

Describe "Generate-XrmFunction" {

    $conditions = [pscustomobject]@{
        "Attribute" = "name"
        "Operator"  = "eq"
        "Value" = "Testaccount"
    },
    @{
        "Attribute" = "customertypecode"
        "Operator"  = "eq"
        "Value" = 1
    }

    Context "Generating" {
    
        It "Generates valid xml" {
            [xml](Get-FetchXml)
        }

        It "Entity is added" {
            $fetch = [xml](Get-FetchXml -EntityLogicalName "account")
            $fetch.fetch.entity.name | Should Be "account"
        }

        It "Conditions are added" {
            $fetch = [xml](Get-FetchXml -Conditions $conditions)
            $fetch.fetch.entity.filter.condition.attribute[0]  | Should Be "name"
            $fetch.fetch.entity.filter.condition.attribute[1]  | Should Be "customertypecode"
        }

        It "Operators are added" {
            $fetch = [xml](Get-FetchXml -Conditions $conditions)
            $fetch.fetch.entity.filter.condition.operator[0]  | Should Be "eq"
            $fetch.fetch.entity.filter.condition.operator[1]  | Should Be "eq"
        }

        It "Values are added" {
            $fetch = [xml](Get-FetchXml -Conditions $conditions)
            $fetch.fetch.entity.filter.condition.value[0]  | Should Be "TestAccount"
            $fetch.fetch.entity.filter.condition.value[1]  | Should Be 1
        }
    }

}