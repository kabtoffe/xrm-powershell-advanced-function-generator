﻿function Get-GeneratedXrmFunction {
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
    }

    $TemplateData = @{
        "EntityDisplayName" = $EntityDisplayName
        "EntityLogicalName" = $EntityLogicalName
        "Attributes" = ($Attributes | Where-Object { $AttributeToParameterTypeMapping.Keys -contains $_.AttributeType})
        "Prefix" = $Prefix
        "TemplateType" = $Template
        "DefaultParameterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\DefaultParameterTemplate.ps1")
        "PicklistParameterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistParameterTemplate.ps1")
        "LookupParameterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\LookupParameterTemplate.ps1")
        "LookupParameterTemplateGet" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\LookupParameterTemplateGet.ps1")
        "PicklistValueTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistValueTemplate.ps1")
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
            $TemplateToUse = Get-Content -Raw "$PSScriptRoot\Templates\Set\MainSetTemplate.ps1" 
        }

        "New" {
            $TemplateToUse = Get-Content -Raw "$PSScriptRoot\Templates\New\MainNewTemplate.ps1" 
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
