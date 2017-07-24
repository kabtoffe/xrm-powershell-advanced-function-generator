foreach ($attribute in $Attributes | Where-Object { "Picklist","Boolean" -contains $_.AttributeType }){
    Invoke-Template -Template $PicklistBooleanValueTemplate -TemplateModel $attribute | Add-Indentation -Step 2
    "`n"
}
"`n"

foreach ($attribute in $Attributes){

    switch ($attribute.AttributeType){

        "Picklist"{
           Invoke-Template -Template $PicklistAdderTemplate -TemplateModel $attribute | Add-Indentation -Step 2
        }

        "Boolean" {
            Invoke-Template -Template $BooleanAdderTemplate -TemplateModel $attribute | Add-Indentation -Step 2
        }

        "Money"{
            Invoke-Template -Template $MoneyAdderTemplate -TemplateModel $attribute | Add-Indentation -Step 2
        }

        "lookup" {
            Invoke-Template -Template $LookupAdderTemplate -TemplateModel $attribute | Add-Indentation -Step 2
        }

        default {
            Invoke-Template -Template $DefaultAdderTemplate -TemplateModel $attribute | Add-Indentation -Step 2
        }
            
    }
    "`n"
}