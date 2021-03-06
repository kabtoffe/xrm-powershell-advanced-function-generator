#Requires -modules Microsoft.Xrm.Data.PowerShell,XrmFunctionGenerator
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

  		[ValidateSet("Competitor","Customer")]
		[Parameter(Position=3, ParameterSetName="Common")]
		[string]$CustomerType,
		
		[alias("customertypecode")]
		[ValidateSet(1,3)]
		[Parameter(Position=4, ParameterSetName="Common")]
		[int]$CustomerTypeValue, 

  		[Parameter(Position=4, ParameterSetName="Common")]
		[string]$ParentAccount, 

  		
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

  		[ValidateSet("Allowed","Denied")]
		[Parameter(Position=10, ParameterSetName="Common")]
		[string]$DoNotEmail,
		
		
		[Parameter(Position=11, ParameterSetName="Common")]
		[bool]$DoNotEmailValue, 

  		
		[Parameter(Position=11, ParameterSetName="Common", ValueFromPipelineByPropertyName=$False)]
		[string]$Description, 

 
        [Parameter(Position=999, ParameterSetName="Common")]
        [Parameter(Position=999, ParameterSetName="Guid")]
        [string[]]$Fields = "*"
    )

    if ($PSCmdlet.ParameterSetName -eq "Guid"){

            Get-CrmRecord -EntityLogicalName account -Id $AccountId -Fields $Fields
    }

    else {

		 
 		 
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
 		 
 		 
 		 
 		 
 		 
 		if ($MyInvocation.BoundParameters.ContainsKey("DoNotEmail") -and $MyInvocation.BoundParameters.ContainsKey("DoNotEmailValue")){
		    throw "Provide only one of DoNotEmail and DoNotEmailValue not both"
		}
		
		switch ($DoNotEmail){
		
			"Allowed" { $DoNotEmailValue = $false } 
			"Denied" { $DoNotEmailValue = $true }
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
 		if ($MyInvocation.BoundParameters.ContainsKey("ParentAccount")){
		    $conditions += [pscustomobject]@{
		        "Attribute" = "parentaccountidname"
		        "Operator" = "eq"
		        "Value" = $ParentAccount
		    }
		}
		
		if ($MyInvocation.BoundParameters.ContainsKey("ParentAccountId")){
		    $conditions += [pscustomobject]@{
		        "Attribute" = "parentaccountid"
		        "Operator" = "eq"
		        "Value" = $ParentAccountId
		    }
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("Created")){
		    $conditions += [pscustomobject]@{
		        "Attribute" = "createdon"
		        "Operator" = "on"
		        "Value" = $Created
		    }
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("Latitude")){
		    $conditions += [pscustomobject]@{
		        "Attribute" = "address1_latitude"
		        "Operator" = "eq"
		        "Value" = $Latitude
		    }
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("CreditLimit")){
		    $conditions += [pscustomobject]@{
		        "Attribute" = "creditlimit"
		        "Operator" = "eq"
		        "Value" = $CreditLimit
		    }
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("UtcOffset")){
		    $conditions += [pscustomobject]@{
		        "Attribute" = "address1_utcoffset"
		        "Operator" = "eq"
		        "Value" = $UtcOffset
		    }
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("DoNotEmail") -or $MyInvocation.BoundParameters.ContainsKey("DoNotEmailValue")){
		    $conditions += [pscustomobject]@{
		        "Attribute" = "donotemail"
		        "Operator" = "eq"
		        "Value" = $DoNotEmailValue
		    }
		} 
 		if ($MyInvocation.BoundParameters.ContainsKey("Description")){
		    $conditions += [pscustomobject]@{
		        "Attribute" = "description"
		        "Operator" = "eq"
		        "Value" = $Description
		    }
		} 

        
        if ($conditions.Count -gt 0){
            $FetchXml = Get-FetchXml -EntityLogicalName account -Conditions $conditions -Fields $Fields
            (Get-CrmRecordsByFetch -Fetch $FetchXml -AllRows).CrmRecords
        }
        else{
            (Get-CrmRecords -EntityLogicalName account -Fields $Fields).CrmRecords
        }
    }
    
}
