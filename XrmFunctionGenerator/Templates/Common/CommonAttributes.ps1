
$Pos = 1

$Padding = "`t`t"

foreach ($attribute in $Attributes){
    
    switch ($attribute.AttributeType){

        default {
            
            Get-IndentedString -Steps 2 -StringToIndent (
                Invoke-Template -Template $DefaultParameterTemplate -TemplateModel $attribute
            )
            
            
        }

        "picklist" {
            Get-IndentedString -Steps 2 -StringToIndent (
                Invoke-Template -Template $PicklistParameterTemplate -TemplateModel $attribute
            )
        }

        "lookup" {
           
            if ($TemplateType -eq "Get") {
                Get-IndentedString -Steps 2 -StringToIndent (
                    Invoke-Template -Template $LookupParameterTemplateGet -TemplateModel $attribute 
                )
                "`n`n "
                $Pos++
            }
            
            Get-IndentedString -Steps 2 -StringToIndent (
                Invoke-Template -Template $LookupParameterTemplate -TemplateModel $attribute
            )
           
        }
    }
    "`n`n "
    $Pos++
}