#Requires -modules Microsoft.Xrm.Data.PowerShell
#Generated using https://github.com/kabtoffe/xrm-powershell-advanced-function-generator

function Set-XrmAccount {
    [CmdletBinding()]

    param(

        
        [Parameter(Position=0, ParameterSetName="Common", Mandatory=$true, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true)]
        [guid]$AccountId,
        		
		[Parameter(Position=1, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[string]$Name, 

  		[alias("telephone1")]
		[Parameter(Position=2, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[string]$Phone, 

  		[ValidateSet("Competitor","Customer")]
		[Parameter(Position=3, ParameterSetName="Common")]
		[string]$CustomerType,
		
		[alias("customertypecode")]
		[ValidateSet(1,3)]
		[Parameter(Position=4, ParameterSetName="Common")]
		[int]$CustomerTypeValue, 

  		[alias("new_primarycontact")]
		[Parameter(Position=4, ParameterSetName="Common")]
		[guid]$PrimaryContactId, 

  		[alias("somedouble")]
		[Parameter(Position=5, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[double]$ADoubleValue, 

  		[alias("somedate")]
		[Parameter(Position=6, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[DateTime]$ADateValue, 

  		[alias("somemoney")]
		[Parameter(Position=7, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[double]$AMoneyValue, 

 
        [Parameter(Position=999, ParameterSetName="Common")]
        [hashtable]$Fields=@{}
        
    )

    BEGIN {

        $FieldsToSend = $Fields

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
 
 		if ($MyInvocation.BoundParameters.ContainsKey("Name")){
		    $FieldsToSend.Add("name",$Name)
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("Phone")){
		    $FieldsToSend.Add("telephone1",$Phone)
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("CustomerType") -or $MyInvocation.BoundParameters.ContainsKey("CustomerTypeValue")){
		    $FieldsToSend.Add("customertypecode",(New-CrmOptionSetValue -Value $CustomerTypeValue))
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("PrimaryContactId")){
		    $FieldsToSend.Add("new_primarycontact",(New-CrmEntityReference -EntityLogicalName contact -Id $PrimaryContactId))
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("ADoubleValue")){
		    $FieldsToSend.Add("somedouble",$ADoubleValue)
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("ADateValue")){
		    $FieldsToSend.Add("somedate",$ADateValue)
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("AMoneyValue")){
		    $FieldsToSend.Add("somemoney",(New-CrmMoney -Value $AMoneyValue))
		} 

    }

    PROCESS {

        Set-CrmRecord -EntityLogicalName account -Id $AccountId -Fields $FieldsToSend

    }
}
