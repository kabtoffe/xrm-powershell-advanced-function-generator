foreach ($attribute in $Attributes | Where-Object AttributeType -eq "Picklist"){
    @"

    if (`$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)") -and `$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)Value"))    {
        throw "Provide only one of $($attribute.DisplayName) and $($attribute.DisplayName)Value not both"
    }

    switch (`$$($attribute.DisplayName)){
        
        $(
            foreach ($OptionKey in $Attribute.Options.Keys){
                "`n`t`t`"$($Attribute.Options[$OptionKey])`" { `$$($attribute.DisplayName)Value = $OptionKey }"
            }
        )
        `tdefault {
            #Let's not change potentially provided specific value
        }
    }
"@
}
foreach ($attribute in $Attributes){

    switch ($attribute.AttributeType){

        "Picklist"{
            "`n`tif (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName)Value)){"
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