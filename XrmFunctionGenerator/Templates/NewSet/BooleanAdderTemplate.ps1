if (`$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)") -or `$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)Value")){
    `$FieldsToSend.Add("$($SchemaName.ToLower())",`$$($DisplayName)Value)
}