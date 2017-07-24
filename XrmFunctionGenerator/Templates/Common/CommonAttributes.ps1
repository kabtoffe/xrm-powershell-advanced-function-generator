
$Pos = 1

$Padding = "`t`t"

foreach ($attribute in $Attributes){
    
    switch ($attribute.AttributeType){

        default {
            
                Invoke-Template -Template $DefaultParameterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
            
            
            
        }

        "picklist" {
            
            Invoke-Template -Template $PicklistParameterTemplate -TemplateModel $attribute | Add-Indentation -Steps 2
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
    }
    "`n`n "
    $Pos++
}