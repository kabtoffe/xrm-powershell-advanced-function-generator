# xrm-powershell-advanced-function-generator
> A code generator to create advanced functions to wrap Microsoft.Xrm.Data.PowerShell -module cmdlets.

The idea is to generate power user tools for use with Dynamics 365 Customer Engagement (CRM). The cmdlets that the Microsoft.Xrm.Data.PowerShell module provides are fine for static scripts but not for "day-to-day" stuff as they are quite verbose. This project is all about generating easy to use commands that "just work". You can obviously use these in your scripts as well.

Right now  the following attribute types are supported:
- string
- Double
- DateTime
- Lookup
- Picklist
- Money
- Integer
- BigInt
- Decimal
- Boolean
- Memo

Support is planned for PartyList, State and Status types.

Check the test file to see examples on how to call the generator and how to use resulting functions. There are templates for Get, New, Set and Remove -verbs. Eg. generating all four for Account would result in these functions:
- Get-XrmAccount
- New-XrmAccount
- Set-XrmAccount
- Remove-XrmAccount
 
 Stubs of these can be found Tests\GeneratedFunctions-folder.

To get a nice ordered attribute list to use with this you should probably do it in Excel. But you can use the Xrm.Data-cmdlets and crm metadata like this if you like ([example here](https://github.com/kabtoffe/xrm-powershell-advanced-function-generator/blob/master/Examples/GenerateFunctions.ps1)). If you run into duplicate display names you need to filter those out. Might be easier to just filter to the attributes you actually need.