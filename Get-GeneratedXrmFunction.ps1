. .\Invoke-Template.ps1

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

    Write-Verbose $AdditionalProperties.ContainsKey("Attributes")

    Invoke-Template -Template $Template -TemplateData $AdditionalProperties
}
