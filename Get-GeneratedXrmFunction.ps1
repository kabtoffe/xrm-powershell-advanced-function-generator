function Get-GeneratedXrmFunction {
    [CmdletBinding()]

    param(
        
        [string]$EntityDisplayName,
        
        [string]$EntityLogicalName,

        [object[]]$Attributes,

        [string]$Template

    )

    $TemplateToInvoke = "@`"`n" + $Template + "`n`"@"

    Invoke-Expression $TemplateToInvoke
}
