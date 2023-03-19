param(
    [Parameter(Mandatory=$true)]
    [string]$StorageAccountName,
    
    [Parameter(Mandatory=$true)]
    [string]$StorageAccountKey
)

# Set up variables for the script
$ContainerName = "your_container_name"
$CsvFilePath = "C:\path\to\your\csv_file.csv"
$CsvFileName = "csv_file.csv"

# Connect to the Azure Storage Account
$Context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

# Upload the CSV file to the Storage Account
Set-AzureStorageBlobContent -Container $ContainerName -File $CsvFilePath -Blob $CsvFileName -Context $Context

###########################################################################################################################

# Set up variables for the script
$StorageAccountName = "your_storage_account_name"
$StorageAccountKey = "your_storage_account_key"
$ContainerName = "your_container_name"
$BlobName = "csv_file.csv"
$TableName = "your_table_name"
$DataFactoryName = "your_data_factory_name"
$PipelineName = "your_pipeline_name"

# Connect to the Azure Storage Account
$Context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

# Get the shared access signature (SAS) URL for the blob
$SasUrl = New-AzureStorageBlobSASToken -Container $ContainerName -Blob $BlobName -Context $Context -Permission r

# Set up the JSON format settings for the data source
$JsonFormatSettings = @{
    "type" = "JsonFormat"
    "filePattern" = $BlobName
}

# Set up the Azure Data Factory data source
$DataSource = @{
    "type" = "AzureBlobStorage"
    "linkedServiceName" = "your_linked_service_name"
    "typeProperties" = @{
        "accountName" = $StorageAccountName
        "accountKey" = $StorageAccountKey
        "containerName" = $ContainerName
        "fileName" = $BlobName
    }
    "format" = $JsonFormatSettings
}

# Set up the Azure Data Factory data sink
$DataSink = @{
    "type" = "AzureTableStorage"
    "linkedServiceName" = "your_linked_service_name"
    "typeProperties" = @{
        "tableName" = $TableName
    }
}

# Set up the Azure Data Factory copy activity
$CopyActivity = @{
    "name" = "CopyFromBlobToTable"
    "inputs" = @($DataSource)
    "outputs" = @($DataSink)
    "type" = "Copy"
    "source" = @{
        "type" = "BlobSource"
        "recursive" = $false
    }
    "sink" = @{
        "type" = "AzureTableStorageSink"
    }
}

# Set up the Azure Data Factory pipeline
$Pipeline = @{
    "name" = $PipelineName
    "activities" = @($CopyActivity)
}

# Get the Azure Data Factory object
$DataFactory = Get-AzDataFactoryV2 -Name $DataFactoryName -ResourceGroupName "your_resource_group_name"

# Create or update the Azure Data Factory pipeline
Set-AzDataFactoryV2Pipeline -DataFactory $DataFactory -DefinitionFile $Pipeline -Force
