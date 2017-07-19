$Pos = 1
foreach ($attribute in $Attributes){
    
    switch ($attribute.AttributeType){

        "string" {
            if ($Attribute.DisplayName -ne $Attribute.SchemaName){
                "`t[alias(`"$($Attribute.SchemaName)`")]"
            }
            "`n`t[Parameter(Position=$Pos, ParameterSetName=`"Guid`")]"
            "`n`t[string]`$$($Attribute.DisplayName),`n"
        }

        "picklist" {
            "`n`t[ValidateSet("
            ($Attribute.Options.Values | ForEach-Object {
                    "`"$_`""
                }) -join ","
            ")]"
            "`n`t[Parameter(Position=$Pos, ParameterSetName=`"Guid`")]"
            "`n`t[string]`$$($Attribute.DisplayName),`n"
            "`n "
            
            "`n`t[ValidateSet("
            $Pos++
            $Attribute.Options.Keys -join ","
            ")]"
            "`n`t[Parameter(Position=$Pos, ParameterSetName=`"Guid`")]"
            if ($Attribute.DisplayName -ne $Attribute.SchemaName){
                "`n`t[alias(`"$($Attribute.SchemaName)`")]"
            }
            "`n`t[int]`$$($Attribute.DisplayName)Value,`n"
        }
    }

    $Pos++
}