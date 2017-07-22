

foreach ($attribute in $Attributes | Where-Object AttributeType -eq "Picklist"){
    @"

$($Padding)if (`$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)") -and `$MyInvocation.BoundParameters.ContainsKey("$($attribute.DisplayName)Value"))    {
$Padding    throw "Provide only one of $($attribute.DisplayName) and $($attribute.DisplayName)Value not both"
$Padding}

$($Padding)switch (`$$($attribute.DisplayName)){
                $(
                    foreach ($OptionKey in $Attribute.Options.Keys){
                        "`n$Padding`t`"$($Attribute.Options[$OptionKey])`" { `$$($attribute.DisplayName)Value = $OptionKey }"
                    }
                )
$($Padding)     default {
$($Padding)         #Let's not change potentially provided specific value
$($Padding)     }
$($Padding) 
$($Padding)}

"@
}