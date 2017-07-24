function Get-GeneratedXrmFunction {
    [CmdletBinding()]

    param(
        
        [string]$EntityDisplayName,
        
        [string]$EntityLogicalName,

        [pscustomobject[]]$Attributes,

        [string]$Template,

        [string]$Prefix="Xrm"

    )

    $AttributeToParameterTypeMapping = @{
        "string" = "string"
        "Double" = "double"
        "DateTime" = "DateTime"
        "Lookup" = "string"
        "Picklist" = "string"
        "Money" = "double"
        "Integer" = "int"
        "Boolean" = "bool"
        "Memo" = "string"
    }

    $TemplateData = @{
        "EntityDisplayName" = $EntityDisplayName
        "EntityLogicalName" = $EntityLogicalName
        "Attributes" = ($Attributes | Where-Object { $AttributeToParameterTypeMapping.Keys -contains $_.AttributeType})
        "Prefix" = $Prefix
        "TemplateType" = $Template
        "DefaultParameterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\DefaultParameterTemplate.ps1")
        "PicklistParameterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistParameterTemplate.ps1")
        "BooleanParameterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\BooleanParameterTemplate.ps1")
        "LookupParameterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\LookupParameterTemplate.ps1")
        "LookupParameterTemplateGet" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\LookupParameterTemplateGet.ps1")
        "PicklistBooleanValueTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistBooleanValueTemplate.ps1")
        "PicklistAdderTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\NewSet\PicklistAdderTemplate.ps1")
        "BooleanAdderTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\NewSet\BooleanAdderTemplate.ps1")
        "DefaultAdderTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\NewSet\DefaultAdderTemplate.ps1")
        "LookupAdderTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\NewSet\LookupAdderTemplate.ps1")
        "MoneyAdderTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\NewSet\MoneyAdderTemplate.ps1")
        "DefaultFilterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Get\DefaultFilterTemplate.ps1")
        "PicklistFilterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Get\PicklistFilterTemplate.ps1")
        "DateTimeFilterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Get\DateTimeFilterTemplate.ps1")
        "LookupFilterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Get\LookupFilterTemplate.ps1")
    }

    #Write-Verbose $TemplateData.ContainsKey("Attributes")

    foreach ($attribute in $attributes) {
        $otherattributes = $attributes | Where-Object SchemaName -ne $attribute.SchemaName
        if ($otherattributes.DisplayName -contains $attribute.SchemaName){
            throw "parameter $($attribute.DisplayName) $($attribute.SchemaName) alias will conflict with another parameter display name"
        }
    }

    $TemplateToUse = ""

    switch ($Template){

        "Get" {
            $TemplateToUse = Get-Content -Raw "$PSScriptRoot\Templates\Get\MainGetTemplate.ps1" 
        }

        "Set" {
            $TemplateToUse = Get-Content -Raw "$PSScriptRoot\Templates\NewSet\MainSetTemplate.ps1" 
        }

        "New" {
            $TemplateToUse = Get-Content -Raw "$PSScriptRoot\Templates\NewSet\MainNewTemplate.ps1" 
        }

        "Remove" {
            $TemplateToUse = Get-Content -Raw "$PSScriptRoot\Templates\Remove\MainRemoveTemplate.ps1" 
        }

        default {
            $TemplateToUse = $Template
        }
    }

    Invoke-Template -Template $TemplateToUse -TemplateData $TemplateData
}
