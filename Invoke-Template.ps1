function Invoke-Template {
    [CmdletBinding()]

    param(

        [string]$Template,

        [hashtable]$TemplateData
    )

    #Add template data as variables
    foreach ($key in $TemplateData.Keys){
        Invoke-Expression "`$$key = `$TemplateData[`$key]"
    }

    $TemplateExpression = "@`"`n" + $Template + "`n`"@"
    Invoke-Expression $TemplateExpression
}
