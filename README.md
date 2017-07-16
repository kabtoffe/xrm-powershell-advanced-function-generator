# xrm-powershell-advanced-function-generator
Code generator to create advanced functions to wrap Microsoft.Xrm.Data.PowerShell -module cmdlets.

To get a nice ordered attribute list to use with this you should probably do it in Excel. But you can use the Xrm.Data-cmdlets like this if you like:
```
$Attributes = Get-CrmEntityAttributes -EntityLogicalName account |
    Where-Object { "picklist","string" -contains $_.AttributeType } |
    Select-Object SchemaName,
        @{
            "N"="DisplayName";
            E={ $_.DisplayName.UserLocalizedLabel.Label.Replace(" ","").Replace("/","").Replace("(","").Replace(")","").Replace(":","").Replace("-","") }
        },
        AttributeType,
        @{ "N" = "Options" ; E = {
            $values = @{}
            $_.OptionSet.Options |
                ForEach-Object {
                    $values.Add($_.Value,$_.Label.UserLocalizedLabel.Label)
                }
            $values }
        } |
        Where-Object DisplayName -ne $null
```


Right now only strings and picklists are supported. Check the test file to see an example how to call the generator.