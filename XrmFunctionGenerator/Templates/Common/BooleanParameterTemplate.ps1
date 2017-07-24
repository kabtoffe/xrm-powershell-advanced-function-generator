[ValidateSet($(($Options.Values | ForEach-Object { "`"$_`"" }) -join ","))]
[Parameter(Position=$Pos, ParameterSetName="Common")]
[string]`$$($DisplayName),

$(
$Pos++
if ($DisplayName -ne $SchemaName){
        "[alias(`"$($SchemaName)`")]"

}
)
[Parameter(Position=$Pos, ParameterSetName="Common")]
[bool]`$$($DisplayName)Value,