@"
if (![string]::IsNullOrEmpty(`$$AttributeDisplayName)){
    `$records = `$records | Where-Object $AttributeLogicalName -eq `$$AttributeDisplayName
}
"@