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

####################################################################################################################################################

# Define variables
$StorageAccountName = "<storage_account_name>"
$StorageAccountKey = "<storage_account_key>"
$ContainerName = "<container_name>"
$BlobName = "<blob_name>"
$DataFactoryName = "<data_factory_name>"
$ResourceGroupName = "<resource_group_name>"
$DataFactorySubscriptionId = "<subscription_id>"

# Connect to Azure and select subscription
Connect-AzAccount
Select-AzSubscription -SubscriptionId $DataFactorySubscriptionId

# Get storage account key
$StorageAccountContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

# Get the blob
$Blob = Get-AzStorageBlob -Context $StorageAccountContext -Container $ContainerName -Blob $BlobName

# Upload the blob to the data factory
$DataFactory = Get-AzDataFactoryV2 -ResourceGroupName $ResourceGroupName -Name $DataFactoryName
$Dataset = Get-AzDataFactoryV2Dataset -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -Name "<dataset_name>"

# Set the input path for the dataset
$InputPath = $Dataset.Properties.TypeProperties.Location.Path
$InputPath = $InputPath -replace "\\$"

# Upload the blob to the input path
Set-AzDataFactoryV2BlobDataset -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -Name "<dataset_name>" -StorageAccountName $StorageAccountName -StoragePath "$ContainerName/$BlobName" -ItemType "Binary" -InputPath $InputPath

