function Get-GeneratedXrmFunction {
    [CmdletBinding()]

    param(
        
        [string]$EntityDisplayName,
        
        [string]$EntityLogicalName,

        [pscustomobject[]]$Attributes,

        [string]$Template,

        [string]$Prefix="Xrm",

        [hashtable]$AdditionalProperties=@{}

    )

    $AdditionalProperties.Add("EntityDisplayName",$EntityDisplayName)
    $AdditionalProperties.Add("EntityLogicalName",$EntityLogicalName)
    $AdditionalProperties.Add("Attributes",[pscustomobject[]]$Attributes)
    $AdditionalProperties.Add("Prefix",$Prefix)
    $AdditionalProperties.Add("TemplateType",$Template)

    Write-Verbose $AdditionalProperties.ContainsKey("Attributes")

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

    Invoke-Template -Template $TemplateToUse -TemplateData $AdditionalProperties
}
