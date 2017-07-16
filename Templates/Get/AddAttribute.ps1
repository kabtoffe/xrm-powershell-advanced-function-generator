@"
if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){
    `$AdditionalFieldsToGet += "$($Attribute.SchemaName)"
}
"@