
$Pos = 1

$Padding = "`t`t"

foreach ($attribute in $Attributes){
    
    switch ($attribute.AttributeType){

        default {
            
            Invoke-Template -Template (Get-Content -Raw "$ModuleRootDir\Templates\Common\DefaultParameterTemplate.ps1") -TemplateModel $attribute 
            
        }

        "picklist" {
            Invoke-Template -Template (Get-Content -Raw "$ModuleRootDir\Templates\Common\PicklistParameterTemplate.ps1") -TemplateModel $attribute 
        }

        "lookup" {
           
            if ($TemplateType -eq "Get") {
                Invoke-Template -Template (Get-Content -Raw "$ModuleRootDir\Templates\Common\LookupParameterTemplateGet.ps1") -TemplateModel $attribute 
                $Pos++
            }
            
            Invoke-Template -Template (Get-Content -Raw "$ModuleRootDir\Templates\Common\LookupParameterTemplate.ps1") -TemplateModel $attribute 
           
        }
    }

    $Pos++
}