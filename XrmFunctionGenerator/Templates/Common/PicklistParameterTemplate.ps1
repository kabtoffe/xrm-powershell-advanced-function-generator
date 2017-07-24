[ValidateSet($(($Options.Values | ForEach-Object { "`"$_`"" }) -join ","))]
[Parameter(Position=$Pos, ParameterSetName="Common")]
[string]`$$($DisplayName),

$(
$Pos++
if ($DisplayName -ne $SchemaName){
        "[alias(`"$($SchemaName)`")]"

}
)
[ValidateSet($($Options.Keys -join ","))]
[Parameter(Position=$Pos, ParameterSetName="Common")]
[int]`$$($DisplayName)Value,