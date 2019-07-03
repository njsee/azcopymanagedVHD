# Amended & Updated version of 
# https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-windows-powershell-sample-copy-managed-disks-vhd
# Niall Currid rev 1.0 3/Jul/2019

# Set Variables

#Provide the subscription Id of the subscription where managed disk is created
#$subscriptionId = <sub ID>

#Provide storage account name where you want to copy the underlying VHD of the managed disk. 
$destinationstorageaccount = 

#Provide the name of your resource group where managed is created
$ResourceGroupName = 

#Provide the managed disk name 
$diskName = 

#Provide Shared Access Signature (SAS) expiry duration in seconds e.g. 3600.
$sasExpiryDuration = 3600

#Name of the storage container where the downloaded VHD will be stored
$storageContainerName = 

#Destination VHD filename
$destinationVHDFileName = 

# Set the context to the subscription Id where managed disk is created
#Select-AzSubscription -SubscriptionId $SubscriptionId

# Grant Access to Source VHD with Grant-AzdiskAccess
$sas = Grant-AzDiskAccess -ResourceGroupName $ResourceGroupName -DiskName $diskName -DurationInSecond $sasExpiryDuration -Access Read

# Get the destination blob storage account key
$dstkey = Get-AzStorageAccountKey -StorageAccountName $destinationstorageaccount -ResourceGroupName $ResourceGroupName

# Set the Storage context
$dstcontext = New-AzStorageContext -StorageAccountName $destinationstorageaccount -StorageAccountKey $dstkey.Value[0]

# Create SASURI for Blob Account container Target
$containerSASURI = New-AzStorageContainerSASToken -Context $dstContext -ExpiryTime(get-date).AddSeconds($sasExpiryDuration) -FullUri -Name $storageContainerName -Permission rw

# copy job
.\azcopy copy $sas.AccessSAS $containerSASURI