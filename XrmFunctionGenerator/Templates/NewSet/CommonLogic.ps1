foreach ($attribute in $Attributes){
    $ValueTemplate = Get-Variable -Name "$($Attribute.AttributeType)ValueTemplate" -ValueOnly -ErrorAction SilentlyContinue
    Invoke-Template -Template $ValueTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
    "`n"
}
"`n"

foreach ($attribute in $Attributes){

    $AdderTemplate = Get-Variable -Name "$($Attribute.AttributeType)AdderTemplate" -ValueOnly -ErrorAction SilentlyContinue
    if ($AdderTemplate -eq $null){
        $AdderTemplate = $DefaultAdderTemplate
    }

    Invoke-Template -Template $AdderTemplate -TemplateModel $attribute | Add-Indentation -Step 2
    "`n"
}