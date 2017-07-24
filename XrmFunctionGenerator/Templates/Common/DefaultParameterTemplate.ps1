$(if ($DisplayName -ne $SchemaName){
    "[alias(`"$SchemaName`")]"
})
[Parameter(Position=$Pos, ParameterSetName=`"Common`", ValueFromPipelineByPropertyName=`$$AttributeValueFromPipeline)]
[$($AttributeToParameterTypeMapping[$AttributeType])]`$$DisplayName,