$(
if ("$($DisplayName)Id" -ne $SchemaName){
    "[alias(`"$($SchemaName)`")]"
}
)
[Parameter(Position=$Pos, ParameterSetName="Common")]
[guid]`$$($DisplayName)Id,