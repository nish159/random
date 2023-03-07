<#
    Note that this function uses the Azure PowerShell cmdlets to interact with Azure Storage. 
    In order to use these cmdlets, you will need to install the Azure PowerShell module and 
    authenticate to your Azure account.

function UploadFileToBlob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Net.Http.HttpRequestMessage]$Request,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSObject]$TriggerMetadata,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSObject]$BindingData,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSObject]$Log
    )

    try {
        # Get the file from the request body
        $file = $Request.Content.ReadAsMultipartAsync().Result.Contents[0]

        # Read the file content
        $fileContent = $file.ReadAsByteArrayAsync().Result

        # Connect to Azure Storage
        $connectionString = $env:StorageConnectionString
        $blobServiceClient = New-AzureStorageBlobClient -ConnectionString $connectionString

        # Get a reference to the container
        $containerName = "file-upload"
        $containerClient = $blobServiceClient.GetContainerReference($containerName)

        # Create the container if it doesn't exist
        if (-not ($containerClient.Exists())) {
            $containerClient.Create()
        }

        # Get a reference to the blob
        $fileName = $file.Headers.ContentDisposition.FileName
        $blobClient = $containerClient.GetBlockBlobReference($fileName)

        # Upload the file to the blob
        $blobClient.UploadFromByteArrayAsync($fileContent, 0, $fileContent.Length).Wait()

        # Return success message
        return [System.Web.Http.Results.OkObjectResult]::new("File $fileName uploaded to container $containerName")
    }
    catch {
        $errorMessage = $_.Exception.Message
        $Log.Error($errorMessage)
        return [System.Web.Http.Results.BadRequestObjectResult]::new("Error uploading file to blob storage: $errorMessage")
    }
}
#>

# Create a new storage account and upload to ABS
param(
    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountKey,

    [Parameter(Mandatory = $true)]
    [string]$ContainerName,

    [Parameter(Mandatory = $true)]
    [string]$LocalFilePath,

    [Parameter(Mandatory = $true)]
    [string]$BlobName
)

# Authenticate to Azure
Connect-AzAccount

# Create a storage context
$storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

# Upload the file to the Blob Storage container
Set-AzStorageBlobContent -Context $storageContext -Container $ContainerName -File $LocalFilePath -Blob $BlobName

# Upload to an existing storage account
param(
    [Parameter(Mandatory = $true)]
    [string]$ContainerName,

    [Parameter(Mandatory = $true)]
    [string]$LocalFilePath,

    [Parameter(Mandatory = $true)]
    [string]$BlobName,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountKey
)

# Create a storage context
$storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

# Upload the file to the Blob Storage container
Set-AzStorageBlobContent -Context $storageContext -Container $ContainerName -File $LocalFilePath -Blob $BlobName

# Upload to existing storage account values without hardcoding the values
param(
    [Parameter(Mandatory = $true)]
    [string]$ContainerName,

    [Parameter(Mandatory = $true)]
    [string]$LocalFilePath,

    [Parameter(Mandatory = $true)]
    [string]$BlobName,

    [Parameter(Mandatory = $true)]
    [string]$KeyVaultName,

    [Parameter(Mandatory = $true)]
    [string]$SecretNameClientId,

    [Parameter(Mandatory = $true)]
    [string]$SecretNameClientSecret
)

# Authenticate to Azure using a service principal
$clientId = (Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $SecretNameClientId).SecretValueText
$clientSecret = (Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $SecretNameClientSecret).SecretValueText
$tenantId = (Get-AzContext).Tenant.Id

$securePassword = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$psCredential = New-Object System.Management.Automation.PSCredential($clientId, $securePassword)

Connect-AzAccount -ServicePrincipal -Credential $psCredential -TenantId $tenantId

# Get the storage account name and access key from Key Vault
$storageAccountName = (Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name "<storage account name>").SecretValueText
$storageAccountKey = (Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name "<storage account key>").SecretValueText

# Create a storage context
$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# Upload the file to the Blob Storage container
Set-AzStorageBlobContent -Context $storageContext -Container $ContainerName -File $LocalFilePath -Blob $BlobName


