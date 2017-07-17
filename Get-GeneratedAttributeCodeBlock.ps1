function Get-GeneratedAttributeCodeBlock {
    [CmdletBinding()]
    
    param(

        $AttributeLogicalName,

        $AttributeDisplayName,

        $AttributeDescription,

        [hashtable]$AttributeOptions,

        [hashtable]$AdditionalProperties,

        $Template
    )

    #Add additional properties as variables
    foreach ($key in $AdditionalProperties.Keys){
        Invoke-Expression "`$$key = `"$($AdditionalProperties[$key])`""
    }

    Invoke-Expression $Template
}
