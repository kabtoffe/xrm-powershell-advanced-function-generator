foreach ($attribute in $Attributes | Where-Object AttributeType -eq "Picklist"){
    Invoke-Template -Template (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistValueTemplate.ps1") -TemplateModel $attribute
}

foreach ($attribute in $Attributes){

    switch ($attribute.AttributeType){

        "Picklist"{
            "`n$($Padding)if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName)) -or `$MyInvocation.BoundParameters.ContainsKey(`"$($attribute.DisplayName)Value`")){"
            "`n$Padding$Padding`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",(New-CrmOptionSetValue -Value `$$($attribute.DisplayName)Value))"
            "`n$Padding}"
        }

        "Money"{
            "`n$($Padding)if (`$MyInvocation.BoundParameters.ContainsKey(`"$($attribute.DisplayName)`")){"
            "`n$Padding`t`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",(New-CrmMoney -Value `$$($attribute.DisplayName)))"
            "`n$Padding}"
        }

        "lookup" {
            "`n$($Padding)if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName)Id)){"
            "`n$Padding`t`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",(New-CrmEntityReference -EntityLogicalName $($attribute.TargetEntityLogicalName) -Id `$$($attribute.DisplayName)Id))"
            "`n$Padding}"
        }

        default {
            "`n$($Padding)if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){"
            "`n$Padding`t`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",`$$($attribute.DisplayName))"
            "`n$Padding}"
        }
    }
}