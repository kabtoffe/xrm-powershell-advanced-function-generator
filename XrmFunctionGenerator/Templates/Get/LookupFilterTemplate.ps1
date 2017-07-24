if (`$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)")){
    `$conditions += [pscustomobject]@{
        "Attribute" = "$($SchemaName.ToLower())name"
        "Operator" = "eq"
        "Value" = `$$($DisplayName)
    }
}

if (`$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)Id")){
    `$conditions += [pscustomobject]@{
        "Attribute" = "$($SchemaName.ToLower())"
        "Operator" = "eq"
        "Value" = `$$($DisplayName)Id
    }
}