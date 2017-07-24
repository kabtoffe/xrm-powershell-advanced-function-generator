if (`$MyInvocation.BoundParameters.ContainsKey(`"$($DisplayName)`")){
    `$FieldsToSend.Add("$($SchemaName.ToLower())",`$$($DisplayName))
}