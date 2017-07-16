"`n`t [ValidateSet("
($attribute.Options.Values | ForEach-Object {
        "`"$_`""
    }) -join ","
")]"
"`n`t[Parameter(Position=$Position, ParameterSetName=`"Query`")]"
"`n`t[string]`$$($attribute.DisplayName),`n"