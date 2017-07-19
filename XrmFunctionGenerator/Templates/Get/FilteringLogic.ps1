foreach ($attribute in $attributes) {
    @"
    if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){
        `$records = `$records | Where-Object $($Attribute.SchemaName.ToLower()) -eq `$$($Attribute.DisplayName)
    }
"@
}