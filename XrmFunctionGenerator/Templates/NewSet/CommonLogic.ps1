foreach ($attribute in $Attributes | Where-Object { "Picklist","Boolean" -contains $_.AttributeType }){
    Invoke-Template -Template $PicklistBooleanValueTemplate -TemplateModel $attribute | Add-Indentation -Step 2
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