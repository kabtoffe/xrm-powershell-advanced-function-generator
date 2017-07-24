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

  		
		[Parameter(Position=5, ParameterSetName="Common")]
		[guid]$ParentAccountId, 

  		[alias("createdon")]
		[Parameter(Position=6, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[DateTime]$Created, 

  		[alias("address1_latitude")]
		[Parameter(Position=7, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[double]$Latitude, 

  		
		[Parameter(Position=8, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[double]$CreditLimit, 

  		[alias("address1_utcoffset")]
		[Parameter(Position=9, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[int]$UtcOffset, 

 
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
 		if ($MyInvocation.BoundParameters.ContainsKey("ParentAccountId")){
		    $FieldsToSend.Add("parentaccountid",(New-CrmEntityReference -EntityLogicalName account -Id $ParentAccountId))
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("Created")){
		    $FieldsToSend.Add("createdon",$Created)
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("Latitude")){
		    $FieldsToSend.Add("address1_latitude",$Latitude)
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("CreditLimit")){
		    $FieldsToSend.Add("creditlimit",(New-CrmMoney -Value $CreditLimit))
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("UtcOffset")){
		    $FieldsToSend.Add("address1_utcoffset",$UtcOffset)
		} 

    }

    PROCESS {

        Set-CrmRecord -EntityLogicalName account -Id $AccountId -Fields $FieldsToSend

    }
}
