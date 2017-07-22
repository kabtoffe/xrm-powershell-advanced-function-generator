. "$ModuleRootDir\Templates\Common\ParameterValueLogic.ps1"

foreach ($attribute in $Attributes){

    switch ($attribute.AttributeType){

        "Picklist"{
            "`n`tif (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName)) -or `$MyInvocation.BoundParameters.ContainsKey(`"$($attribute.DisplayName)Value`")){"
            "`n`t`t`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",(New-CrmOptionSetValue -Value `$$($attribute.DisplayName)Value))"
            "`n`t}"
        }

        "Money"{
            "`n`tif (`$MyInvocation.BoundParameters.ContainsKey(`"$($attribute.DisplayName)`")){"
            "`n`t`t`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",(New-CrmMoney -Value `$$($attribute.DisplayName)))"
            "`n`t}"
        }

        "lookup" {
            "`n`tif (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName)Id)){"
            "`n`t`t`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",(New-CrmEntityReference -EntityLogicalName $($attribute.TargetEntityLogicalName) -Id `$$($attribute.DisplayName)Id))"
            "`n`t}"
        }

        default {
            "`n`tif (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){"
            "`n`t`t`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",`$$($attribute.DisplayName))"
            "`n`t}"
        }
    }
}