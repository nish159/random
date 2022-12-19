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
