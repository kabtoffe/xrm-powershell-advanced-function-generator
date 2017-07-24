function Invoke-Template {
    [CmdletBinding()]

    param(

        [string]$Template,

        [hashtable]$TemplateData,

        [pscustomobject]$TemplateModel
    )

    #Add template data as variables
    foreach ($key in $TemplateData.Keys){
        Invoke-Expression "`$$key = `$TemplateData[`$key]"
    }

    if ($TemplateModel -ne $null){
        #Add template dataobject properties as variables
        foreach ($key in $TemplateModel | Get-Member -MemberType NoteProperty){
            Invoke-Expression "`$$($key.Name) = `$TemplateModel.$($key.Name)"
        }
    }

    $TemplateExpression = "@`"`n" + $Template + "`n`"@"
    Invoke-Expression $TemplateExpression
}
