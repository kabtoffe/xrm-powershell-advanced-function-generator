
$Pos = 1

$Padding = "`t`t"

foreach ($attribute in $Attributes){
    
    switch ($attribute.AttributeType){

        default {
            
            if ($Attribute.DisplayName -ne $Attribute.SchemaName){
                "$Padding[alias(`"$($Attribute.SchemaName)`")]"
            }
            "`n$Padding[Parameter(Position=$Pos, ParameterSetName=`"Common`", ValueFromPipelineByPropertyName=`$$AttributeValueFromPipeline)]"
            "`n$Padding[$($AttributeToParameterTypeMapping[$attribute.AttributeType])]`$$($Attribute.DisplayName),`n"
            "`n"
            
        }

        "picklist" {
            "$Padding[ValidateSet("
            ($Attribute.Options.Values | ForEach-Object {
                    "`"$_`""
                }) -join ","
            ")]"
            "`n$Padding[Parameter(Position=$Pos, ParameterSetName=`"Common`")]"
            "`n$Padding[string]`$$($Attribute.DisplayName),`n"
            "`n "
            
            if ($Attribute.DisplayName -ne $Attribute.SchemaName){
                "$Padding[alias(`"$($Attribute.SchemaName)`")]"
            }
            "`n $Padding[ValidateSet("
            $Pos++
            $Attribute.Options.Keys -join ","
            ")]"
            "`n$Padding[Parameter(Position=$Pos, ParameterSetName=`"Common`")]"
            "`n$Padding[int]`$$($Attribute.DisplayName)Value,`n"
        }

        "lookup" {
           
            if ($TemplateType -eq "Get") {
                "`n$Padding[Parameter(Position=$Pos, ParameterSetName=`"Common`")]"
                "`n$Padding[string]`$$($Attribute.DisplayName),`n"
                
                $Pos++
            }
            "`n "
            
            if ($Attribute.DisplayName -ne $Attribute.SchemaName){
                "$Padding[alias(`"$($Attribute.SchemaName)`")]"
            }
            "`n $Padding[Parameter(Position=$Pos, ParameterSetName=`"Common`")]"
            "`n$Padding[guid]`$$($Attribute.DisplayName)Id,`n"
            "`n"
        }
    }

    $Pos++
}