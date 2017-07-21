<fetch version='1.0' output-format='xml-platform' mapping='logical' distinct='false' count='1'>
    <entity name='$EntityLogicalName'>
        
        $(
            if ($Fields -eq $null -or $Fields.Count -eq 0 -or $Fields -contains "*"){
                "<all-attributes />"
            }
            else{
                $Fields | ForEach-Object {
                    "<attribute name='$_'/> "
                }
            }
        )
        "<order attribute='createdon' descending='true' />"
        <filter type='and'>
        $(
            foreach ($condition in $conditions){
                "<condition attribute='$($condition.Attribute)' operator='$($condition.Operator)' value='$($condition.Value)' />"
            }
        
        )
        </filter>
    </entity>

</fetch>