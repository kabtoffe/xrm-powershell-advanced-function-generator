"`n`t [ValidateSet("
($AttributeOptions.Values | ForEach-Object {
        "`"$_`""
    }) -join ","
")]"
"`n`t[Parameter(Position=$Position, ParameterSetName=`"Query`")]"
"`n`t[string]`$$AttributeDisplayName,`n"