#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator
$(
    Write-Verbose $attributes.Count
)
function Get-$Prefix$EntityDisplayName {
    [CmdletBinding()]

    param(

        [Parameter(Position=0, ParameterSetName="Guid", Mandatory=`$true)]
        [guid]`$$($EntityDisplayName)Id,

        $(
            $Pos = 0
            foreach ($attribute in $Attributes){
                #. ".\Templates\Get\$($attribute.AttributeType)Parameter.ps1"
                switch ($attribute.AttributeType){

                    "string" {
                        "`n`t[Parameter(Position=$Pos, ParameterSetName=`"Query`")]"
                        "`n`t[string]`$$($Attribute.DisplayName),`n"
                    }

                    "picklist" {
                        "`n`t[ValidateSet("
                        ($Attribute.Options.Values | ForEach-Object {
                                "`"$_`""
                            }) -join ","
                        ")]"
                        "`n`t[Parameter(Position=$Pos, ParameterSetName=`"Query`")]"
                        "`n`t[string]`$$($Attribute.DisplayName),`n"
                    }
                }

                #Get-GeneratedAttributeCodeBlock -AttributeOptions $attribute.Options -AttributeLogicalName $attribute.SchemaName -AttributeDisplayName $attribute.DisplayName -AdditionalProperties @{ "Position" = $Pos } -Template (Get-Content -Raw ".\Templates\Get\$($attribute.AttributeType)Parameter.ps1")
                $Pos++
            }
        )

        [Parameter(Position=999, ParameterSetName="Query")]
        [Parameter(Position=999, ParameterSetName="Guid")]
        [string[]]`$Fields = "*"
    )

    #Write-Host `$PSCmdlet.ParameterSetName

    switch (`$PSCmdlet.ParameterSetName){

        "Guid" {
            Get-CrmRecord -EntityLogicalName $EntityLogicalName -Id `$$($EntityDisplayName)Id -Fields `$Fields
        }

        default {
            
            #Superslow filtering mechanism. To be replaced with a FetchXML-generated version.
            if (`$Fields -ne "*"){
            `$AdditionalFieldsToGet = @()
            
             $(
                foreach ($attribute in $attributes) {
                   #. ".\Templates\Get\AddAttribute.ps1"
                   #Get-GeneratedAttributeCodeBlock -AttributeLogicalName $attribute.SchemaName -AttributeDisplayName $attribute.DisplayName -Template (Get-Content -Raw ".\Templates\Get\AddAttribute.ps1")
                  
                   @"
                    if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){
                        `$AdditionalFieldsToGet += "$($Attribute.SchemaName.ToLower())"
                    }
"@
                    
                }
                
            )

                `$Fields = (`$Fields + `$AdditionalFieldsToGet) | Select-Object -Unique
                Write-Verbose (`$Fields -join " ")

            }

            
            `$Records = (Get-CrmRecords -EntityLogicalName $EntityLogicalName -Fields `$Fields -AllRows).CrmRecords

            Write-Verbose "`$(`$Records.Count) found"

            $(
                foreach ($attribute in $attributes) {
                   @"
                    if (![string]::IsNullOrEmpty(`$$($Attribute.DisplayName))){
                        `$records = `$records | Where-Object $($Attribute.SchemaName.ToLower()) -eq `$$($Attribute.DisplayName)
                    }
"@
                    #Get-GeneratedAttributeCodeBlock -AttributeOptions $attribute.Options -AttributeLogicalName $attribute.SchemaName -AttributeDisplayName $attribute.DisplayName -Template (Get-Content -Raw ".\Templates\Get\$($attribute.AttributeType)Filter.ps1")
                    #. ".\Templates\Get\$($attribute.AttributeType)Filter.ps1"
                }
                
            )

            Write-Verbose "Filtered to `$(`$Records.Count) found"

            Write-Output `$Records
        }

    }
    
}