#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator
function Get-XrmAccount {
    [CmdletBinding()]

    param(

        [Parameter(Position=0, ParameterSetName="Guid", Mandatory=$true, ValueFromPipeline=$true)]
        [guid]$AccountId,
        
		[Parameter(Position=1, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)] 
		[string]$Name,
 
 		[alias("telephone1")] 
		[Parameter(Position=2, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)] 
		[string]$Phone,
 
 		[ValidateSet( "Competitor","Customer" )] 
		[Parameter(Position=3, ParameterSetName="Common")] 
		[string]$CustomerType,
 
  		[alias("customertypecode")] 
 		[ValidateSet( 1,3 )] 
		[Parameter(Position=4, ParameterSetName="Common")] 
		[int]$CustomerTypeValue,
 
		[Parameter(Position=5, ParameterSetName="Common")] 
		[string]$PrimaryContact,
 
  		[alias("new_primarycontact")] 
 		[Parameter(Position=6, ParameterSetName="Common")] 
		[guid]$PrimaryContactId,
 
 		[alias("somedouble")] 
		[Parameter(Position=7, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)] 
		[double]$ADoubleValue,
 
 		[alias("somedate")] 
		[Parameter(Position=8, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)] 
		[DateTime]$ADateValue,
 
 		[alias("somemoney")] 
		[Parameter(Position=9, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)] 
		[double]$AMoneyValue,
 

        [Parameter(Position=999, ParameterSetName="Common")]
        [Parameter(Position=999, ParameterSetName="Guid")]
        [string[]]$Fields = "*"
    )

    switch ($PSCmdlet.ParameterSetName){

        "Guid" {
            Get-CrmRecord -EntityLogicalName account -Id $AccountId -Fields $Fields
        }

        default {

            if ($MyInvocation.BoundParameters.ContainsKey("CustomerType") -and $MyInvocation.BoundParameters.ContainsKey("CustomerTypeValue")){
    throw "Provide only one of CustomerType and CustomerTypeValue not both"
}

switch ($CustomerType){
                
	"Competitor" { $CustomerTypeValue = 1 } 
	"Customer" { $CustomerTypeValue = 3 }
    default {
        #Let's not change potentially provided specific value
    }

}

            $conditions = @()

                    
            if ($MyInvocation.BoundParameters.ContainsKey("Name")){
                $conditions += [pscustomobject]@{
                    "Attribute" = "name"
                    "Operator" = "eq"
                    "Value" = $Name
                }
            }
         
            if ($MyInvocation.BoundParameters.ContainsKey("Phone")){
                $conditions += [pscustomobject]@{
                    "Attribute" = "telephone1"
                    "Operator" = "eq"
                    "Value" = $Phone
                }
            }
         
            if ($MyInvocation.BoundParameters.ContainsKey("CustomerType") -or $MyInvocation.BoundParameters.ContainsKey("CustomerTypeValue")){
                $conditions += [pscustomobject]@{
                    "Attribute" = "customertypecode"
                    "Operator" = "eq"
                    "Value" = $CustomerTypeValue
                }
            }
         
            if ($MyInvocation.BoundParameters.ContainsKey("PrimaryContact")){
                $conditions += [pscustomobject]@{
                    "Attribute" = "new_primarycontactname"
                    "Operator" = "eq"
                    "Value" = $PrimaryContact
                }
            }

            if ($MyInvocation.BoundParameters.ContainsKey("PrimaryContactId")){
                $conditions += [pscustomobject]@{
                    "Attribute" = "new_primarycontact"
                    "Operator" = "eq"
                    "Value" = $PrimaryContactId
                }
            }
         
            if ($MyInvocation.BoundParameters.ContainsKey("ADoubleValue")){
                $conditions += [pscustomobject]@{
                    "Attribute" = "somedouble"
                    "Operator" = "eq"
                    "Value" = $ADoubleValue
                }
            }
         
            if ($MyInvocation.BoundParameters.ContainsKey("ADateValue")){
                $conditions += [pscustomobject]@{
                    "Attribute" = "somedate"
                    "Operator" = "on"
                    "Value" = $ADateValue
                }
            }
         
            if ($MyInvocation.BoundParameters.ContainsKey("AMoneyValue")){
                $conditions += [pscustomobject]@{
                    "Attribute" = "somemoney"
                    "Operator" = "eq"
                    "Value" = $AMoneyValue
                }
            }


            $FetchXml = Get-FetchXml -EntityLogicalName account -Conditions $conditions -Fields $Fields

            (Get-CrmRecordsByFetch -Fetch $FetchXml -AllRows).CrmRecords
        }

    }
    
}
