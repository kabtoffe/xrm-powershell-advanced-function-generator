if (`$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)") -or `$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)Value")){
    `$conditions += [pscustomobject]@{
        "Attribute" = "$($SchemaName.ToLower())"
        "Operator" = "eq"
        "Value" = `$$($DisplayName)Value
    }
}