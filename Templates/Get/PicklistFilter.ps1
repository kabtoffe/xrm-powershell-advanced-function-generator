@"
if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){
    `$records = `$records | Where-Object $($Attribute.SchemaName) -eq `$$($Attribute.DisplayName)
}
"@