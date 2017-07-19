<fetch version='1.0' output-format='xml-platform' mapping='logical' distinct='false' count='1'>
    <entity name='$EntityLogicalName'>
        <all-attributes />
        <order attribute='createdon' descending='true' />
        <filter type='and'>
        $(
            foreach ($condition in $conditions){
                "<condition attribute='$($condition.Attribute)' operator='$($condition.Operator)' value='$($condition.Value)' />"
            }
        
        )
        </filter>
    </entity>

</fetch>