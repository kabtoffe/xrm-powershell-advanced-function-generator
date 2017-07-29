
$Pos = 1

$Padding = "`t`t"

foreach ($attribute in $Attributes){
    $ParameterTemplate = Get-Variable -Name "$($Attribute.AttributeType)ParameterTemplate" -ValueOnly -ErrorAction SilentlyContinue
    if ($ParameterTemplate -eq $null){
        $ParameterTemplate = $DefaultParameterTemplate
    }

    if ($TemplateType -eq "Get" -and $attribute.AttributeType -eq "Lookup") {
        Invoke-Template -Template $LookupParameterTemplateGet -TemplateModel $attribute  | Add-Indentation -Steps 2
        "`n`n "
        $Pos++
    }

    Invoke-Template -Template $ParameterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2

    <#switch ($attribute.AttributeType){

       
        default {
            
                Invoke-Template -Template $DefaultParameterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2

        }

        "picklist" {
            
            Invoke-Template -Template $PicklistParameterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
            $Pos++
        }

        "boolean" {
            
            Invoke-Template -Template $BooleanParameterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
            $Pos++
        }

        "lookup" {
           
            if ($TemplateType -eq "Get") {
                Invoke-Template -Template $LookupParameterTemplateGet -TemplateModel $attribute  | Add-Indentation -Steps 2
                
                "`n`n "
                $Pos++
            }
            
            
            Invoke-Template -Template $LookupParameterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
            
           
        }
    }#>
    "`n`n "
    $Pos++
}