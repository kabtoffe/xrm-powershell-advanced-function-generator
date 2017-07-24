if (`$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)")){
    `$conditions += [pscustomobject]@{
        "Attribute" = "$($SchemaName.ToLower())"
        "Operator" = "eq"
        "Value" = `$$($DisplayName)
    }
}