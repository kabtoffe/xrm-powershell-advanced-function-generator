function Get-CrudFunctions{
    param(

        $EntityLogicalName,

        $EntityDisplayName,

        $Prefix = "Xrm"
    )

$InvalidCharactersInParameterName = "/","(",")",":",",","-","+","%"
$Attributes = Get-CrmEntityAttributes -EntityLogicalName $EntityLogicalName |
    Where-Object { "picklist","string","lookup","double","datetime","money","integer","bigint","decimal","boolean","memo" -contains $_.AttributeType -and $_.DisplayName.UserLocalizedLabel.Label -ne $null } |
    Select-Object @{
            N = "SchemaName"
            E = { $_.SchemaName.ToLower() }
        },
        @{
            N= "DisplayName"
            E= { 
                $DisplayName = $_.DisplayName.UserLocalizedLabel.Label
                $InvalidCharactersInParameterName | ForEach-Object { $DisplayName = $DisplayName.Replace($_,"") }
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
                if ($_.AttributeType -eq "Picklist"){
                
                    $_.OptionSet.Options |
                    ForEach-Object {
                        $values.Add($_.Value,$_.Label.UserLocalizedLabel.Label)
                    }
                }
                elseif ($_.AttributeType -eq "Boolean") {
                    $values.Add("`$true",$_.OptionSet.TrueOption.Label.UserLocalizedLabel.Label)
                    $values.Add("`$false",$_.OptionSet.FalseOption.Label.UserLocalizedLabel.Label)
                }
                $values
            }
        }
     "Get","Set","New","Remove" | ForEach-Object { Get-GeneratedXrmFunction -EntityDisplayName $EntityDisplayName -EntityLogicalName $EntityLogicalName -Prefix $Prefix -Attributes $Attributes -Template $_ }
}
Get-CrudFunctions -EntityLogicalName account -EntityDisplayName Account | ForEach-Object { Invoke-Expression $_ }