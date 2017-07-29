foreach ($attribute in $attributes) {
    
    $FilterTemplate = Get-Variable -Name "$($Attribute.AttributeType)FilterTemplate" -ValueOnly -ErrorAction SilentlyContinue
    if ($FilterTemplate -eq $null){
        $FilterTemplate = $DefaultFilterTemplate
    }

    Invoke-Template -Template $FilterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
    "`n"
}