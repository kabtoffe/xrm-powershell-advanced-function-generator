$Attributes = Get-CrmEntityAttributes -EntityLogicalName account |
    Where-Object { "picklist","string","lookup","double","datetime","money","integer","bigint","decimal","boolean","memo" -contains $_.AttributeType -and $_.DisplayName.UserLocalizedLabel.Label -ne $null } |
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
        @{
            N = "AttributeType"
            E = { $_.AttributeType.ToString()  }
        },
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