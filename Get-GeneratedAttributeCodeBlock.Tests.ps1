$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-GeneratedAttributeCodeBlock" {
    It "Can be called" {
        Get-GeneratedAttributeCodeBlock -AttributeLogicalName "test" -AttributeDisplayName "Test" -Template "`"`""
    }

    It "Can use a template" {
        $result = Get-GeneratedAttributeCodeBlock -Template "`"Test`""
        $result | Should Be "Test"
    }

    It "Can use DisplayName in template" {
        $result = Get-GeneratedAttributeCodeBlock -AttributeDisplayName "TestDisplayName" -Template "`"`$AttributeDisplayName`""
        $result | Should Be "TestDisplayName"
    }

    It "Can use LogicalName in template" {
        $result = Get-GeneratedAttributeCodeBlock -AttributeLogicalName "TestLogicalName" -Template "`"`$AttributeLogicalName`""
        $result | Should Be "TestLogicalName"
    }

    It "Can use Description in template" {
        $result = Get-GeneratedAttributeCodeBlock -AttributeDescription "Description" -Template "`"`$AttributeDescription`""
        $result | Should Be "Description"
    }

    It "Can use all three in template" {
        $result = Get-GeneratedAttributeCodeBlock -AttributeLogicalName "LogicalName" -AttributeDisplayName "DisplayName" -AttributeDescription "Description" -Template "`"`$AttributeDescription;`$AttributeLogicalName;`$AttributeDisplayName`""
        $result | Should Be "Description;LogicalName;DisplayName"
    }

    It "Using additional properties work" {
        $result = Get-GeneratedAttributeCodeBlock -AdditionalProperties @{ "CustomProperty" = "Random" }  -Template "`"`$CustomProperty`""
        $result | Should Be "Random"
    }
}
