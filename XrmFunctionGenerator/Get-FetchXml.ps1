function Get-FetchXml{

    param(

        $EntityLogicalName,

        [object[]]$Conditions,

        [string[]]$Fields
    )

    Invoke-Template `
        -Template (Get-Content -Raw "$ModuleRootDir\Templates\Get\FetchXml.ps1") `
        -TemplateData @{
            "Conditions" = $Conditions
            "EntityLogicalName" = $EntityLogicalName
            "Fields" = $Fields
        }

}