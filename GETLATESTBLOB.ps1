# GLOBAL VARIABLES 
$resourceGroupName = "resourceGroup"
$storageAccountName = "storageAccount"
$containerName = "container"
$topLevelFolder = "parentFolder"
$folder = "folder" 
$keyVault = ""
$secret = ""

<#
  IF A FOLDER HAS A PATH YOU CAN USE THE FOLLOWING 
  $TOPLEVELFOLDER = "< PARENT DIRECTORY >"

  IF CONTAINER HAS MULTIPLE FOLDERS CREATE AN ARRAY
  $FOLDERNAMES = @("< LIST FOLDERS HERE >", "< ANOTHER FOLDER >")

  FOREACH ($FOLDER IN $FOLDERS) 
  {
    $BLOB = GET-AZSTORAGEBLOB -CONTAINER $CONTAINERNAME -CONTEXT $CONTEXT -PREFIX $TOPLEVELFOLDER/$FOLDER | SELECT -LAST 1
  }
#>

# SIGN INTO YOUR AZURE ACCOUNT 
Connect-AzAccount

# SET THE CONTEXT FOR YOUR STORAGE ACCOUNT 
$getSasToken = Get-AzKeyVault -VaultName $keyVault -Name $secret -AsPlainText
$context = New-AzStorageContext -StorageAccountName $storageAccountName -SasToken $getSasToken

# LIST BLOBS WITHIN THE SPECIFIED FOLDER 
$blobs = Get-AzStorageBlob -Container $containerName -Context $context -Prefix $topLevelFolder/$folder

# SORT THE BLOBS BY LAST MODIFIED TIMESTAMP IN DESCENDING ORDER 
$latestBlob = $blobs | Sort-Object LastModified -Descending | Select-Object -First 1

# DISPLAY INFORMATION ABOUT THE LATEST BLOB 
if($latestBlob) {
    Write-Host "LATEST VERSION OF '$topLevelFolder' IN '$container' CONTAINER OF '$storageAccount':" -ForegroundColor Yellow
    Write-Host "    NAME: $($latestBlob.Name)"
    Write-Host "    BLOB: $($latestBlob.BlobType)"
    Write-Host "    SIZE: $($latestBlob.Length) BYTES"
    Write-Host "    LAST MODIFIED: $($latestBlob.LastModified)"
    Write-Host ""
} else {
    Write-Host "NO BLOB FOUND IN '$container' CONTAINER OF '$storageAccount'" -ForegroundColor Red
}

# OUTPUT THE DETAILS OF THE MOST RECENT BLOB 
# return $latestBlob
