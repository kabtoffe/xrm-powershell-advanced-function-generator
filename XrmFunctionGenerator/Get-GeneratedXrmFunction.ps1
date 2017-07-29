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
        "PicklistBooleanValueTemplate" = (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistBooleanValueTemplate.ps1")
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
