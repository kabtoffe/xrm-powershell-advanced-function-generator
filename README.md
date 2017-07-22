# xrm-powershell-advanced-function-generator
> A code generator to create advanced functions to wrap Microsoft.Xrm.Data.PowerShell -module cmdlets.

The idea is to generate poweruser tools for use with Dynamics 365 Customer Engagement (CRM). The cmdlets that the Microsoft.Xrm.Data.PowerShell-module provides are fine for static scripts but not for "day-to-day" stuff as the are quite verbose. This project is all about generating easy to use commands that "just work". You can obviously use these in your scripts as well.

Right now strings, picklists and lookups are supported with more to come. Check the test file to see examples on how to call the generator and how to use resulting functions. There are templates for Get, New, Set and Remove -verbs. Eg. generating all four for Account would result in these functions:
- Get-XrmAccount
- New-XrmAccount
- Set-XrmAccount
- Remove-XrmAccount

To get a nice ordered attribute list to use with this you should probably do it in Excel. But you can use the Xrm.Data-cmdlets and crm metadata like this if you like:
```
$Attributes = Get-CrmEntityAttributes -EntityLogicalName account |
    Where-Object { "picklist","string","lookup" -contains $_.AttributeType -and $_.DisplayName.UserLocalizedLabel.Label -ne $null } |
    Select-Object @{
            N = "SchemaName"
            E = { $_.SchemaName.ToLower() }
        },
        @{
            N= "DisplayName"
            E= { 
                
                #Get rid of extra characters
                $DisplayName = $_.DisplayName.UserLocalizedLabel.Label.Replace("/","").Replace("(","").Replace(")","").Replace(":","").Replace("-","")
                $DisplayName = (Get-Culture).TextInfo.ToTitleCase($DisplayName)
                $DisplayName.Replace(" ","")
            }
        },
        AttributeType,
        @{
            N = "TargetEntityLogicalName"
            E = {
                $_.Targets[0]
            }
        },
        @{ 
            "N" = "Options" 
            E = {
                $values = @{}
                $_.OptionSet.Options |
                    ForEach-Object {
                        $values.Add($_.Value,$_.Label.UserLocalizedLabel.Label)
                    }
                $values
            }
        }
 "Get","Set","New","Remove" | ForEach-Object { Invoke-Expression (Get-GeneratedXrmFunction -EntityDisplayName Account -EntityLogicalName account -Attributes $Attributes -Template $_) }
```
