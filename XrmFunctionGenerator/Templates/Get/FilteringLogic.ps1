foreach ($attribute in $attributes) {
    switch ($attribute.AttributeType){

"picklist" {
    @"
        
            if (`$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)") -or `$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)Value")){
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
        
            if (`$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)")){
                `$conditions += [pscustomobject]@{
                    "Attribute" = "$($Attribute.SchemaName.ToLower())"
                    "Operator" = "eq"
                    "Value" = `$$($Attribute.DisplayName)
                }
            }

"@
        }

        "DateTime" {
    @"
        
            if (`$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)")){
                `$conditions += [pscustomobject]@{
                    "Attribute" = "$($Attribute.SchemaName.ToLower())"
                    "Operator" = "on"
                    "Value" = `$$($Attribute.DisplayName)
                }
            }

"@
        }

"lookup" {
    @"
        
            if (`$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)")){
                `$conditions += [pscustomobject]@{
                    "Attribute" = "$($Attribute.SchemaName.ToLower())name"
                    "Operator" = "eq"
                    "Value" = `$$($Attribute.DisplayName)
                }
            }

            if (`$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)Id")){
                `$conditions += [pscustomobject]@{
                    "Attribute" = "$($Attribute.SchemaName.ToLower())"
                    "Operator" = "eq"
                    "Value" = `$$($Attribute.DisplayName)Id
                }
            }

"@
        }
    }
}