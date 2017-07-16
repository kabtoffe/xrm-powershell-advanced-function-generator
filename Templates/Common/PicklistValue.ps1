@"

        `$$($attribute.DisplayName)Value = `$null

        switch (`$$($attribute.DisplayName)){
            $(
                foreach ($OptionKey in $Attribute.Options.Keys){
                    "`n`t`t`"$($Attribute.Options[$OptionKey])`" { `$$($attribute.DisplayName)Value = $OptionKey }"
                }
            )
            `tdefault {}
        }
"@