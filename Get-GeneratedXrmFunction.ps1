function Get-GeneratedXrmFunction {
    [CmdletBinding()]

    param(
        
        [string]$EntityDisplayName,
        
        [string]$EntityLogicalName,

        [object[]]$Attributes,

        [string]$Template,

        [string]$Prefix="Xrm"

    )

    $TemplateToInvoke = "@`"`n" + $Template + "`n`"@"

    Invoke-Expression $TemplateToInvoke
}
