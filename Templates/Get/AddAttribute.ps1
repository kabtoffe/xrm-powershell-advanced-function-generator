@"
if (![string]::IsNullOrEmpty(`$$AttributeDisplayName)){
    `$AdditionalFieldsToGet += "$AttributeLogicalName"
}
"@