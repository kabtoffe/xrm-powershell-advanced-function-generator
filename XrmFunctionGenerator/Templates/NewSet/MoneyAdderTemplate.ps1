if (`$MyInvocation.BoundParameters.ContainsKey(`"$($DisplayName)`")){
    `$FieldsToSend.Add("$($SchemaName.ToLower())",(New-CrmMoney -Value `$$($DisplayName)))
}