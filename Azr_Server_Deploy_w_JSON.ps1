
param(
    [string]$VMName,
    [string][ValidateSet("EastUS","WestEurope","SoutheastAsia")]$Location,
    [string][ValidateSet("Standard_D1_v2","Standard_D2_v2","Standard_D3_v2")]$VMSize,
    [string][ValidateSet("2012-R2-Datacenter","2008-R2-SP1")]$OS
    )

Login-AzureRmAccount 

$date = get-date -Format M.d.yy_h.m.stt
$user = [environment]::UserName
$DeplpoymentName = "$VMName" + "_$user" + "_$date"
$templateFilePath = "$path" + "\Azure_VM_Deploy_Prod.json"
$templateParamFilePath = "$path" + "\Azure_VM_Deploy_Prod_Param.json"

Write-Host "VMName is $VMName"
Write-Host "Location is $Location"
Write-Host "VMSize is $VMSize"
Write-Host "OS is $OS"

if ($Location -like "EastUS")
    {
    $RGName = "EastUS-RG"
    $VNetName = "EastUS-VNet"
    $SubnetName =  "EastUS-InternalSubnet"
    $StorageAccount = "useaststorageaccount"
    }
if ($Location -like "WestEurope")
    {
    $RGName = "WEurope-RG"
    $VNetName = "WEurope-VNet"
    $SubnetName =  "WEurope-InternalSubnet"
    $StorageAccount = "weuropestorageaccount"
    }
if ($Location -like "SoutheastAsia")
    {
    $RGName = "SEAsia-RG"
    $VNetName = "SEAsia-VNet"
    $SubnetName =  "SEAsia_InternalSubnet"
    $StorageAccount = "seasiastorageaccount"
    }

$RGName
$VNetName
$SubnetName
$StorageAccount

New-AzureRmResourceGroupDeployment `
-Name $DeplpoymentName `
-ResourceGroupName $RGName `
-Mode Incremental `
-TemplateFile $templateFilePath `
-TemplateParameterFile $templateParamFilePath `
-location $Location `
-resourceGroupFromTemplate $RGName `
-vmName $VMName `
-vmSize $VMSize `
-operatingSystem $OS `
-VNetName $VNetName `
-Subnet $SubnetName `
-StorageAccount $StorageAccount -Verbose