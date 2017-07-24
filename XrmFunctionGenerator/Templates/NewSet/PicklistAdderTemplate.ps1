if (`$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)") -or `$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)Value")){
    `$FieldsToSend.Add("$($SchemaName.ToLower())",(New-CrmOptionSetValue -Value `$$($DisplayName)Value))
}