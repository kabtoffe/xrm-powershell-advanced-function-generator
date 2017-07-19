foreach ($attribute in $attributes) {
    @"
    if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){
        `$AdditionalFieldsToGet += "$($Attribute.SchemaName.ToLower())"
    }
"@
    
}