. "$ModuleRootDir\Templates\Common\ParameterValueLogic.ps1"

foreach ($attribute in $Attributes){

    switch ($attribute.AttributeType){

        "Picklist"{
            "`n`tif (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName)) -or `$MyInvocation.BoundParameters.ContainsKey(`"$($attribute.DisplayName)Value`")){"
            "`n`t`t`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",(New-CrmOptionSetValue -Value `$$($attribute.DisplayName)Value))"
            "`n`t}"
        }

        default {
            "`n`tif (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){"
            "`n`t`t`$FieldsToSend.Add(`"$($attribute.SchemaName.ToLower())`",`$$($attribute.DisplayName))"
            "`n`t}"
        }
    }
}