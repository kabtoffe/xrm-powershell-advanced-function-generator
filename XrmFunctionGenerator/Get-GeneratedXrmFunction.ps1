function Get-XrmFunctionCode {
<#
.SYNOPSIS

Generates advanced functions for use with Dynamics 365 Customer Engagement (CRM).

.DESCRIPTION

A function that uses templates and metadata to generate ready to use advanced functions to wrap around Microsoft.Xrm.Data.PowerShell cmdlets. There are templates that create functions for New, Get, Set and Remove operations. The function parameters are generated from an metadata array that contains all the entity attributes that should be usable directly. One can also supply attributes and values via the Fields-parameter.

The function follow the pattern Verb-PrefixEntityname pattern. So eg. for account using a prefix of Xrm, it generates the following functions: New-XrmAccount, Get-XrmAccount, Set-XrmAccount and Remove-XrmAccount.

.PARAMETER EntityDisplayName

The noun for the resulting command. Eg. Account

.PARAMETER EntityLogicalName

The logical (system) name for the entity the command uses. Eg. accouny

.PARAMETER Attributes

An array of objects that contain the attributes to generate parameters for. Should have properties for SchemaName, DisplayName, AttributeType, TargetEntityName (lookups), Options (picklists and boolean). See examples.

.EXAMPLE

Get-XrmFunctionCode -EntityDisplayName account -EntityLogicalName account -Template Get -Attributes [PSCustomObject]@{
"SchemaName" = "name"
"DisplayName" = "Name"
"AttributeType" = "string"
} > Get-XrmAccount.ps1

#>
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
        "BigInt" = "bigint"
        "Decimal" = "decimal"
        "Boolean" = "bool"
        "Memo" = "string"
    }

    

    $TemplateData = @{
        "EntityDisplayName" = $EntityDisplayName
        "EntityLogicalName" = $EntityLogicalName
        "Attributes" = ($Attributes | Where-Object { $AttributeToParameterTypeMapping.Keys -contains $_.AttributeType})
        "Prefix" = $Prefix
        "TemplateType" = $Template
        "LookupParameterTemplateGet" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\LookupParameterTemplateGet.ps1")
        "PicklistValueTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistBooleanValueTemplate.ps1")
        "BooleanValueTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistBooleanValueTemplate.ps1")
        "BooleanFilterTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Get\PicklistFilterTemplate.ps1")
    }

    Write-Verbose "Adding Parameter-templates"
    Get-ChildItem -Path "$ModuleRootDir\Templates\Common\" -Filter "*ParameterTemplate.ps1" | ForEach-Object {
        Write-Verbose "Adding $($_.Name)"
        $TemplateData.Add(
            $_.Name.Replace(".ps1",""),
            (Get-Content -Path $_.FullName -Raw)
        )
    }

    Write-Verbose "Adding Filter-templates"
    Get-ChildItem -Path "$ModuleRootDir\Templates\Get\" -Filter "*FilterTemplate.ps1" | ForEach-Object {
        Write-Verbose "Adding $($_.Name)"
        $TemplateData.Add(
            $_.Name.Replace(".ps1",""),
            (Get-Content -Path $_.FullName -Raw)
        )
    }

    Write-Verbose "Adding Adder-templates"
    Get-ChildItem -Path "$ModuleRootDir\Templates\NewSet\" -Filter "*AdderTemplate.ps1" | ForEach-Object {
        Write-Verbose "Adding $($_.Name)"
        $TemplateData.Add(
            $_.Name.Replace(".ps1",""),
            (Get-Content -Path $_.FullName -Raw)
        )
    }

    #Write-Verbose $TemplateData.ContainsKey("Attributes")

    foreach ($attribute in $attributes) {
        $otherattributes = $attributes | Where-Object SchemaName -ne $attribute.SchemaName
        if ($otherattributes.DisplayName -contains $attribute.SchemaName){
            throw "parameter $($attribute.DisplayName) $($attribute.SchemaName) alias will conflict with another parameter display name"
        }
        if ($otherattributes.DisplayName -contains $attribute.DisplayName){
            throw "duplicate DisplayName: $($attribute.DisplayName) $($attribute.SchemaName)"
        }
    }

    $TemplatesAvailable = @{}
    Get-ChildItem -Path "$ModuleRootDir\Templates" -Recurse -Filter "Main*Template.ps1" |
        ForEach-Object {
            $TemplatesAvailable.Add(
                $_.Name.Substring(4,$_.Name.IndexOf("Template.ps1")-4),
                (Get-Content -Raw -LiteralPath $_.FullName)
            )
        }

    $TemplateToUse = $Template

    if ($TemplatesAvailable.ContainsKey($Template)){
        $TemplateToUse = $TemplatesAvailable[$Template]
    }    

    Invoke-Template -Template $TemplateToUse -TemplateData $TemplateData
}
