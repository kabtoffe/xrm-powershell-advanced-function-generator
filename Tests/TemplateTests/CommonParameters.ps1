$TestTemplate = Get-Content -Raw "$PSScriptRoot\TestTemplate.ps1"

$AttributeToParameterTypeMapping = @{
    "string" = "string"
    "Double" = "double"
    "DateTime" = "DateTime"
    "Lookup" = "string"
    "Picklist" = "string"
    "Money" = "double"
}
$Pos = 1