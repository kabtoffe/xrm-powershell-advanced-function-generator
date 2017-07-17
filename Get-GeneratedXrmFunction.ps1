. .\Get-GeneratedAttributeCodeBlock.ps1 

function Get-GeneratedXrmFunction {
    [CmdletBinding()]

    param(
        
        [string]$EntityDisplayName,
        
        [string]$EntityLogicalName,

        [object[]]$Attributes,

        [string]$Template,

        [string]$Prefix="Xrm",

        [hashtable]$AdditionalProperties

    )

    #Add additional properties as variables
    foreach ($key in $AdditionalProperties.Keys){
        Invoke-Expression "`$$key = `"$($AdditionalProperties[$key])`""
    }

    $TemplateToInvoke = "@`"`n" + $Template + "`n`"@"

    Invoke-Expression $TemplateToInvoke
}
