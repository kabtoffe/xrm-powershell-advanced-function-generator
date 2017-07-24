if (`$MyInvocation.BoundParameters.ContainsKey("$DisplayName") -and `$MyInvocation.BoundParameters.ContainsKey("$($DisplayName)Value")){
    throw "Provide only one of $DisplayName and $($DisplayName)Value not both"
}

switch (`$$DisplayName){
$(
    foreach ($OptionKey in $Options.Keys){
        "`n`t`"$($Options[$OptionKey])`" { `$$($DisplayName)Value = $OptionKey }"
    }
)
    default {
        #Let's not change potentially provided specific value
    }

}