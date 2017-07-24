if (`$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)Id")){
    `$FieldsToSend.Add(`"$($SchemaName.ToLower())",(New-CrmEntityReference -EntityLogicalName $($TargetEntityLogicalName) -Id `$$($DisplayName)Id))
}