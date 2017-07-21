foreach ($attribute in $attributes) {
    switch ($attribute.AttributeType){

"picklist" {
    @"
    if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName)) -or `$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)Value")){
        `$conditions += [pscustomobject]@{
            "Attribute" = "$($Attribute.SchemaName.ToLower())"
            "Operator" = "eq"
            "Value" = `$$($Attribute.DisplayName)Value
        }
    }
"@
}

        default {
    @"
    if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){
        `$conditions += [pscustomobject]@{
            "Attribute" = "$($Attribute.SchemaName.ToLower())"
            "Operator" = "eq"
            "Value" = `$$($Attribute.DisplayName)
        }
    }
"@
        }
    }
}