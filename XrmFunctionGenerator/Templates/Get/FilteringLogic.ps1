foreach ($attribute in $attributes) {
    switch ($attribute.AttributeType){

        "picklist" {
            Invoke-Template -Template $PicklistFilterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
        }

        default {
            Invoke-Template -Template $DefaultFilterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
        }

        "DateTime" {
            Invoke-Template -Template $DateTimeFilterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
        }

        "lookup" {
            Invoke-Template -Template $LookupFilterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
        }
    }
    "`n"
}